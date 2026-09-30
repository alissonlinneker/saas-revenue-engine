# Data and Instrumentation

> Scope: how a SaaS codebase captures, joins, and trusts the data that revenue decisions depend on. Load when: auditing tracking, billing webhooks, CRM sync, or metric trustworthiness, or when building any of them.

## Why it matters

Every revenue metric (conversion, activation, net revenue retention, churn) is a join across systems that were never designed to agree. If identities do not resolve, events are named inconsistently, or webhooks are processed twice, the numbers drift and teams stop trusting dashboards. Get the plumbing right early and every later analysis becomes cheap.

## Core principles

1. **Name one system of record per entity.** Write it down.
2. **Resolve identity at the account level, not only the user level.** B2B revenue belongs to accounts; users come and go.
3. **Track revenue-relevant events on the server.** Client-side tracking is for UI behavior; anything tied to money, plan, or lifecycle stage is emitted from the backend.
4. **Treat billing webhooks as an unreliable, unordered, at-least-once stream.** Verify, deduplicate, reorder by state, and make handlers idempotent.
5. **Use one naming convention and enforce it in code.** `object_action` in snake_case, past tense, singular object: `subscription_upgraded`, not `UpgradeClicked` or `upgrade`.
6. **Version the tracking plan with the code.** A tracking plan in a spreadsheet drifts; a YAML file in the repository reviewed in pull requests does not.
7. **Test data like code.** Uniqueness, not-null, referential integrity, freshness, and reconciliation against billing run on a schedule and alert.
8. **Collect the minimum personal data needed, and respect consent before sending anything to third parties.**
9. **Design for replay and backfill from day one.** Store raw events and raw webhook payloads so models can be rebuilt.

## Model / framework

### Systems of record

| Entity | System of record | Typical copies | Sync direction |
|---|---|---|---|
| User, workspace, account, membership | Product database | CRM, analytics, support | Product to others |
| Product usage events | Event pipeline / warehouse | Product analytics tool, CRM (aggregated) | Pipeline to others |
| Customer, subscription, invoice, payment | Billing provider | Product DB (cached state), warehouse, CRM | Billing to others via webhooks |
| Lead, contact, opportunity, deal stage, owner | CRM | Warehouse | CRM to warehouse; limited product fields back |
| Ticket, conversation, CSAT | Support tool | Warehouse, CRM (summary) | Support to others |
| Metric definitions | Metrics layer in the warehouse | Dashboards | Warehouse to BI |

Rules of thumb:

- Plan entitlements live in the product DB but are **derived** from billing state, never edited by hand in both places.
- The CRM never overwrites product or billing facts. Sales-owned fields (owner, deal stage, forecast category) flow the other way.

### Identity resolution

Store a crosswalk so any record can be joined to any other.

| Identifier | Created by | Stored where | Notes |
|---|---|---|---|
| `anonymous_id` | Client SDK on first visit | Cookie / local storage, events | Stitched to `user_id` at signup or login |
| `user_id` | Product DB | Every event after auth | Immutable internal ID, never email |
| `account_id` (or `workspace_id`) | Product DB | Every event as a group property | The revenue unit in B2B |
| `billing_customer_id` | Billing provider | `accounts` table column | One per paying account; set at first checkout |
| `crm_account_id`, `crm_contact_id` | CRM | `accounts` / `users` columns or mapping table | Written back after first sync |
| `support_org_id` | Support tool | Mapping table | Match on `account_id` passed in widget metadata |

Implementation notes:

- Call `identify(user_id)` on signup and every login, and `group(account_id)` whenever the active workspace changes.
- Never use email as a primary key. People change emails and share them across workspaces.
- Pass `account_id` as metadata into the billing customer, the CRM account, and the support widget at creation time. Matching on domain later is a fallback, not a strategy.
- Keep an `identity_map` table (or dbt model) with one row per `(source, source_id, account_id, user_id, valid_from)`.

### Event taxonomy

Naming: `object_action`, snake_case, past tense. Objects are nouns from your domain (`project`, `report`, `invoice`), actions are verbs (`created`, `viewed`, `shared`, `upgraded`). Properties are snake_case nouns.

