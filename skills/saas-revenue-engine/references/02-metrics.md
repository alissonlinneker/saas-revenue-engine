# SaaS Metrics

> Scope: rigorous definitions, formulas, grains and pitfalls for the core recurring revenue, efficiency, funnel and engagement metrics, plus how to prevent their manipulation. Load when: building a metrics layer or dashboard, writing SQL for revenue reporting, preparing board or investor numbers, or auditing whether reported metrics can be trusted.

## Why it matters

SaaS metrics are compounding and interdependent: a wrong MRR definition corrupts churn, NRR, LTV, CAC payback and every forecast built on them. Most disagreements between finance, sales and product are definitional, not factual. A single dictionary with formulas, grains and owners (see [../templates/metrics-dictionary.yaml](../templates/metrics-dictionary.yaml)) and reference SQL (see [../templates/sql/](../templates/sql/)) turns arguments into queries.

## Core principles

1. **Derive recurring revenue from subscription state, not from invoices or bookings.** Invoices lag, prepay, and include one-off items.
2. **Normalize to a monthly recurring amount.** Divide annual and multi-month contracts by their term in months; apply recurring discounts; exclude tax, one-off fees and usage overage unless usage is committed.
3. **Every metric declares a grain and a denominator.** "Churn is 3 percent" is meaningless without "monthly, revenue, of MRR at start of month".
4. **Prefer cohort methods for retention and conversion.** Fix the population at the start, then follow it.
5. **Reconcile.** The MRR bridge must tie out: opening MRR plus movements equals closing MRR, every month.
6. **Separate operational inputs from executive outputs.** Teams manage inputs; outputs are the consequence.
7. **Version definitions.** A change in definition is a restatement; publish it with an effective date.
8. **Treat benchmarks as calibration, not targets.** Ranges vary by segment, price point, stage and motion.

## Model / framework

### Metric hierarchy

| Level | Metrics | Primary owner |
|---|---|---|
| Executive outputs | ARR growth, NRR, Rule of 40, Burn Multiple, free cash flow | CEO, CFO |
| Unit economics | LTV, CAC, CAC payback, LTV:CAC, gross margin, Magic Number | CFO, RevOps |
| Revenue movements | New, expansion, contraction, churn, reactivation MRR; GRR; logo churn | RevOps, CS |
| Funnel and sales | Stage conversion, win rate, sales cycle, pipeline coverage, ACV | Marketing, Sales |
| Product inputs | Activation rate, time to value, DAU/MAU, feature adoption | Product |

Read top-down to diagnose (NRR fell: is it churn or contraction, which segment, which activation cohort?) and bottom-up to plan (activation lift, then retention, then NRR).

### Bookings vs billings vs revenue

| Term | What it measures | Timing | Source |
|---|---|---|---|
| Bookings | Value of contracts signed in a period (often first-year or total contract value) | Signature date | CRM, contracts |
| Billings | Amount invoiced in a period | Invoice date | Billing system |
| Revenue | Amount earned as service is delivered, under accounting rules (ratable recognition) | Service period | General ledger |
| MRR / ARR | Run-rate of recurring subscription value at a point in time | Snapshot date | Subscription data |

A 12-month prepaid contract of 12,000 is 12,000 bookings and billings in month one, 1,000 revenue per month, and 1,000 MRR from start date. Always label which one a chart shows.

## Metrics

### Recurring revenue

**MRR (monthly recurring revenue)**

```text
MRR(t) = sum over active recurring subscription items at t of
         (unit_price * quantity - recurring_discount) / billing_interval_months
```

Unit: currency. Grain: per account per month-end snapshot, summed. Exclude: trials, one-time fees, services, tax, uncommitted usage, credits applied once. Pitfall: recognizing MRR at invoice date instead of service start; including accounts in dunning indefinitely (set a policy, for example removed after the grace period ends).

**MRR movements (bridge)**, per account, comparing month-end MRR of month m-1 and m:

```text
new          = MRR(m) where MRR(m-1) = 0 and account never had MRR before
reactivation = MRR(m) where MRR(m-1) = 0 and account had MRR before
expansion    = MRR(m) - MRR(m-1) where MRR(m) > MRR(m-1) > 0
contraction  = MRR(m) - MRR(m-1) where 0 < MRR(m) < MRR(m-1)   (negative)
churn        = -MRR(m-1) where MRR(m-1) > 0 and MRR(m) = 0     (negative)
closing_MRR  = opening_MRR + new + reactivation + expansion + contraction + churn
net_new_MRR  = closing_MRR - opening_MRR
```

