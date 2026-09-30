# Cheatsheet

> Scope: a one-page decision aid that consolidates the numbered references. Load when: you need a fast answer on what to do next, which formula to use, or whether a reported number can be trusted, before opening the full reference.

Formulas and ranges are copied from the references; if they disagree, the numbered reference wins.

## Decision rules

### Lifecycle and data

- When you define a lifecycle stage, tie it to an observable event with a timestamp, because judgment-based stages cannot be counted or audited. See [01-customer-lifecycle](01-customer-lifecycle.md).
- When a stage changes, append a transition row instead of overwriting a field, because conversion and velocity cannot be rebuilt from current state. See [01-customer-lifecycle](01-customer-lifecycle.md).
- When you report conversion, use entry cohorts with a fixed window and flag immature cohorts, because same-period ratios mix populations. See [01-customer-lifecycle](01-customer-lifecycle.md).
- When a customer cancels, record churn at the effective end of service and log `cancellation_requested` separately, because cancel-click churn pulls losses forward and breaks the MRR bridge. See [01-customer-lifecycle](01-customer-lifecycle.md).
- When an event affects money, plan, or lifecycle stage, emit it server side, because client events are lost to ad blockers and consent refusals. See [09-data-and-instrumentation](09-data-and-instrumentation.md).
- When you process billing webhooks, verify the signature on the raw body, deduplicate by event ID, and read current state from the provider, because webhooks are at-least-once and unordered. See [09-data-and-instrumentation](09-data-and-instrumentation.md).

### Metrics

- When you compute MRR, derive it from subscription state normalized to monthly and exclude one-off fees, tax, and uncommitted usage, because invoices lag and include non-recurring items. See [02-metrics](02-metrics.md).
- When you show NRR, show GRR next to it, because expansion can hide heavy churn. See [02-metrics](02-metrics.md).
- When you report CAC, make fully loaded CAC the headline and label paid CAC, because paid CAC excludes salaries and is far lower. See [02-metrics](02-metrics.md).
- When you estimate LTV, adjust for gross margin and cap the horizon (for example 36 to 60 months), because simple LTV assumes constant churn forever. See [02-metrics](02-metrics.md).
- When a definition changes, version it with an effective date and restate or annotate history, because silent changes create fake trends. See [10-revenue-operations](10-revenue-operations.md).

### Pricing and packaging

- When you pick a value metric, score candidates on value alignment, predictability, measurability, expansion, and fairness, because the metric decides whether revenue grows with customer success. See [03-pricing-and-packaging](03-pricing-and-packaging.md).
- When code checks access, call `can(account, feature)` instead of comparing plan names, because hard-coded plans turn every pricing change into a release. See [03-pricing-and-packaging](03-pricing-and-packaging.md).
- When you choose a trial length, derive it from time to first value, because a trial much longer than activation time only adds delay. See [03-pricing-and-packaging](03-pricing-and-packaging.md).
- When you grant a discount, attach a reason, an approver, an expiry, and a give-get, because ungoverned discounts carry into every renewal. See [06-sales-process](06-sales-process.md).

### Acquisition and sales

- When you define the ICP, derive it from retained and expanding accounts acquired 6 to 18 months ago, and refresh it quarterly. See [05-demand-and-acquisition](05-demand-and-acquisition.md).
- When you score leads, keep fit and intent on separate axes and decay intent, because a single sum hides why a lead is hot. See [05-demand-and-acquisition](05-demand-and-acquisition.md).
- When you choose budget by channel, measure through to pipeline, revenue, and retention, and test incrementality for large channels, because attribution shows correlation. See [05-demand-and-acquisition](05-demand-and-acquisition.md).
- When you advance an opportunity, require buyer evidence, not seller activity, because activity stages make forecasts meaningless. See [06-sales-process](06-sales-process.md).
- When you set a coverage target, derive it from your own win rate, because a copied 3x ignores your conversion. See [06-sales-process](06-sales-process.md).

### Onboarding, retention, expansion

- When you choose an activation metric, pick a behavior within a fixed window that predicts retention across cohorts, and re-validate yearly, because setup steps are not value. See [07-onboarding-and-activation](07-onboarding-and-activation.md).
- When a deal closes, create a handoff record with outcomes, deadlines, stakeholders, commitments, and risks, because onboarding otherwise restarts discovery. See [06-sales-process](06-sales-process.md).
- When you build a health score, validate it quarterly against actual churn, because an unvalidated score is an opinion. See [08-retention-and-expansion](08-retention-and-expansion.md).
- When an annual contract approaches its end date, start renewal work at T-120 to T-90 days. See [08-retention-and-expansion](08-retention-and-expansion.md).
- When payments fail, recover with smart retries, card updaters, and a dunning sequence before restricting access, and never delete data. See [08-retention-and-expansion](08-retention-and-expansion.md).