| Category | Example events | Source |
|---|---|---|
| Acquisition | `page_viewed`, `demo_requested`, `trial_started` | Client for pages, server for forms |
| Signup | `user_signed_up`, `email_verified`, `workspace_created` | Server |
| Activation | `teammate_invited`, `integration_connected`, `first_value_reached` | Server |
| Core usage | `project_created`, `report_exported` | Server preferred |
| Billing | `checkout_started`, `subscription_created`, `invoice_paid`, `payment_failed` | Server and webhook |
| Subscription change | `subscription_upgraded`, `subscription_downgraded`, `seat_count_changed` | Webhook |
| Support | `ticket_created`, `ticket_resolved` | Support tool webhook |
| Cancellation | `cancellation_requested`, `subscription_canceled`, `subscription_reactivated` | Server and webhook |

Required properties on every event:

| Property | Type | Why |
|---|---|---|
| `event_id` | string (UUID) | Deduplication |
| `event_name` | string | Taxonomy |
| `occurred_at` | timestamp UTC | Ordering and cohorts |
| `user_id` or `anonymous_id` | string | Person-level joins |
| `account_id` | string | Revenue joins |
| `source` | enum client/server/webhook | Debugging and trust |
| `schema_version` | integer | Safe evolution |
| `environment` | enum production/staging | Keep test data out |

Revenue events also carry `plan_id`, `billing_interval`, `mrr_delta` (integer minor units), and `currency`.

### Server-side versus client-side

| Use client-side for | Use server-side for |
|---|---|
| Page and screen views, UI interactions, feature discovery clicks | Signup, activation milestones, anything plan or billing related |
| Marketing attribution parameters (UTM, referrer) captured on landing | Lifecycle stage changes, CRM triggers, usage metering |
| Experiment exposure in the UI | Anything used in a board metric or invoice |

Client events are lost to ad blockers, closed tabs, and consent refusals; expect a meaningful and variable share to go missing. Capture UTM and referrer on the first page, persist them, and attach them server-side at signup so attribution survives.

### Billing webhooks

| Concern | Required handling |
|---|---|
| Authenticity | Verify the signature with the raw request body and the endpoint secret before parsing. Reject on failure with 400. |
| Duplicates | Store the provider event ID in a `processed_webhook_events` table with a unique constraint. Skip if present. |
| Ordering | Do not assume arrival order. On each event, fetch or read the current object state (or compare `created` timestamps and versions) and apply only if newer. |
| Latency | Return 2xx fast. Persist the raw payload, enqueue a job, process asynchronously. |
| Failures | Retries from the provider are expected; the handler must be safe to run many times. Alert on repeated failures. |
| Replay | Keep raw payloads. Provide a script to reprocess a date range or a single event ID. |
| Reconciliation | Nightly job compares product DB subscription state with the billing provider API and reports drift. |
| Coverage | Handle at minimum: customer created, subscription created/updated/deleted, invoice paid, invoice payment failed, trial ending, refund, dispute. |

```python
# Illustrative handler shape
def handle_billing_webhook(request):
    event = verify_signature(request.raw_body, request.headers, SECRET)  # raises on failure
    inserted = db.insert_ignore("processed_webhook_events", id=event.id, payload=event.raw)
    if not inserted:
        return 200  # duplicate
    queue.enqueue("process_billing_event", event.id)
    return 200

def process_billing_event(event_id):
    event = db.get("processed_webhook_events", event_id)
    sub = billing_api.retrieve_subscription(event.subscription_id)  # source of truth, not payload order
    apply_subscription_state(sub)  # idempotent upsert, derives entitlements
    emit_server_event(event_type_to_name(event.type), event)
```

### CRM sync patterns

| Pattern | Use when | Watch out for |
|---|---|---|
| Reverse ETL from warehouse | You have a warehouse and modeled account metrics | Sync frequency, field ownership, API rate limits |
| Direct API from backend on key events | Early stage, few fields | Retries, rate limits, coupling to CRM uptime (use a queue) |
| Native integration from billing or analytics tool | Standard fields only | Opaque mappings, duplicate records |