Grain: per account per month, then summed. Reference: [../templates/sql/mrr_movements.sql](../templates/sql/mrr_movements.sql). Pitfalls: netting movements across accounts (hides churn behind expansion); classifying price increases as new; treating plan migrations with a gap day as churn plus new. Consider a reactivation window (for example returns within 30 days count as expansion from zero, not churn) and document it.

**ARR**

```text
ARR = MRR * 12
```

Committed ARR (CARR) adds signed contracts not yet live and subtracts known churn (notified non-renewals):

```text
CARR = live ARR + signed-not-started ARR - notified churn ARR
```

Contracted ARR usually means ARR under signed contracts regardless of go-live; state which you report. Never include pipeline, verbal commitments or one-off fees in either.

### Retention

**Logo churn rate (monthly)**

```text
logo_churn(m) = accounts churned during m / paying accounts at start of m
```

Grain: per month, per segment. Pitfall: denominator including accounts acquired during the month.

**Gross revenue retention (GRR), cohort method, trailing 12 months**

```text
cohort   = accounts with MRR > 0 at month m-12
GRR(m)   = sum over cohort of min(MRR_i(m), MRR_i(m-12)) / sum over cohort of MRR_i(m-12)
```

GRR includes churn and contraction, excludes expansion, cannot exceed 100 percent.

**Net revenue retention (NRR), cohort method, trailing 12 months**

```text
NRR(m) = sum over cohort of MRR_i(m) / sum over cohort of MRR_i(m-12)
```

Includes expansion, contraction and churn of the same cohort; excludes new logos acquired after m-12. Reference: [../templates/sql/grr_nrr.sql](../templates/sql/grr_nrr.sql).

**Point-in-time (monthly annualized) method**: `NRR_monthly = (opening + expansion + contraction + churn) / opening` computed monthly, sometimes compounded to annual. It reacts faster but compounding assumes stable rates and mixes cohorts. Report the cohort method as the headline; use the monthly one as an early indicator. Always say which method.

**Cohort retention curves**: logo and revenue retention by start cohort and months since start. Reference: [../templates/sql/retention_cohorts.sql](../templates/sql/retention_cohorts.sql).

### Revenue per customer

```text
ARPA = MRR / paying accounts           (per account)
ARPU = MRR / paying users or seats     (per user; state which)
ACV  = annualized recurring contract value per new contract (exclude one-off fees)
```

Pitfall: averaging across segments with very different price points; always slice by segment or plan. Use median ACV alongside mean.

### Unit economics

**Gross margin**

```text
gross_margin = (revenue - cost_of_revenue) / revenue
cost_of_revenue = hosting, third-party software in the product, support, onboarding delivery, payment processing
```

Grain: per quarter (company), optionally per product line. Pitfall: excluding support and onboarding costs to inflate margin.

**CAC (customer acquisition cost)**

```text
blended_CAC      = total sales and marketing expense in period / new customers in period
paid_CAC         = paid acquisition spend / new customers attributed to paid channels
fully_loaded_CAC = (media + S&M salaries, commissions, benefits, tools, agencies, allocated overhead) / new customers
```

Grain: per month or quarter, per segment or channel. Lag spend by the typical sales cycle for sales-led motions (spend in quarter q-1 against customers in q) or use trailing sums. Pitfall: reporting paid CAC as "CAC" (usually far lower than fully loaded); excluding sales salaries; counting reactivations or free-to-free conversions as new customers.

**LTV (customer lifetime value)**

```text
monthly_gross_revenue_churn = (churned_MRR + contraction_MRR) / opening_MRR   (positive values)
simple_LTV      = ARPA / monthly_gross_revenue_churn
margin_LTV      = ARPA * gross_margin / monthly_gross_revenue_churn
bounded_LTV     = ARPA * gross_margin * min(1 / monthly_gross_revenue_churn, horizon_months)
```

Grain: per segment, per cohort. Why simple formulas overstate: they ignore gross margin; they assume churn stays constant forever (low early churn estimates produce implausible lifetimes); they use blended ARPA that includes expansion from mature cohorts; they ignore discounting. Use margin-adjusted, horizon-capped LTV (for example 36 to 60 months) and validate against observed cohort revenue curves. Use gross revenue churn (churn plus contraction, never net of expansion): a net-churn variant becomes undefined or infinite when NRR exceeds 100 percent. When NRR is above 100 percent, also validate against observed cohort cumulative gross profit, because gross-churn LTV then understates value.

