# Customer Lifecycle

> Scope: the end-to-end customer lifecycle modeled as data, from anonymous visitor to churned and reactivated customer, across product-led and sales-led paths. Load when: designing lifecycle stages, CRM or product data models, funnel reporting, handoffs between teams, or auditing why funnel numbers disagree across systems.

## Why it matters

Every revenue metric is a count of entities moving between states. If the states are vague, the counts are wrong, and every downstream number (conversion, velocity, CAC, retention) inherits the error. Most SaaS teams have three lifecycles that disagree: one in the marketing tool, one in the CRM, one implied by the billing system. A single lifecycle model with explicit entry and exit criteria, one owner per stage, and an append-only transition history fixes this and makes funnel analysis reproducible.

## Core principles

1. **Define every stage by an observable event, not a judgment.** "Qualified" must map to a rule a query can evaluate, or to a recorded human decision with a timestamp and actor.
2. **Store transitions, not just current state.** Keep an append-only table of timestamped transitions. Never overwrite a stage field without writing the transition. Current stage is derived from the latest transition.
3. **Model two grains: account and user.** Revenue, contracts and churn live on the account. Signup, activation and engagement start on the user and roll up to the account by explicit rules.
4. **One stage, one owner, one system of record.** Each stage has an accountable team and a single system whose timestamp wins in a conflict.
5. **Allow skips and loops.** Self-serve customers skip opportunity. Churned customers reactivate. Your model must accept non-linear paths without faking intermediate stages.
6. **Measure conversion by cohort.** Stage conversion rate is "of entities that entered stage A in period P, the share that reached stage B within window W". Never divide this month's B count by this month's A count.
7. **Measure velocity as time in stage.** Report medians and percentiles, not averages; long tails dominate means.
8. **Keep definitions versioned.** When a criterion changes (for example a new activation rule), record the effective date and do not silently restate history.

## Model / framework

### Stage definitions

| Stage | Definition | Entry criteria (event) | Exit criteria | Owner / system of record |
|---|---|---|---|---|
| Visitor | Anonymous person interacting with owned properties | First tracked page view or app open with an anonymous ID | Identifies (form, signup) or goes inactive | Marketing / web analytics |
| Lead | Identified person with contact data and no qualification yet | `lead_created`: form submit, content download, event scan, sales-sourced contact | Qualified, disqualified, or aged out (for example 180 days with no activity) | Marketing / CRM or marketing automation |
| Signup | Person created a product account (self-serve path) | `user_signed_up` with verified email | Activates, qualifies as PQL, or goes dormant | Product growth / product database |
| Qualified lead | Lead or signup meets fit and intent rules; sales or self-serve should act | `lead_qualified` with `qualification_basis` = marketing, product, or sales | Opportunity created, converted to paid directly, or disqualified | Marketing (MQL), Product growth (PQL), SDR (SQL) / CRM |
| Opportunity | A specific deal with an amount, close date and next step | `opportunity_created` in CRM, accepted by the owning rep | Closed won (becomes customer) or closed lost | Sales / CRM |
| Customer | Account has a paid, active subscription | `subscription_activated`: first successful payment or signed contract start date, after any trial | Churned | Finance / billing system |
| Onboarded | Account completed the setup required to get value (integration, data import, users invited) | `onboarding_completed` per a defined checklist | Activated, or stalled beyond target time | Customer success or product / product database |
| Activated | Account reached the value milestone correlated with retention | `account_activated` when the activation rule first evaluates true | Retained or churned | Product / product database or warehouse |
| Retained | Account renewed or passed a defined tenure without churn | `renewal_completed` or tenure threshold (for example 3 paid months for monthly plans) | Expanded or churned | Customer success / billing system |
| Expanded | Account increased recurring revenue through seats, tier, usage or add-ons | `mrr_expanded` where MRR exceeds prior month end | Continues as retained, contracts, or churns | Account management / billing system |
| Churned | Account has no active paid subscription | `subscription_ended` at the effective end of service, not the cancel click | Reactivated | Finance / billing system |
| Reactivated | Previously churned account pays again | `subscription_activated` for an account with prior paid history | Returns to Customer path | Finance / billing system |

Terminal and side states: `disqualified` (lead not a fit), `closed_lost` (opportunity lost), `dormant` (signup inactive beyond a threshold). Store them as transitions too, so recycling can be measured.

### Product-led and sales-led paths