### Stage and improvement

- When retention is unproven, do not scale acquisition or hire sellers, because churned customers raise effective CAC and hide the problem. See [11-growth-stages](11-growth-stages.md).
- When you plan growth, use absolute net new ARR and its composition, because percentage growth falls as the base grows. See [11-growth-stages](11-growth-stages.md).
- When a downstream stage is below trend, fix it before buying more volume, because extra volume pours into the leak. See [12-continuous-improvement](12-continuous-improvement.md).
- When you run an experiment, write the hypothesis, primary metric, guardrails, and sample size before launch. See [12-continuous-improvement](12-continuous-improvement.md).

## Choosing a go-to-market motion

Illustrative ACV bands; calibrate to your segment and region. Source: [04-go-to-market-motions](04-go-to-market-motions.md).

| Annual contract value | Volume | Default motion | Pushes heavier |
|---|---|---|---|
| Under about 1,000 to 2,000 | Very high | Self-serve only | Buying committee |
| About 2,000 to 15,000 | High | Self-serve plus product-led sales or light inside sales | Security or legal review |
| About 15,000 to 75,000 | Medium | Inside sales | Implementation or migration |
| About 75,000 to 250,000 | Low to medium | Field sales with solution engineers | Replacing an entrenched system |
| Above about 250,000 | Low | Enterprise account teams | Procurement and custom terms |

Tiebreakers: if a single user can reach value alone within the trial window, push lighter; if not, use sales-assisted evaluation. Master one motion before adding another, and store `motion` on accounts and opportunities with history. See [04-go-to-market-motions](04-go-to-market-motions.md) and [11-growth-stages](11-growth-stages.md).

## Key formulas

```text
MRR(t)          = sum of (unit_price * quantity - recurring_discount) / billing_interval_months
ARR             = MRR * 12
closing_MRR     = opening_MRR + new + reactivation + expansion + contraction + churn
GRR(m)          = sum of min(MRR_i(m), MRR_i(m-12)) / sum of MRR_i(m-12)     (cohort at m-12)
NRR(m)          = sum of MRR_i(m) / sum of MRR_i(m-12)                       (same cohort)
logo_churn(m)   = accounts churned during m / paying accounts at start of m
ARPA            = MRR / paying accounts
gross_margin    = (revenue - cost_of_revenue) / revenue
fully_loaded_CAC= (media + S&M salaries, commissions, benefits, tools, agencies, overhead) / new customers
margin_LTV      = ARPA * gross_margin / monthly_gross_revenue_churn
bounded_LTV     = ARPA * gross_margin * min(1 / monthly_gross_revenue_churn, horizon_months)
CAC_payback     = CAC / (new_ARPA * gross_margin)
LTV_to_CAC      = margin_LTV (bounded) / fully_loaded_CAC
magic_number    = (ARR(q) - ARR(q-1)) / S&M_expense(q-1)
burn_multiple   = net_burn / net_new_ARR
rule_of_40      = revenue_growth_rate_percent + profit_margin_percent
win_rate        = closed_won / (closed_won + closed_lost)
pipeline_coverage = qualified open pipeline closing in period / remaining target
required_coverage ≈ 1 / win_rate_by_amount
conversion(A->B)  = entities entering A in P reaching B within W / entities entering A in P
activation_rate   = accounts_activated_within_D_days / accounts_in_cohort
forecast_accuracy = 1 - abs(actual - forecast) / forecast
CMGR            = (value_end / value_start) ^ (1 / n_months) - 1
annualized      = (1 + CMGR) ^ 12 - 1
customers_out   = volume_in * r1 * r2 * ... * rn
n_per_variant   ≈ 16 * p * (1 - p) / delta^2
priority_score  = (impact * confidence) / effort
```

Sources: [02-metrics](02-metrics.md), [06-sales-process](06-sales-process.md), [07-onboarding-and-activation](07-onboarding-and-activation.md), [10-revenue-operations](10-revenue-operations.md), [11-growth-stages](11-growth-stages.md), [12-continuous-improvement](12-continuous-improvement.md). Both references divide forecast error by the forecast; record the chosen denominator in the metric dictionary.

## Typical benchmark ranges

Typical ranges, calibrate to your segment. Use your own trend as the primary reference and never treat these as targets. Source: [02-metrics](02-metrics.md) unless noted.

