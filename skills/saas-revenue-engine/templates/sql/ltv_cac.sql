-- ltv_cac.sql
-- Monthly LTV, CAC, CAC payback and LTV:CAC (PostgreSQL 13+). Requires schema.sql.
--
-- Assumptions:
--   * Spend comes from acquisition_spend (sales and marketing cost by month and
--     category, loaded from the ledger). Fully loaded CAC uses every category;
--     paid CAC uses only cost_category = 'paid_media' and accounts whose
--     acquisition_type = 'paid'.
--   * New customers = accounts whose first_mrr_month is the month (reactivations
--     are not new customers).
--   * Spend is smoothed with a trailing 3-month window on both numerator and
--     denominator to reduce lag noise. For long sales cycles, shift spend by
--     spend_lag_months (spend in m - lag attributed to customers in m).
--   * gross_margin is a parameter; replace with your measured subscription gross
--     margin (revenue minus hosting, support, onboarding, payment fees).
--   * LTV uses trailing 3-month average monthly revenue churn, margin adjusted and
--     capped at horizon_months to avoid infinite lifetimes when churn is tiny.
--     When net churn is negative (NRR above 100 percent) validate LTV against
--     observed cohort cumulative gross profit instead.
--   * Payback uses ARPA of NEW customers, not blended ARPA.
--   * least() ignores NULL, so a zero or undefined churn rate yields the horizon cap
--     (ARPA * margin * horizon_months) rather than an infinite or missing LTV.

WITH params AS (
    SELECT 0.75::numeric AS gross_margin,
           60            AS horizon_months,
           0             AS spend_lag_months
),
mrr AS (
    SELECT v.account_id,
           v.month_start,
           v.first_mrr_month,
           v.mrr_cents,
           coalesce(lag(v.mrr_cents) OVER (PARTITION BY v.account_id ORDER BY v.month_start), 0) AS prev_mrr
    FROM v_account_mrr_monthly v
),
monthly AS (
    SELECT m.month_start,
           sum(m.mrr_cents)                                                     AS closing_mrr,
           sum(m.prev_mrr)                                                      AS opening_mrr,
           count(*) FILTER (WHERE m.mrr_cents > 0)                              AS paying_accounts,
           count(*) FILTER (WHERE m.month_start = m.first_mrr_month)            AS new_customers,
           count(*) FILTER (WHERE m.month_start = m.first_mrr_month
                              AND a.acquisition_type = 'paid')                  AS new_paid_customers,
           sum(m.mrr_cents) FILTER (WHERE m.month_start = m.first_mrr_month)    AS new_customer_mrr,
           sum(m.prev_mrr - m.mrr_cents) FILTER (WHERE m.prev_mrr > m.mrr_cents) AS lost_mrr  -- churn + contraction
    FROM mrr m
    JOIN accounts a ON a.account_id = m.account_id
    GROUP BY m.month_start
),
spend AS (
    SELECT (s.month_start + make_interval(months => p.spend_lag_months))::date AS month_start,
           sum(s.amount_cents)                                                AS total_spend,
           sum(s.amount_cents) FILTER (WHERE s.cost_category = 'paid_media')   AS paid_spend
    FROM acquisition_spend s
    CROSS JOIN params p
    GROUP BY 1
),
joined AS (
    SELECT mo.month_start,
           mo.closing_mrr,
           mo.opening_mrr,
           mo.paying_accounts,
           mo.new_customers,
           mo.new_paid_customers,
           coalesce(mo.new_customer_mrr, 0) AS new_customer_mrr,
           coalesce(mo.lost_mrr, 0)         AS lost_mrr,
           coalesce(sp.total_spend, 0)      AS total_spend,
           coalesce(sp.paid_spend, 0)       AS paid_spend
    FROM monthly mo
    LEFT JOIN spend sp ON sp.month_start = mo.month_start
),
rolling AS (
    SELECT j.*,
           sum(total_spend)       OVER w3 AS spend_3m,
           sum(paid_spend)        OVER w3 AS paid_spend_3m,
           sum(new_customers)     OVER w3 AS new_customers_3m,
           sum(new_paid_customers) OVER w3 AS new_paid_customers_3m,
           sum(new_customer_mrr)  OVER w3 AS new_customer_mrr_3m,
           sum(lost_mrr)          OVER w3 AS lost_mrr_3m,
           sum(opening_mrr)       OVER w3 AS opening_mrr_3m
    FROM joined j
    WINDOW w3 AS (ORDER BY month_start ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
),
metrics AS (
    SELECT t.month_start,
           t.paying_accounts,
           t.new_customers,
           t.closing_mrr / nullif(t.paying_accounts, 0)                     AS arpa_cents,
           t.new_customer_mrr_3m / nullif(t.new_customers_3m, 0)           AS new_arpa_cents,
           t.lost_mrr_3m / nullif(t.opening_mrr_3m, 0)                     AS monthly_gross_revenue_churn,
           t.spend_3m / nullif(t.new_customers_3m, 0)                      AS blended_cac_cents,
           t.paid_spend_3m / nullif(t.new_paid_customers_3m, 0)            AS paid_cac_cents,
           p.gross_margin,
           p.horizon_months
    FROM rolling t
    CROSS JOIN params p
)
SELECT month_start,
       paying_accounts,
       new_customers,
       round(arpa_cents / 100.0, 2)                                         AS arpa,
       round(new_arpa_cents / 100.0, 2)                                     AS new_customer_arpa,
       round(monthly_gross_revenue_churn, 4)                                AS monthly_gross_revenue_churn_3m,
       round(arpa_cents / nullif(monthly_gross_revenue_churn, 0) / 100.0, 2) AS ltv_simple_uncapped,
       round(arpa_cents * gross_margin
             * least(1 / nullif(monthly_gross_revenue_churn, 0), horizon_months) / 100.0, 2) AS ltv_margin_capped,
       round(blended_cac_cents / 100.0, 2)                                  AS blended_cac_fully_loaded,
       round(paid_cac_cents / 100.0, 2)                                     AS paid_cac,
       round(blended_cac_cents / nullif(new_arpa_cents * gross_margin, 0), 1) AS cac_payback_months,
       round(arpa_cents * gross_margin
             * least(1 / nullif(monthly_gross_revenue_churn, 0), horizon_months)
             / nullif(blended_cac_cents, 0), 2)                             AS ltv_to_cac
FROM metrics
ORDER BY month_start;
