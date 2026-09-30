-- schema.sql
-- Minimal reference schema for SaaS revenue analytics (PostgreSQL 13+).
--
-- Assumptions:
--   * Single reporting currency. Convert to it upstream; amounts are integer cents.
--   * Subscription items are versioned with validity intervals [valid_from, valid_to).
--     Any change (quantity, price, plan, discount) closes the current row
--     (sets valid_to) and inserts a new one. This makes MRR reproducible for any date.
--   * MRR counts only recurring items, after trial end, before subscription end.
--   * lifecycle_stage_transitions is append-only (enforced by trigger below).
--   * acquisition_spend holds sales and marketing cost by month and category,
--     loaded from the general ledger; it feeds CAC in ltv_cac.sql.
--   * v_account_mrr_monthly is the single shared MRR source for every other query.
--     The current month is in progress; its "month end" MRR is as of now.

CREATE TABLE IF NOT EXISTS plans (
    plan_id              bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code                 text        NOT NULL UNIQUE,
    name                 text        NOT NULL,
    tier                 text,
    interval_months      integer     NOT NULL CHECK (interval_months > 0),
    list_price_cents     bigint      NOT NULL CHECK (list_price_cents >= 0),
    is_recurring         boolean     NOT NULL DEFAULT true,
    is_active            boolean     NOT NULL DEFAULT true
);

