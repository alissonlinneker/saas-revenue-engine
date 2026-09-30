# Growth Stages

> Scope: what to build, measure, and avoid at each stage of a SaaS business, from pre product-market fit to maturity, plus the math of growth rates. Load when: deciding what to prioritize next, judging whether the business is ready to scale a motion, or diagnosing why growth slowed.

## Why it matters

Most SaaS failures are sequencing failures, not effort failures. Teams scale acquisition before retention is proven, hire salespeople before a repeatable process exists, or add a second motion before the first one works. Each stage has a small set of questions that must be answered before the next stage's investments pay off. Knowing the stage tells you which metrics to watch, which capabilities are missing, and which investments are premature.

Stages are defined by evidence, not by revenue alone. A company with meaningful ARR and poor retention is still searching for fit in the segment it serves. Use the revenue ranges below as rough orientation and the readiness checklists as the actual gate.

## Core principles

1. Classify the stage by evidence (retention, repeatability, efficiency), then use revenue as a sanity check, because revenue can be bought while fit cannot.
2. Solve one constraint per stage. Name the single question the stage must answer and fund work that answers it before anything else.
3. Prove retention before scaling acquisition, because every acquired customer who churns raises effective acquisition cost and hides the real problem.
4. Write the process down before hiring into it. A new hire should inherit a playbook, a defined funnel, and measurable targets, not a founder's memory.
5. Run one primary go-to-market motion until it is repeatable. Add a second motion only when the first meets its efficiency targets without founder involvement.
6. Expect percentage growth to slow as the base grows. Plan with absolute net new ARR and efficiency, not with last year's growth percentage.
7. Shift investment toward retention and expansion as the base grows, because the installed base becomes the largest source of new revenue.
8. Build data and instrumentation one stage ahead of need, since you cannot manage a funnel you did not record from the start.

## Model / framework

### Stage overview

| Stage | Rough ARR range | The question to answer | Primary constraint |
|---|---|---|---|
| 1. Pre product-market fit | Pre-revenue to first paying customers | Does a specific customer segment get enough value to pay and stay? | Value and retention |
| 2. Early traction | First revenue to low single-digit millions | Can we win and keep customers repeatably, without the founder in every deal? | Repeatability |
| 3. Scaling | Low single-digit millions to tens of millions | Can we add capacity (people, channels) and keep unit economics intact? | Capacity and process |
| 4. Efficient growth | Tens of millions and up | Can we grow while improving margin and capital efficiency? | Efficiency |
| 5. Mature | Large base, slower top-line growth | Can we defend the base, expand it, and find new growth vectors? | Base defense and new vectors |

These ranges are typical, not rules. A product-led company with a low price point may stay in stage 2 at a higher ARR; an enterprise product may reach stage 3 behaviors with few customers.

### Stage 1: Pre product-market fit

**Goals:** find a narrow segment with an urgent problem, deliver value quickly, and observe customers staying and using the product without being pushed.

**Metrics that matter:**

| Metric | Why |
|---|---|
| Activation rate for the target segment | Proves the product delivers first value |
| Weekly or monthly active usage retention by cohort | Flattening retention curve is the clearest fit signal |
| Early logo retention (first 3 to 6 months) | Paying customers who stay confirm willingness to pay |
| Qualitative pull (referrals, unprompted requests, "very disappointed" survey share) | Leading signal before revenue data exists |

**Capabilities that must exist:**

| Area | Minimum |
|---|---|
| Pricing | A price that is charged, even if simple. Free pilots delay the willingness-to-pay test |
| Data | Event tracking for signup, activation, and core usage; customer list with segment attributes |
| Process | Founder-led discovery and sales; a written ideal customer profile hypothesis |
| Team | Founders plus builders; no dedicated sales or marketing hires yet |
| Tooling | Product analytics, a simple CRM or spreadsheet, billing that can charge a card or invoice |

**Typical failure modes:** building for too many segments at once; mistaking friendly pilots for demand; hiring salespeople to "find" fit; optimizing top-of-funnel before activation works.

**Readiness checklist to move to stage 2:**