**CAC payback (months)**

```text
CAC_payback = CAC / (new_ARPA * gross_margin)
```

Grain: per cohort or period, per segment. Pitfall: omitting gross margin (payback looks shorter); using blended ARPA instead of ARPA of new customers.

**LTV:CAC**

```text
LTV_to_CAC = margin_LTV (bounded) / fully_loaded_CAC
```

Reference: [../templates/sql/ltv_cac.sql](../templates/sql/ltv_cac.sql).

### Efficiency (company level)

```text
magic_number  = (ARR(q) - ARR(q-1)) / S&M_expense(q-1)
                 (variant: net new revenue(q) * 4 / S&M(q-1); state which)
burn_multiple = net_burn(period) / net_new_ARR(period)
rule_of_40    = revenue_growth_rate_percent + profit_margin_percent
                 (profit measure: free cash flow margin or EBITDA margin; state which)
```

Grain: quarterly or trailing 12 months. Burn multiple is undefined when net new ARR is zero or negative; report as "not meaningful" rather than a number.

### Sales and funnel

```text
pipeline_coverage = open qualified pipeline amount due to close in period / remaining quota or target for period
win_rate          = closed_won / (closed_won + closed_lost), opportunities created in cohort P
sales_cycle       = median(closed_won_at - opportunity_created_at), closed won in cohort
```

Win rate denominator: decided opportunities only (won plus lost), counted by creation cohort or by close period; state which. Excluding "no decision" or disqualified opportunities from lost inflates win rate; include them as lost or report them separately. Pipeline coverage must use stage-qualified pipeline, not every open record. Stage conversion and velocity: see [01-customer-lifecycle.md](01-customer-lifecycle.md) and [../templates/sql/funnel_conversion.sql](../templates/sql/funnel_conversion.sql).

### Product

```text
activation_rate = accounts (or users) in signup cohort that meet activation rule within N days / cohort size
DAU_MAU         = average daily active users over month / monthly active users in month
```

Define "active" as a value-bearing action, not a login or page load. Grain: per signup cohort (activation), per month (stickiness).

### Typical public ranges (calibrate to your segment)

| Metric | Commonly cited range | Calibration caveat |
|---|---|---|
| Gross margin (subscription) | 70 to 85 percent | Infrastructure-heavy and services-heavy products run lower |
| GRR | 80 to 95 percent annually | SMB tends lower, enterprise higher |
| NRR | 100 to 120 percent is often described as strong for mid-market and enterprise | SMB and low-price self-serve often below 100 percent |
| LTV:CAC | 3:1 is a widely used rule of thumb | Meaningless if LTV is uncapped or CAC excludes salaries |
| CAC payback | Under 12 months often cited for SMB, 12 to 24 for enterprise | Depends on gross margin and contract prepay |
| Magic Number | Above roughly 0.75 often read as efficient | Sensitive to seasonality and spend lag |
| Burn Multiple | Under 2 often read as acceptable, under 1 as very efficient | Stage dependent; meaningless near zero net new ARR |
| Rule of 40 | 40 or higher | Mostly applied to growth and later-stage companies |
| Pipeline coverage | 3x to 4x of target | Should be derived from your own win rate |
| DAU/MAU | 10 to 20 percent common; above 50 percent for daily workflow tools | Weekly-use products should use WAU/MAU |

Do not cite these as targets without your own history and segment context.

### Metric manipulation and how to prevent it

| Manipulation | Effect | Prevention |
|---|---|---|
| Counting one-off fees, services or setup in ARR | Inflates ARR and new MRR | Only `is_recurring` items feed MRR; audit item classification |
| Annualizing a peak usage month as ARR | Inflates ARR | Only committed minimums count; report usage revenue separately |
| Excluding downgrades from GRR | Inflates GRR | GRR formula uses `min(end, start)` per account; publish the SQL |
| Cherry-picked cohorts for NRR (best year, best segment) | Inflates NRR | Report all cohorts, trailing 12 months, company-wide first |
| Counting signed-not-live contracts as live ARR | Inflates ARR | Report CARR and live ARR separately |
| Delaying churn recognition (dunning forever, pausing) | Hides churn | Written grace-period policy; paused accounts at zero MRR |
| Reclassifying churn plus new as migration | Hides churn | Movement classification by account, from snapshots |
| Excluding salaries from CAC | Understates CAC | Fully loaded CAC as headline; paid CAC labeled as such |
| Uncapped LTV from low early churn | Overstates LTV | Margin-adjusted, horizon-capped LTV, validated on cohorts |
| Changing win rate denominator | Inflates win rate | Fixed denominator in dictionary; versioned definitions |
| Restating history silently | Fake trends | Definition changelog, snapshot tables, reproducible queries |