Sync to the CRM: `account_id`, plan, MRR, seats, trial end date, activation status, last active date, product usage score, lifecycle stage. Sync back from the CRM: owner, deal stage, forecast category, close date. Never sync raw events into the CRM.

Deduplicate CRM accounts on `account_id` stored in a custom external ID field, not on company name or domain.

### Lifecycle stage transitions

Stages are computed in one place (the warehouse or a backend service) and pushed to the CRM. Define the trigger precisely and log every transition as an event (`lifecycle_stage_changed` with `from_stage`, `to_stage`, `reason`).

| From | To | Trigger (example definition, adapt) | Emitted by |
|---|---|---|---|
| visitor | lead | Form submitted or signup with a work email | Server |
| lead | marketing qualified | Fit score and engagement score above thresholds | Scoring job |
| lead / signed up | product qualified | Account reached activation milestone and fits target profile | Scoring job |
| qualified | sales accepted | Rep accepts in CRM within SLA | CRM |
| sales accepted | opportunity | Discovery completed, opportunity created | CRM |
| trial or opportunity | customer | First successful payment (`invoice_paid` with amount above zero) | Webhook |
| customer | expanded | MRR increased versus prior month | Warehouse job |
| customer | at risk | Health score below threshold or `payment_failed` unresolved | Scoring job |
| customer | churned | Subscription ended, not merely cancellation requested | Webhook |
| churned | reactivated | New paid subscription on same `account_id` | Webhook |

### Warehouse and metrics layer

Layer the warehouse so definitions live in code:

| Layer | Contents | Example |
|---|---|---|
| Raw | Untouched loads from each source | `raw_billing.events`, `raw_app.events` |
| Staging | Renamed, typed, deduplicated, one model per source table | `stg_billing__subscriptions` |
| Core | Joined entities with resolved identity | `dim_accounts`, `fct_subscription_changes`, `fct_events` |
| Metrics | Governed metric definitions | `mrr_by_account_month`, `net_revenue_retention` |
| Marts | Team-facing tables for dashboards | `mart_pipeline`, `mart_retention_cohorts` |

The metric definitions here must match the shared dictionary (see [10-revenue-operations.md](10-revenue-operations.md) and `templates/metrics-dictionary.yaml`).

## Metrics

**Event delivery rate**
Definition: share of expected server events that arrive in the warehouse.

```text
event_delivery_rate = events_received / events_expected_from_source_of_truth
```

Unit: percent. Grain: per event name, per day. Pitfall: comparing client events to themselves; compare to a DB count (for example, `user_signed_up` events versus new rows in `users`).

**Identity match rate**
Definition: share of paying accounts linked to billing, CRM, and product IDs.

```text
identity_match_rate = accounts_with_all_ids / paying_accounts
```

Unit: percent. Grain: per system, snapshot daily. Pitfall: counting matches made by fuzzy domain logic as full matches.

**Billing reconciliation drift**
Definition: MRR difference between the warehouse model and the billing provider for the same month.

```text
mrr_drift_pct = abs(warehouse_mrr - billing_provider_mrr) / billing_provider_mrr
```

Unit: percent. Grain: per month. Pitfall: ignoring currency conversion timing, prorations, and discounts. Target: close to zero with every difference explained.

**Webhook processing lag**
Definition: time from provider event creation to local state applied.

```text
lag = processed_at - provider_created_at   (report p50 and p95)
```

Unit: seconds. Grain: per event type, per day. Pitfall: measuring only enqueue time.

**Data test pass rate**
Definition: share of scheduled data tests passing.

```text
pass_rate = tests_passed / tests_run
```

Unit: percent. Grain: per run. Pitfall: silencing failing tests instead of fixing the source.

## Implementation guide

### Schema