- [ ] A named segment where cohort usage retention flattens instead of trending to zero.
- [ ] Customers pay a real price and most renew or continue past the first term.
- [ ] You can describe the ideal customer profile and the problem in one sentence each.
- [ ] Time to first value is known and measured.
- [ ] At least some new customers arrive through referral or inbound, not only founder network.

### Stage 2: Early traction

**Goals:** make winning and keeping customers repeatable, get the founder out of the critical path of every deal, and establish baseline unit economics.

**Metrics that matter:**

| Metric | Why |
|---|---|
| Net new ARR per month | Absolute progress, less distorted than percentage growth |
| Stage conversion rates across the funnel | Shows where repeatability breaks |
| Win rate and sales cycle length | Tests whether non-founders can close |
| Gross revenue retention and logo churn | Confirms fit holds as the customer mix widens |
| CAC payback (rough) | First read on whether acquisition can be funded |

**Capabilities that must exist:**

| Area | Minimum |
|---|---|
| Pricing | Published or standardized tiers; discount rules; annual option |
| Data | Defined funnel stages with entry and exit criteria; CRM as the system of record; subscription data that supports ARR and churn calculations |
| Process | Written sales playbook (qualification, stages, demo, proposal); onboarding checklist; first customer success routine |
| Team | First one or two sellers or a growth owner; someone accountable for onboarding and retention |
| Tooling | CRM with enforced stage definitions, billing system with subscription events, product analytics tied to accounts |

**Typical failure modes:**

| Failure mode | Symptom | Correction |
|---|---|---|
| Founder dependency | Win rate collapses when the founder is absent | Record and codify founder calls; shadow, then reverse shadow |
| Hiring before process | New sellers miss quota with no shared playbook | Document the process first; hire one or two to validate it |
| Too many motions | Self-serve, sales-led, and partner channels all half-built | Pick the motion that matches price point and buyer; defer others |
| Customizing for every deal | Roadmap driven by the last prospect | Tie product commitments to the ideal customer profile |

**Readiness checklist to move to stage 3:**

- [ ] At least two non-founder sellers (or a self-serve funnel) hit targets for two or more consecutive quarters.
- [ ] Funnel stages and conversion rates are tracked and stable enough to forecast.
- [ ] Gross revenue retention is in an acceptable range for the segment and not declining.
- [ ] CAC payback is known per channel and within a range you can fund.
- [ ] Onboarding is a documented process with a measured time to value.
- [ ] Pricing and discounting follow written rules.

### Stage 3: Scaling

**Goals:** add capacity (headcount, channels, segments) while keeping conversion, retention, and payback intact.

**Metrics that matter:**

| Metric | Why |
|---|---|
| Net new ARR by source (new, expansion, churn, contraction) | Shows which engine drives growth |
| Quota or target attainment distribution | Reveals whether capacity additions are productive |
| Ramp time for new hires | Determines how fast capacity converts to revenue |
| Net revenue retention | Expansion begins to matter materially |
| Magic Number or CAC payback | Efficiency of sales and marketing spend |

**Capabilities that must exist:**

| Area | Minimum |
|---|---|
| Pricing | Packaging by segment; expansion paths (seats, usage, add-ons); deal desk rules |
| Data | Metrics dictionary with owned definitions; ARR movement reporting; cohort retention reporting; forecast process |
| Process | Hiring and onboarding plan for revenue roles; territory or segment design; handoffs between marketing, sales, and success with service levels |
| Team | Front-line managers; revenue operations function; dedicated customer success for higher-value accounts |
| Tooling | Integrated CRM, billing, product analytics, and warehouse; routing and assignment rules; enablement content library |

**Typical failure modes:** premature scaling (hiring ahead of pipeline so ramped reps starve); managers promoted without coaching skills; retention quietly degrading as newer customers fit the profile less well; metric definitions drifting between teams.

**Readiness checklist to move to stage 4:**

- [ ] New hires ramp to productivity on a predictable timeline.
- [ ] Forecast accuracy is within a tolerance leadership trusts.
- [ ] Net revenue retention is measured monthly and stable or improving.
- [ ] Every core metric has one definition and one owner.
- [ ] Efficiency metrics are reviewed by segment and channel, not only in aggregate.

### Stage 4: Efficient growth

**Goals:** grow while improving margin and capital efficiency; reallocate spend toward the most efficient segments and channels.