## Implementation guide

1. **Schema.** Store subscriptions and subscription items with validity intervals (`valid_from`, `valid_to`) so MRR can be recomputed for any date: [../templates/sql/schema.sql](../templates/sql/schema.sql).
2. **MRR view.** Compute month-end MRR per account in one shared view; every other metric reads from it. Never compute MRR separately in dashboards.
3. **Monthly bridge job.** Materialize the MRR movement table after month close; assert `opening + movements = closing` and alert on mismatch.
4. **Snapshots.** Freeze month-end snapshots so reported numbers are reproducible after late data corrections; publish corrections as restatements.
5. **Spend data.** Load sales and marketing spend by month, channel and cost category from the ledger for CAC.
6. **Dictionary.** Maintain [../templates/metrics-dictionary.yaml](../templates/metrics-dictionary.yaml) in version control; dashboards reference metric IDs.
7. **Segmentation.** Every metric slices by segment, plan, acquisition channel and start cohort.
8. **Reconciliation.** Monthly: MRR x 12 vs finance ARR; revenue vs recognized revenue; new customers vs CRM closed won.

## Anti-patterns

- MRR computed from cash receipts.
- One "churn rate" with no stated basis (logo or revenue, gross or net, monthly or annual).
- NRR presented without GRR.
- Blended metrics across self-serve and enterprise segments.
- LTV:CAC reported with paid-media CAC and uncapped LTV.
- Dashboards each with their own SQL for MRR.
- Benchmarks used as goals without segment calibration.

## Audit checklist

| ID | Check | Evidence to look for | Severity |
|---|---|---|---|
| MT-01 | MRR is derived from subscription state, normalized to monthly, excluding one-off fees and tax | MRR query or view; item classification | High |
| MT-02 | MRR bridge reconciles opening plus movements to closing every month | Bridge table and reconciliation test | High |
| MT-03 | Movements are classified per account (new, expansion, contraction, churn, reactivation) | Movement SQL; no netting across accounts | High |
| MT-04 | GRR and NRR use the cohort method with a documented window | GRR/NRR query; both reported together | High |
| MT-05 | Churn is recognized at end of service under a written dunning and pause policy | Policy doc; churn timestamps | High |
| MT-06 | CAC is fully loaded and labeled; paid CAC reported separately | CAC model including salaries and tools | High |
| MT-07 | LTV is margin-adjusted and horizon-capped, validated against cohorts | LTV formula; cohort cumulative gross profit | Medium |
| MT-08 | Bookings, billings, revenue and ARR are distinguished in reporting | Dashboard labels; finance reconciliation | Medium |
| MT-09 | Win rate denominator and cohort basis are defined | Dictionary entry; CRM report logic | Medium |
| MT-10 | Metrics are segmented by plan, segment, channel and cohort | Dashboard filters; SQL group-bys | Medium |
| MT-11 | A versioned metrics dictionary exists and dashboards reference it | Dictionary in repo; change history | Medium |
| MT-12 | Month-end snapshots make reported numbers reproducible | Snapshot tables; restatement log | Medium |
| MT-13 | Committed ARR and live ARR are reported separately | ARR reports; contract start dates | Low |
| MT-14 | Benchmarks are shown with segment context, not as universal targets | Board deck and dashboard annotations | Low |

## Related

- [01-customer-lifecycle.md](01-customer-lifecycle.md): stage transitions behind funnel metrics.
- [03-pricing-and-packaging.md](03-pricing-and-packaging.md): how pricing choices change ARPA, expansion and MRR classification.
- [08-retention-and-expansion.md](08-retention-and-expansion.md): acting on GRR and NRR.
- [09-data-and-instrumentation.md](09-data-and-instrumentation.md): events and data quality.
- [10-revenue-operations.md](10-revenue-operations.md): reporting cadence and ownership.
- [11-growth-stages.md](11-growth-stages.md): which metrics matter at which stage.