CREATE TABLE IF NOT EXISTS accounts (
    account_id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name                 text        NOT NULL,
    segment              text,                  -- e.g. self_serve, mid_market, enterprise
    acquisition_channel  text,                  -- e.g. organic, paid_search, outbound
    acquisition_type     text CHECK (acquisition_type IN ('paid', 'organic', 'sales', 'partner', 'unknown')),
    crm_account_id       text UNIQUE,
    is_test              boolean     NOT NULL DEFAULT false,
    created_at           timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS users (
    user_id              bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_id           bigint REFERENCES accounts (account_id),
    email                text        NOT NULL UNIQUE,
    signup_source        text,
    account_match_method text,                  -- e.g. workspace_invite, crm_id, verified_domain
    created_at           timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS subscriptions (
    subscription_id      bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_id           bigint      NOT NULL REFERENCES accounts (account_id),
    status               text        NOT NULL CHECK (status IN ('trialing', 'active', 'past_due', 'paused', 'canceled', 'ended')),
    started_at           timestamptz NOT NULL,
    trial_ends_at        timestamptz,
    cancel_requested_at  timestamptz,           -- cancel click; not churn
    ended_at             timestamptz,           -- effective end of paid service; churn timing
    external_id          text UNIQUE,           -- billing system ID
    created_at           timestamptz NOT NULL DEFAULT now(),
    CHECK (ended_at IS NULL OR ended_at >= started_at)
);

CREATE TABLE IF NOT EXISTS subscription_items (
    subscription_item_id  bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    subscription_id       bigint      NOT NULL REFERENCES subscriptions (subscription_id),
    plan_id               bigint      NOT NULL REFERENCES plans (plan_id),
    quantity              integer     NOT NULL DEFAULT 1 CHECK (quantity >= 0),
    unit_amount_cents     bigint      NOT NULL CHECK (unit_amount_cents >= 0),  -- price per interval
    discount_amount_cents bigint      NOT NULL DEFAULT 0 CHECK (discount_amount_cents >= 0), -- recurring discount per interval
    interval_months       integer     NOT NULL CHECK (interval_months > 0),
    is_recurring          boolean     NOT NULL DEFAULT true,  -- false for setup fees, services
    valid_from            timestamptz NOT NULL,
    valid_to              timestamptz,          -- exclusive; NULL means current
    CHECK (valid_to IS NULL OR valid_to > valid_from)
);

CREATE INDEX IF NOT EXISTS subscription_items_validity_idx
    ON subscription_items (subscription_id, valid_from, valid_to);

CREATE TABLE IF NOT EXISTS invoices (
    invoice_id            bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_id            bigint      NOT NULL REFERENCES accounts (account_id),
    subscription_id       bigint REFERENCES subscriptions (subscription_id),
    status                text        NOT NULL CHECK (status IN ('draft', 'open', 'paid', 'void', 'uncollectible')),
    issued_at             timestamptz NOT NULL,
    period_start          timestamptz,
    period_end            timestamptz,
    recurring_amount_cents bigint     NOT NULL DEFAULT 0,
    one_time_amount_cents bigint      NOT NULL DEFAULT 0,
    tax_cents             bigint      NOT NULL DEFAULT 0,
    total_cents           bigint GENERATED ALWAYS AS (recurring_amount_cents + one_time_amount_cents + tax_cents) STORED,
    paid_at               timestamptz
);

CREATE TABLE IF NOT EXISTS events (
    event_id              bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_name            text        NOT NULL,  -- e.g. user_signed_up, account_activated
    account_id            bigint REFERENCES accounts (account_id),
    user_id               bigint REFERENCES users (user_id),
    anonymous_id          text,
    occurred_at           timestamptz NOT NULL,  -- business time
    received_at           timestamptz NOT NULL DEFAULT now(),  -- ingestion time
    source_system         text        NOT NULL DEFAULT 'product',
    idempotency_key       text UNIQUE,
    properties            jsonb       NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS events_name_time_idx ON events (event_name, occurred_at);
CREATE INDEX IF NOT EXISTS events_account_time_idx ON events (account_id, occurred_at);

CREATE TABLE IF NOT EXISTS lifecycle_stage_transitions (
    transition_id         bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    entity_type           text        NOT NULL CHECK (entity_type IN ('account', 'user')),
    entity_id             bigint      NOT NULL,
    from_stage            text,
    to_stage              text        NOT NULL CHECK (to_stage IN (
                              'visitor', 'lead', 'signup', 'qualified_lead', 'opportunity',
                              'customer', 'onboarded', 'activated', 'retained', 'expanded',
                              'churned', 'reactivated', 'disqualified', 'closed_lost', 'dormant')),
    qualification_basis   text CHECK (qualification_basis IN ('marketing', 'product', 'sales')),
    transitioned_at       timestamptz NOT NULL,  -- business time of the transition
    recorded_at           timestamptz NOT NULL DEFAULT now(),  -- when this row was written
    source_system         text        NOT NULL,  -- billing, crm, product, manual
    source_event_id       bigint REFERENCES events (event_id),
    actor                 text,                  -- user or job that caused it
    reason                text,
    UNIQUE (entity_type, entity_id, to_stage, transitioned_at)
);

CREATE INDEX IF NOT EXISTS lst_entity_time_idx
    ON lifecycle_stage_transitions (entity_type, entity_id, transitioned_at);

-- Append-only enforcement: corrections are new compensating rows, never edits.
CREATE OR REPLACE FUNCTION forbid_transition_mutation() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'lifecycle_stage_transitions is append-only; insert a compensating transition instead';
END;
$$;

DROP TRIGGER IF EXISTS lst_append_only ON lifecycle_stage_transitions;
CREATE TRIGGER lst_append_only
    BEFORE UPDATE OR DELETE ON lifecycle_stage_transitions
    FOR EACH ROW EXECUTE FUNCTION forbid_transition_mutation();

-- Sales and marketing cost by month for CAC. One row per month, channel and category.
CREATE TABLE IF NOT EXISTS acquisition_spend (
    month_start           date        NOT NULL CHECK (month_start = date_trunc('month', month_start)::date),
    channel               text        NOT NULL,  -- e.g. paid_search, events, outbound, all
    cost_category         text        NOT NULL CHECK (cost_category IN (
                              'paid_media', 'sales_compensation', 'marketing_compensation',
                              'tools', 'agencies', 'overhead_allocation', 'other')),
    amount_cents          bigint      NOT NULL CHECK (amount_cents >= 0),
    PRIMARY KEY (month_start, channel, cost_category)
);

-- Shared month-end MRR per account. One row per account per month from its first
-- paid month through the current month, including zero-MRR months (needed for
-- churn and reactivation). mrr_cents is numeric to keep fractional cents from
-- multi-month intervals; round only for display.
CREATE OR REPLACE VIEW v_account_mrr_monthly AS
WITH bounds AS (
    SELECT date_trunc('month', min(valid_from))::date AS first_month,
           date_trunc('month', now())::date           AS last_month
    FROM subscription_items
),
months AS (
    SELECT gs::date AS month_start,
           (gs + interval '1 month') AS snapshot_boundary   -- exclusive month end
    FROM bounds b,
         generate_series(b.first_month, b.last_month, interval '1 month') AS gs
),
item_mrr AS (
    SELECT m.month_start,
           s.account_id,
           sum((si.unit_amount_cents * si.quantity - si.discount_amount_cents)::numeric
               / si.interval_months) AS mrr_cents
    FROM months m
    JOIN subscription_items si
      ON si.valid_from < m.snapshot_boundary
     AND (si.valid_to IS NULL OR si.valid_to >= m.snapshot_boundary)
    JOIN subscriptions s ON s.subscription_id = si.subscription_id
    JOIN accounts a      ON a.account_id = s.account_id
    WHERE si.is_recurring
      AND NOT a.is_test
      AND (s.trial_ends_at IS NULL OR s.trial_ends_at < m.snapshot_boundary)
      AND (s.ended_at IS NULL OR s.ended_at >= m.snapshot_boundary)
      -- subscriptions.status is current state only, so it is not used for history.
      -- Pauses must close item rows (valid_to) to drop MRR to zero for the pause.
    GROUP BY m.month_start, s.account_id
),
first_paid AS (
    SELECT account_id, min(month_start) AS first_mrr_month
    FROM item_mrr
    WHERE mrr_cents > 0
    GROUP BY account_id
)
SELECT f.account_id,
       m.month_start,
       f.first_mrr_month,
       greatest(coalesce(i.mrr_cents, 0), 0) AS mrr_cents
FROM first_paid f
JOIN months m
  ON m.month_start >= f.first_mrr_month
LEFT JOIN item_mrr i
  ON i.account_id = f.account_id
 AND i.month_start = m.month_start;