**Metrics that matter:** Burn Multiple (net burn divided by net new ARR), Rule of 40 (growth rate plus profit margin), net revenue retention, gross margin, CAC payback by segment, revenue per employee.

**Capabilities that must exist:** segment-level unit economics; systematic pricing reviews; expansion and renewal playbooks; experimentation practice; capacity planning tied to pipeline coverage; automated reporting from a warehouse.

**Typical failure modes:** cutting acquisition spend without fixing conversion (growth stalls, efficiency does not improve); treating all segments as one; ignoring gross margin drivers such as support and infrastructure cost.

**Readiness checklist to move to stage 5:**

- [ ] Growth is funded mostly from operations or with a clear efficiency path.
- [ ] Unit economics are known per segment and poor segments are repriced, redesigned, or deprioritized.
- [ ] Expansion revenue is a planned, forecast line with owners.
- [ ] Improvement cycles and experiments run continuously (see continuous improvement reference).

### Stage 5: Mature

**Goals:** defend and grow the installed base, maintain margin, and open new growth vectors (new segments, products, geographies, pricing models).

**Metrics that matter:** gross and net revenue retention, expansion ARR as a share of net new ARR, operating margin, share of revenue from products launched in recent years, customer health distribution.

**Capabilities that must exist:** portfolio pricing and packaging; account management for the largest customers; a structured way to incubate new products or segments with their own stage-appropriate metrics.

**Typical failure modes:** managing a new product line with mature-business metrics (it gets killed before it finds fit); complacency on retention; price increases without value evidence.

**Checklist for staying healthy:** new initiatives are evaluated against the stage 1 and 2 questions above, not against the core business's efficiency targets.

## Metrics

### Period growth rate

Definition: percentage change in a metric (usually ARR or MRR) between two points.

```text
period_growth = (value_end - value_start) / value_start
```

Unit: percent. Grain: company or segment, per period (month, quarter, year). Pitfall: comparing periods of different length, or mixing ARR definitions (contracted vs live).

### Compound monthly growth rate (CMGR)

Definition: the constant monthly rate that would take the starting value to the ending value over n months.

```text
CMGR = (value_end / value_start) ^ (1 / n_months) - 1
```

Unit: percent per month. Grain: company or segment. Pitfalls: sensitive to the chosen start and end months; a single large deal at either end distorts it. Use trailing windows (for example 6 or 12 months) and report the window.

### Compound annual growth rate (CAGR)

```text
CAGR = (value_end / value_start) ^ (1 / n_years) - 1
annualized_from_monthly = (1 + CMGR) ^ 12 - 1
```

Unit: percent per year. Grain: company. Pitfall: multiplying a monthly rate by 12 understates compounding; always annualize with the exponent.

### Why percentage growth slows

Growth percentage is net new ARR divided by the starting base. If the business adds the same absolute ARR each year, the percentage falls every year.

Illustrative example (hypothetical round numbers):

| Year | Starting ARR | Net new ARR | Growth |
|---|---|---|---|
| 1 | 1M | 2M | 200% |
| 2 | 3M | 3M | 100% |
| 3 | 6M | 4M | 67% |
| 4 | 10M | 5M | 50% |

Net new ARR grew every year, yet the percentage fell by three quarters. Plan and judge the team on absolute net new ARR, its composition, and its efficiency.

### Why retention and expansion dominate later

Net new ARR decomposes into sources:

```text
net_new_arr = new_arr + expansion_arr - contraction_arr - churned_arr
```

New ARR scales with acquisition capacity. Expansion and churn scale with the installed base. As the base grows, a few points of net revenue retention move more revenue than a large increase in new logos.

Illustrative example (hypothetical): a company with a 50M base and 110% net revenue retention adds 5M from the base before winning a single new customer. The same company at 95% loses 2.5M. The 7.5M gap equals what a sizable new-logo team might produce in a year. At a 2M base, the same retention gap is only 0.3M, which is why early-stage companies rightly focus on new customers and later-stage companies on the base.

## Implementation guide

1. **Record a stage assessment.** Store a dated stage assessment per business line (stage, evidence, blocking gaps) in a shared document or a small table. Revisit quarterly.
2. **Build the ARR movement table early.** One row per account per month with starting ARR, new, expansion, contraction, churn, ending ARR. This supports growth rate, NRR, and source decomposition at every stage.