| Metric | Commonly cited range | Caveat |
|---|---|---|
| Gross margin (subscription) | 70 to 85 percent | Infrastructure or services-heavy products run lower |
| GRR | 80 to 95 percent annually | SMB lower, enterprise higher ([08](08-retention-and-expansion.md) cites the 80s to low 90s) |
| NRR | 100 to 120 percent often described as strong for mid-market and enterprise | SMB and low-price self-serve often below 100 percent |
| LTV:CAC | 3:1 rule of thumb | Meaningless with uncapped LTV or CAC without salaries |
| CAC payback | Under 12 months SMB, 12 to 24 enterprise | Depends on gross margin and prepay |
| Magic Number | Above roughly 0.75 read as efficient | Seasonality and spend lag |
| Burn Multiple | Under 2 acceptable, under 1 very efficient | Meaningless near zero net new ARR |
| Rule of 40 | 40 or higher | Mostly growth and later stage |
| Pipeline coverage | 3x to 4x | Derive from your own win rate |
| DAU/MAU | 10 to 20 percent; above 50 percent for daily tools | Weekly products use WAU/MAU |
| Annual prepay incentive | About 15 to 20 percent ("2 months free") | [03](03-pricing-and-packaging.md) |
| Price change notice | Commonly 30 to 90 days | Check contract terms, [03](03-pricing-and-packaging.md) |

Activation and time to value have no useful published benchmarks; improve against your own baseline. See [07-onboarding-and-activation](07-onboarding-and-activation.md).

## Warning signs and manipulation tells

| Tell | What it usually hides | See |
|---|---|---|
| NRR shown without GRR | Churn masked by expansion | [02](02-metrics.md) |
| One churn number with no basis | Mixed logo, revenue, voluntary, involuntary churn | [08](08-retention-and-expansion.md) |
| ARR includes setup, services, or peak usage | Inflated ARR | [02](02-metrics.md) |
| Signed-not-live contracts in live ARR | Inflated ARR; report CARR separately | [02](02-metrics.md) |
| Accounts in dunning indefinitely, paused accounts with MRR | Delayed churn recognition | [02](02-metrics.md) |
| Churn plus new relabeled as migration | Hidden churn | [02](02-metrics.md) |
| LTV:CAC with paid CAC and uncapped LTV | Overstated unit economics | [02](02-metrics.md) |
| Win rate excluding "no decision" losses | Inflated win rate | [02](02-metrics.md) |
| Best cohort or segment chosen for NRR | Cherry-picked retention | [02](02-metrics.md) |
| Step change in a trend right after a definition change | Silent restatement | [10](10-revenue-operations.md) |
| Close dates default to quarter end, deals pushed repeatedly | Inflated commit and coverage | [06](06-sales-process.md) |
| "Price" as the dominant loss reason | Real causes (no urgency, wrong fit) unexamined | [06](06-sales-process.md) |
| Several stage rates drop at once across all segments | Tracking or definition break, not performance | [12](12-continuous-improvement.md) |
| Monthly growth multiplied by 12 | Understated compounding | [11](11-growth-stages.md) |
| Test stopped when it first looked significant | False win | [12](12-continuous-improvement.md) |
| Internal and test accounts in metrics | Inflated conversion and revenue | [09](09-data-and-instrumentation.md) |

## First 10 things to implement

1. **Append-only lifecycle transitions table** with account and user grains and one system of record per stage. See [01-customer-lifecycle](01-customer-lifecycle.md).
2. **Immutable IDs and identity crosswalk** linking product, billing, and CRM on `account_id`. See [09-data-and-instrumentation](09-data-and-instrumentation.md).
3. **Idempotent, signature-verified billing webhooks** with stored payloads and nightly reconciliation. See [09-data-and-instrumentation](09-data-and-instrumentation.md).
4. **Server-side revenue and lifecycle events** through one typed tracking wrapper and a versioned tracking plan. See [09-data-and-instrumentation](09-data-and-instrumentation.md).
5. **One MRR view and a monthly MRR bridge** that must reconcile, with month-end snapshots. See [02-metrics](02-metrics.md).
6. **Versioned metrics dictionary** with one owner per metric and change control. See [10-revenue-operations](10-revenue-operations.md).
7. **Plans, prices, and entitlements as data** with feature-key checks and integer minor units. See [03-pricing-and-packaging](03-pricing-and-packaging.md).
8. **Validated activation metric** computed server side with a definition version. See [07-onboarding-and-activation](07-onboarding-and-activation.md).
9. **Dunning plus churn by type** with reason codes on every churn and contraction. See [08-retention-and-expansion](08-retention-and-expansion.md).
10. **Cohort funnel view and a regular plan, do, check, act improvement cycle** that names the current constraint. See [12-continuous-improvement](12-continuous-improvement.md).

## Related

- [glossary.md](glossary.md): definitions of the terms used above.
- [11-growth-stages.md](11-growth-stages.md): which of these matter at your stage.