```sql
-- Minimum columns that make revenue joins possible (PostgreSQL)
ALTER TABLE accounts ADD COLUMN billing_customer_id text UNIQUE;
ALTER TABLE accounts ADD COLUMN crm_account_id text UNIQUE;
ALTER TABLE accounts ADD COLUMN lifecycle_stage text NOT NULL DEFAULT 'signed_up';
ALTER TABLE accounts ADD COLUMN lifecycle_stage_changed_at timestamptz;

CREATE TABLE processed_webhook_events (
  id            text PRIMARY KEY,           -- provider event id
  provider      text NOT NULL,
  event_type    text NOT NULL,
  received_at   timestamptz NOT NULL DEFAULT now(),
  processed_at  timestamptz,
  payload       jsonb NOT NULL,
  error         text
);

CREATE TABLE lifecycle_stage_history (
  account_id  text NOT NULL,
  from_stage  text,
  to_stage    text NOT NULL,
  reason      text NOT NULL,
  changed_at  timestamptz NOT NULL DEFAULT now()
);
```

### Tracking wrapper

Route every event through one typed function that validates against the tracking plan. Direct calls to vendor SDKs scattered across the codebase are the main source of naming drift.

```typescript
// track.ts: the only place that talks to the analytics SDK
import plan from "./tracking-plan.generated";
export function track<E extends keyof typeof plan>(name: E, props: PropsOf<E>) {
  validate(plan[name], props);            // fail in dev and CI, log in prod
  sink.send({ event_id: uuid(), event_name: name, occurred_at: new Date().toISOString(),
              source: "server", schema_version: plan[name].version, ...context(), ...props });
}
```

Generate types from `templates/tracking-plan.yaml` and add a CI check that fails when code references an event name absent from the plan.

### Data quality tests

| Test | Applies to | Example |
|---|---|---|
| Unique | Primary keys, `event_id` | `stg_events.event_id` unique |
| Not null | Join keys, timestamps | `fct_subscription_changes.account_id` not null |
| Relationships | Foreign keys across sources | every `billing_customer_id` exists in `dim_accounts` |
| Accepted values | Enums | `lifecycle_stage` in the defined list |
| Freshness | Every source | billing data newer than 6 hours, alert otherwise |
| Volume anomaly | Event counts | daily `user_signed_up` within expected band |
| Reconciliation | MRR, customer counts | warehouse vs billing API within tolerance |

### Privacy and consent

- Load client analytics and ad pixels only after consent where regulation requires it; gate the SDK initialization, not only the calls.
- Keep personal data (email, name, IP) out of event properties. Reference `user_id` and look up details in the product DB when needed.
- Implement deletion: a user deletion request must propagate to analytics, CRM, support, and warehouse. Keep a deletion log.
- Document data processors and retention periods. Set retention on raw event tables.
- Separate `environment` so staging and internal test accounts never pollute production metrics; flag internal accounts with `is_internal`.

### Backfills

- Backfill from the system of record (billing API, product DB), not from reconstructed client events.
- Mark backfilled rows with `source = 'backfill'` and a `backfilled_at` timestamp.
- Backfill into staging tables first, run the full test suite, compare aggregates against known totals, then swap.
- Never emit backfilled events to live destinations (CRM, email tools) that trigger actions.

### Code-level signals to grep for

| Look for | Command sketch | What it tells you |
|---|---|---|
| Analytics calls | `grep -rnE "\.(track\|identify\|group\|capture)\(" src` | Where events are emitted, naming consistency |
| Event names | `grep -rhoE "track\(['\"][A-Za-z_ ]+" src \| sort \| uniq -c` | Mixed casing, duplicates, present tense |
| Webhook endpoints | `grep -rniE "webhook" --include=*.{py,ts,js,rb,go} .` | Handlers to audit |
| Signature checks | `grep -rniE "construct_?event\|verify.*signature\|webhook_secret" .` | Missing verification |
| Idempotency | `grep -rniE "processed_.*events\|idempoten\|event\.id" .` | Dedup present or not |
| Raw body use | `grep -rniE "raw_?body\|express\.raw\|request\.data" .` | Signature verification done on raw bytes |
| Billing IDs on accounts | `grep -rniE "billing_customer_id\|customer_id" migrations db` | Identity crosswalk |
| CRM clients | `grep -rniE "crm\|hubspot\|salesforce\|pipedrive" --include=*.{py,ts,js,rb} .` | Sync direction and coupling |
| Tracking plan file | `find . -iname "*tracking*plan*"` | Governance exists |
| Consent gating | `grep -rniE "consent\|cookie_?banner\|gdpr" src` | Privacy handling |
| PII in events | `grep -rnE "track\(.*(email\|phone\|name)" src` | Leaking personal data |
| Data tests | `find . -name "*.yml" -path "*models*" \| xargs grep -l "tests:"` | Warehouse test coverage |