| Path | Typical sequence | Qualifying signal |
|---|---|---|
| Self-serve (product-led) | Visitor, Signup, Activated (user), Customer, Onboarded, Activated (account), Retained | Card entered or plan purchased in product |
| Product-led with sales assist | Visitor, Signup, Qualified lead (PQL), Opportunity, Customer | Product usage plus fit rule (for example 3+ active users at a company over 200 employees) |
| Sales-led | Visitor, Lead, Qualified lead (MQL then SQL), Opportunity, Customer, Onboarded, Activated | Fit plus intent (demo request, pricing page, engagement score), then rep acceptance |
| Outbound | Lead (sales-sourced), Qualified lead (SQL), Opportunity, Customer | Rep qualification call with recorded criteria |

Rules for mixed motions:

- A user can be activated before the account is a customer. Keep user activation and account activation as separate events.
- A PQL is a qualified lead with `qualification_basis = 'product'`. Do not create a parallel funnel; the same stage with an attribute keeps conversion math comparable.
- When a self-serve account is later worked by sales for an upgrade, create an expansion opportunity, not a new-business opportunity, so new logo counts stay clean.

### Account versus user level

| Concept | Grain | Roll-up rule |
|---|---|---|
| Signup, user activation, engagement | User | Account activated when N users meet the rule or when the account-level milestone fires |
| Lead, qualified lead | Person (user or CRM contact) | Account becomes qualified when its first person qualifies; keep the person-level record for attribution |
| Opportunity, customer, churn, expansion | Account | Not rolled up; native to account |

Match people to accounts by a deterministic key (CRM account ID, verified email domain for business plans, or explicit workspace membership). Record the matching method. Free email domains never auto-match.

### Stage history (append-only)

Required columns for the transitions table (see [../templates/sql/schema.sql](../templates/sql/schema.sql)):

| Column | Purpose |
|---|---|
| `entity_type`, `entity_id` | Account or user |
| `from_stage`, `to_stage` | Explicit transition, including loops (churned to reactivated) |
| `transitioned_at` | Business time the transition happened (from the source event) |
| `recorded_at` | System time the row was written (for late-arriving data) |
| `source_event_id`, `source_system` | Traceability to the event or record that caused it |
| `qualification_basis`, `actor` | Why and who, for judgment-based stages |

Rules: never update or delete rows; correct mistakes with a compensating transition and a reason. Derive current stage with "latest transition per entity by `transitioned_at`". Backfilled transitions keep their true `transitioned_at` and a later `recorded_at`, so you can reproduce what a report showed on any date.

### Decision tree: which event closes the stage?

- Is there money involved? Use the billing system timestamp (payment succeeded, contract start, service end).
- Is it product behavior? Use the product event timestamp from server-side tracking.
- Is it a human judgment (qualification, opportunity acceptance)? Use the CRM field change timestamp plus the actor.
- Do two systems disagree? The stage owner's system of record wins; log the discrepancy for data quality review.

## Metrics

**Stage conversion rate (cohort-based)**

```text
conversion(A -> B, cohort P, window W) =
  count(entities entering A during P that reach B or any later stage within W days of entering A)
  / count(entities entering A during P)
```

- Unit: percent. Grain: per stage pair, per entry cohort (week or month), optionally per segment and path.
- Pitfalls: using same-period counts (mixes cohorts); counting only direct next-stage moves (undercounts skips); reporting immature cohorts whose window has not elapsed. Mark cohorts younger than W as incomplete.

**Time in stage (velocity)**

```text
time_in_stage = next_transition_at - transitioned_at   (for each entry into the stage)
report: median and 75th/90th percentile, per stage, per entry cohort
```

- Unit: days. Grain: per stage entry.
- Pitfalls: excluding entities still in stage (survivor bias toward fast movers; report the share still open); averaging.

**End-to-end cycle time**: `customer_at - first_touch_at` (or `signup_at` for self-serve). Report by path, since self-serve and sales-led differ by an order of magnitude.

**Stage throughput**: count of entries per stage per period. Useful for capacity planning, never a substitute for conversion.

**Recycle rate**: share of disqualified or closed-lost entities that re-enter a qualified stage within 12 months. High recycle suggests disqualification is premature or timing-driven.

Illustrative example (hypothetical round numbers): 1,000 signups in March; within 30 days 300 activated and 60 became paying customers. Signup to activation is 30 percent, signup to paid is 6 percent for the March cohort, regardless of how many customers were created in March from February signups.

## Implementation guide