```sql
-- Growth rates from a monthly ARR snapshot table (PostgreSQL)
WITH totals AS (
  SELECT month, SUM(ending_arr) AS arr
  FROM arr_movements
  GROUP BY month
)
SELECT
  month,
  arr,
  arr / LAG(arr) OVER (ORDER BY month) - 1                       AS mom_growth,
  POWER(arr / LAG(arr, 12) OVER (ORDER BY month), 1.0 / 12) - 1 AS cmgr_12m,
  arr / LAG(arr, 12) OVER (ORDER BY month) - 1                  AS yoy_growth
FROM totals
ORDER BY month;
```

3. **Tag every account with segment and acquisition motion** so stage metrics can be read per segment; a company can be in stage 3 in one segment and stage 1 in another.
4. **Match tooling to stage.** Stage 1: spreadsheet CRM and product analytics are enough. Stage 2: enforce CRM stage definitions and subscription events in billing. Stage 3: warehouse with a metrics layer and a metrics dictionary. Stage 4 and 5: automated segment-level unit economics and forecast models.
5. **Gate hiring plans on readiness.** Require the stage checklist evidence in the headcount request for revenue roles (for example, playbook link and current conversion rates before a new sales hire).
6. **Report growth composition monthly**: share of net new ARR from new, expansion, and net churn, with a 12-month trend.

## Anti-patterns

- Declaring product-market fit because revenue exists, while cohort retention keeps declining.
- Scaling a sales team to compensate for weak activation or retention.
- Running self-serve, inside sales, field sales, and partners at once before any is repeatable.
- Hiring a senior executive to "build the process" with no documented baseline to improve.
- Setting next year's plan as last year's growth percentage applied to a larger base.
- Annualizing monthly growth by multiplying by 12.
- Judging a new product line by the core business's efficiency targets.
- Letting the founder remain the only person who can close the largest deals past early traction.

## Audit checklist

| ID | Check | Evidence to look for | Severity |
|---|---|---|---|
| GS-01 | Current stage is assessed with evidence, not revenue alone | Dated stage assessment citing retention, repeatability, efficiency | Medium |
| GS-02 | Cohort retention is measured before scaling acquisition | Cohort usage or revenue retention curves by signup month | High |
| GS-03 | Funnel stages have written entry and exit criteria | CRM stage definitions, lifecycle documentation | High |
| GS-04 | Sales or conversion is repeatable without the founder | Win rates split by owner; non-founder attainment over two or more quarters | High |
| GS-05 | A written playbook exists before revenue hiring | Playbook document referenced in hiring plans | Medium |
| GS-06 | One primary motion is proven before adding another | Motion-level conversion and payback; launch dates of each motion | Medium |
| GS-07 | ARR movement table exists (new, expansion, contraction, churn) | Warehouse table or billing report by account and month | High |
| GS-08 | Growth rates are computed correctly (CMGR, CAGR with exponents) | Formulas in reports or SQL; no "monthly times 12" | Low |
| GS-09 | Planning uses absolute net new ARR and its composition | Plan documents with source breakdown | Medium |
| GS-10 | Net revenue retention is tracked monthly once past early traction | NRR report with trend | High |
| GS-11 | Efficiency metrics are reviewed by segment and channel | CAC payback, Burn Multiple or Magic Number by segment | Medium |
| GS-12 | New ramp time and attainment distribution are tracked while scaling | Rep cohort ramp reports | Medium |
| GS-13 | New products or segments are measured with early-stage metrics | Separate scorecards for incubated lines | Low |
| GS-14 | Tooling matches stage (no missing system of record, no premature complexity) | CRM, billing, analytics, warehouse inventory | Low |

## Related

- [Customer lifecycle](01-customer-lifecycle.md)
- [Metrics](02-metrics.md)
- [Pricing and packaging](03-pricing-and-packaging.md)
- [Go-to-market motions](04-go-to-market-motions.md)
- [Retention and expansion](08-retention-and-expansion.md)
- [Data and instrumentation](09-data-and-instrumentation.md)
- [Revenue operations](10-revenue-operations.md)
- [Continuous improvement](12-continuous-improvement.md)