## Anti-patterns

- Email as the join key between billing, CRM, and product.
- Event names like `Clicked Upgrade Button`, `upgrade_click`, and `UpgradeClicked` coexisting.
- Subscription state updated only from webhook payloads in arrival order, causing canceled accounts to reappear active.
- Webhook handler doing heavy work synchronously and timing out, triggering retries that double apply.
- No signature verification, or verification against a re-serialized body.
- Revenue metrics computed from client-side events.
- CRM and product both editable for plan or seat count.
- Lifecycle stage computed differently in the CRM, the warehouse, and the product.
- Test and internal accounts counted in conversion and revenue.
- Personal data in event properties sent to every downstream tool.
- Backfills pushed to live marketing tools, emailing customers about events from last year.

## Audit checklist

| ID | Check | Evidence to look for | Severity |
|---|---|---|---|
| DI-01 | A system of record is documented for each core entity | Architecture doc or README listing entity ownership | Medium |
| DI-02 | Accounts store billing and CRM identifiers | Columns or mapping table in migrations | High |
| DI-03 | Analytics identify and group calls use internal immutable IDs | `identify(user.id)`, `group(account.id)`; no email as ID | High |
| DI-04 | Event names follow one convention (`object_action`, past tense) | Grep of event names shows consistent casing and tense | Medium |
| DI-05 | Every event carries `event_id`, `occurred_at`, `account_id`, `source` | Tracking wrapper or event schema | Medium |
| DI-06 | Revenue and lifecycle events are emitted server-side | Backend emits signup, activation, billing events | High |
| DI-07 | A tracking plan is versioned in the repository and checked in CI | Tracking plan file plus a validation step | Medium |
| DI-08 | Billing webhook signatures are verified on the raw body | Verification call before parsing | High |
| DI-09 | Webhook processing is idempotent via stored event IDs | Unique constraint table or equivalent | High |
| DI-10 | Webhook handlers are order-independent | State fetched from provider or version comparison | High |
| DI-11 | Webhook work is asynchronous with fast acknowledgment | Queue or background job after persisting payload | Medium |
| DI-12 | Raw webhook payloads are stored and a replay script exists | Payload column, replay command | Medium |
| DI-13 | Nightly reconciliation compares local subscription state to billing | Scheduled job and alert | High |
| DI-14 | CRM sync has clear field ownership and dedup on external ID | Sync code or reverse ETL config | Medium |
| DI-15 | Lifecycle stage is computed in one place with logged transitions | History table or `lifecycle_stage_changed` event | Medium |
| DI-16 | Warehouse is layered and metric definitions live in code | Staging, core, metrics models in version control | Medium |
| DI-17 | Data tests cover uniqueness, nulls, relationships, freshness | Test definitions and a scheduled run with alerts | Medium |
| DI-18 | Internal and test accounts are excluded from metrics | `is_internal` flag, environment property | Medium |
| DI-19 | Client analytics respect consent and exclude personal data | Consent gate around SDK init, no email in properties | High |
| DI-20 | User deletion propagates to all downstream systems | Deletion job touching analytics, CRM, support | Medium |
| DI-21 | Backfills run from source systems, are labeled, and do not trigger live actions | Backfill scripts, `source = 'backfill'` marker | Low |

## Related

- [01-customer-lifecycle.md](01-customer-lifecycle.md): stage definitions that the transition table implements
- [02-metrics.md](02-metrics.md): formulas that depend on this data
- [07-onboarding-and-activation.md](07-onboarding-and-activation.md): activation milestones to instrument
- [08-retention-and-expansion.md](08-retention-and-expansion.md): health score inputs
- [10-revenue-operations.md](10-revenue-operations.md): governance of definitions
- `templates/tracking-plan.yaml`, `templates/metrics-dictionary.yaml`, `templates/sql/`