1. **Schema.** Create `lifecycle_stage_transitions` (append-only) and an `events` table. Block updates and deletes at the database level (trigger or permissions). Reference: [../templates/sql/schema.sql](../templates/sql/schema.sql).
2. **Emit transition events at the source.** Server-side code emits `user_signed_up`, `account_activated`, `subscription_activated`, `subscription_ended`. Do not rely on client-side analytics for money or lifecycle state.
3. **Transition writer.** One service or job consumes source events and CRM changes and writes transitions. It is idempotent (dedupe on `source_event_id`), validates allowed transitions, and records `recorded_at`.
4. **Allowed transitions map.** Maintain a small table or config of legal `from_stage` to `to_stage` pairs. Reject or flag illegal ones (for example lead straight to churned).
5. **Activation rule as code.** Implement the activation definition as a versioned query or function; fire `account_activated` once, the first time it is true. See [07-onboarding-and-activation.md](07-onboarding-and-activation.md).
6. **CRM sync.** Push derived stages into the CRM as read-only fields for reps; pull CRM-owned stages (SQL, opportunity, closed lost) back as transitions. Never let two systems both write the same stage.
7. **Churn timing.** Emit `subscription_ended` at the effective end of paid service. Record the cancel request separately as `cancellation_requested` for save flows and forecasting.
8. **Reporting.** Build conversion and velocity from the transitions table only: [../templates/sql/funnel_conversion.sql](../templates/sql/funnel_conversion.sql). Publish definitions in [../templates/metrics-dictionary.yaml](../templates/metrics-dictionary.yaml).
9. **Data quality jobs.** Daily checks: customers without a `customer` transition, churned accounts with active subscriptions, transitions with future timestamps, entities with no stage.

## Anti-patterns

- A single mutable `lifecycle_stage` field in the CRM with no history. Conversion and velocity become impossible to reconstruct.
- Marking churn on the cancel click. It pulls churn forward, inflates churn in promotional periods, and breaks MRR reconciliation with billing.
- Separate, incompatible funnels for product-led and sales-led motions that cannot be added together.
- "MQL" defined as a lead score threshold nobody has validated against downstream conversion.
- Counting trials as customers. A trial is a product state; customer requires payment or a signed contract in force.
- Rolling user activation up to the account by "any user did anything".
- Restating historical funnels after changing a definition, without versioning, so trends show fake step changes.
- Reporting conversion for cohorts that have not had time to mature.

## Audit checklist

| ID | Check | Evidence to look for | Severity |
|---|---|---|---|
| LC-01 | Every lifecycle stage has a written definition with entry and exit criteria | Lifecycle doc or dictionary; stage values in code match it | High |
| LC-02 | Stage transitions are stored append-only with timestamps | Transitions table or CRM field history; no destructive updates | High |
| LC-03 | Account and user grains are modeled separately with an explicit roll-up rule | Schema has both entities; activation roll-up documented | High |
| LC-04 | Each stage has one owner and one system of record | Ownership table; no dual writers for the same field | Medium |
| LC-05 | Customer and churn stages derive from billing facts, not CRM edits or cancel clicks | Transition source is payment or subscription end event | High |
| LC-06 | Product-led and sales-led paths share one stage vocabulary | PQL is an attribute of qualified lead, not a separate funnel | Medium |
| LC-07 | Conversion rates are computed by entry cohort with a defined window | Query or dashboard logic; immature cohorts flagged | High |
| LC-08 | Velocity is reported as median and percentiles of time in stage | Funnel report shows medians, open counts | Medium |
| LC-09 | Reactivation is distinguished from new customer acquisition | Separate transition and MRR movement type | Medium |
| LC-10 | Illegal transitions are rejected or flagged | Allowed-transition map; data quality job output | Low |
| LC-11 | Definition changes are versioned with effective dates | Changelog in dictionary; no silent restatement | Medium |
| LC-12 | People are matched to accounts by a documented deterministic rule | Matching logic; free email domains excluded | Medium |

## Related

- [02-metrics.md](02-metrics.md): formulas that consume lifecycle transitions.
- [06-sales-process.md](06-sales-process.md): opportunity stages inside the opportunity lifecycle stage.
- [07-onboarding-and-activation.md](07-onboarding-and-activation.md): defining onboarded and activated.
- [08-retention-and-expansion.md](08-retention-and-expansion.md): retained, expanded, churned, reactivated.
- [09-data-and-instrumentation.md](09-data-and-instrumentation.md): event design and tracking plan.
- [10-revenue-operations.md](10-revenue-operations.md): CRM ownership and handoff rules.
