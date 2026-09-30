# Continuous Improvement

> Scope: how to find the constraint in the revenue funnel, choose and test improvements, run short improvement cycles, and build learning loops that compound. Load when: growth has stalled, a metric moved unexpectedly, the team is choosing between spending more on leads or improving conversion, or you need an operating rhythm for improvement work.

## Why it matters

Revenue is the output of a chain of conversions: visitor to signup, signup to activated, activated to paid, paid to retained, retained to expanded. Each link multiplies the next. That structure has two consequences. First, one stage is usually the binding constraint, and effort spent elsewhere produces little. Second, modest improvements across several stages multiply into a large gain, often larger and cheaper than buying more top-of-funnel volume. A team that tests and iterates on a regular cadence keeps those gains; a team that only reacts to quarterly misses rarely does.

## Core principles

1. Find the constraint before acting. Improve the stage with the largest gap against its own trend and against a reasonable target, not the stage that is easiest to change.
2. Compare against your own history first, then peers. Internal trend by segment is the most reliable baseline; external benchmarks are typical ranges to calibrate against, not targets.
3. Price multi-stage conversion work alongside single large bets; because stage rates multiply, several modest gains can match one large one.
4. Separate input levers (more volume in) from conversion levers (more of the volume moves forward) and price both before choosing.
5. Model scenarios before committing budget or headcount. A spreadsheet of stage volumes and rates is enough.
6. Test with a written hypothesis, one primary metric, guardrail metrics, and a sample size decided in advance.
7. Prioritize by expected impact against effort and confidence; kill low-value work explicitly.
8. Run improvement as plan-do-check-act cycles aligned with your existing planning cadence, so a failed idea costs weeks, not quarters.
9. Target enablement by expected team lift: the headcount in a group times the gain you can realistically coach, measured on stage conversion rather than activity.
10. Close every cycle with a retrospective and write the result down, including failures, so the organization learns once.

## Model / framework

### Funnel bottleneck analysis

Step 1: lay out the funnel with volumes and conversion rates per stage, per segment, for the last several periods.

| Stage transition | Conversion (this period) | Trailing 6-period average | Change vs trend |
|---|---|---|---|
| Visitor to signup | rate | rate | points |
| Signup to activated | rate | rate | points |
| Activated to paid | rate | rate | points |
| Paid to retained (first renewal) | rate | rate | points |
| Retained to expanded | rate | rate | points |

Step 2: identify candidates using three signals:

| Signal | Interpretation |
|---|---|
| Largest decline against own trend | Something broke recently (change in product, channel mix, team, pricing) |
| Largest gap against a calibrated external range | Structural weakness, likely present for a long time |
| Largest stage velocity increase (time in stage) | Friction or capacity shortage even if conversion is steady |

Step 3: confirm the constraint by segmenting (segment, channel, plan, owner, cohort month). A drop concentrated in one slice points to a local cause; a uniform drop points to a systemic cause.

Step 4: estimate the revenue value of fixing it (see scenario modeling) and compare with the other candidates.

### Why small gains compound multiplicatively

Output of a funnel equals input volume times the product of stage conversion rates:

```text
customers_out = volume_in * r1 * r2 * r3 * ... * rn
```

A relative improvement of g in each of n stages raises output by (1 + g)^n.

Illustrative example (hypothetical round numbers): 10,000 visitors per month; 5% sign up, 40% of signups activate, 25% of activated users pay.

| Scenario | Signups | Activated | Paying | Change |
|---|---|---|---|---|
| Baseline | 500 | 200 | 50 | |
| +10% visitors only (11,000) | 550 | 220 | 55 | +10% |
| +10% relative on one stage (activation 44%) | 500 | 220 | 55 | +10% |
| +10% relative on all three stages (5.5%, 44%, 27.5%) | 550 | 242 | about 66 | about +33% |
| +20% relative on all three stages (6%, 48%, 30%) | 600 | 288 | about 86 | about +73% |

Three 10% relative gains produce about 33%, not 30%, and the effect grows with more stages and larger gains. Relative gains of 10% on a single stage are often achievable within one or two improvement cycles; a 33% increase in paid acquisition budget with constant efficiency is usually harder and costs more every month.

### Input levers vs conversion levers

| Dimension | Input levers (buy more volume) | Conversion levers (improve rates) |
|---|---|---|
| Examples | More ad spend, more outbound reps, new channels, events | Better onboarding, qualification, pricing page, sales training, activation nudges |
| Speed | Fast to start | Slower to start, lasting once achieved |
| Cost profile | Recurring, scales linearly or worse (rising marginal CAC) | Mostly one-time build or training cost |
| Risk | Diminishing returns; lower-fit volume can lower downstream rates | Requires diagnosis; wrong stage choice wastes effort |
| Best when | Conversion is healthy and at or above trend; capacity is idle | Conversion is below trend or target; downstream capacity is saturated |

Rule: when a stage downstream is below trend, adding input volume pushes more people into a leaking stage. Fix the leak first unless the modeled return on added volume is clearly higher.

### Scenario modeling

Build a simple model per segment with volume and rate per stage, then compare scenarios on the same output (new ARR, net new ARR, or payback).

```text
new_arr = volume_in * r1 * r2 * ... * rn * average_first_year_value
scenario_delta = new_arr(scenario) - new_arr(baseline)
roi = (scenario_delta * expected_lifetime_factor - scenario_cost) / scenario_cost
```

Model at least: baseline, input-only change, single-stage conversion change, multi-stage conversion change, and a pessimistic case. State the assumptions next to the numbers. Include downstream effects: added low-fit volume often lowers later-stage rates, and better qualification can lower early conversion while raising win rate.

### Experiment design

| Element | Requirement |
|---|---|
| Hypothesis | "If we change X for segment Y, metric Z will move by at least N because of reason R." |
| Primary metric | One metric, defined in the metrics dictionary, at the stage being changed |
| Guardrail metrics | Metrics that must not degrade (downstream conversion, refund rate, support tickets, discount depth, churn) |
| Unit of randomization | User, account, or rep; use account when users in one account influence each other |
| Sample size and duration | Decided before launch; run full weekly cycles |
| Decision rule | Ship, iterate, or stop criteria written before seeing results |

Sample size basics for a conversion rate test (two variants, about 5% significance, about 80% power):

```text
n_per_variant ≈ 16 * p * (1 - p) / delta^2
  p     = baseline conversion rate
  delta = smallest absolute change worth detecting
```

Illustrative example (hypothetical): baseline 10%, detect a 2 point absolute lift. n ≈ 16 *0.10* 0.90 / 0.0004 = 3,600 per variant. If the stage only sees 1,000 units a month, the test would take months; test a larger change, use a higher-volume upstream metric as a leading indicator, or use a before and after comparison with a holdout and accept lower confidence.

Common mistakes: stopping when the result first looks significant; testing many variants without adjusting; measuring only the changed stage and missing downstream harm; changing several things at once and then attributing the result to one of them.

When volume is too low for statistical tests (typical for enterprise sales), use structured comparisons: pilot group vs control group of reps, pre and post periods with the same seasonality, and qualitative evidence from call reviews. Label conclusions as directional.

### Prioritization

Score each candidate improvement:

| Field | Scale |
|---|---|
| Impact | Modeled revenue delta (from scenario model), bucketed 1 to 5 |
| Confidence | Strength of evidence that the change will work, 1 to 5 |
| Effort | People-weeks, bucketed 1 to 5 (higher is more effort) |

```text
priority_score = (impact * confidence) / effort
```

Rank, then sanity check: at most one or two major initiatives per team per cycle; always address a confirmed constraint before a higher-scoring item on a non-constraint stage.

### Improvement cycle (plan, do, check, act)

Use the standard plan-do-check-act loop. Length follows your planning cadence; most teams land between a few weeks and a month.

| Phase | Activities | Output |
|---|---|---|
| Plan | Bottleneck analysis, segment cuts, session or call reviews, interviews; write the hypothesis | Named constraint, hypothesis, baseline numbers, decision rule |
| Do | Ship the product change, content, or playbook update; train the people involved | Change live or team enabled |
| Check | Compare against baseline and guardrails; observe adoption and give feedback | Measured result and adoption level |
| Act | Keep, extend, or revert; retrospective; update the standard (playbook, definition, default) | Decision and written learning |

Keep cycles short enough that a failed hypothesis costs weeks, not quarters. Some outcomes (renewal, expansion) lag the cycle; evaluate those on a leading indicator (usage depth, health score, adoption of a feature) and schedule a later read of the lagging metric.

### Enablement and coaching: target by expected lift

Performance varies across any team. Decide where enablement goes by modeling the team-level effect, not by habit.

```text
expected_team_lift(group) = headcount(group) * achievable_gain(group) / total_headcount
```

Illustrative example (hypothetical): ten reps with win rates of 30, 30, 20, 20, 20, 20, 20, 20, 10, 10 percent; team average 20%. A 4 point gain for the six reps at 20% adds 2.4 points to the team; a 10 point gain for the two reps at 10% adds 2 points. Run the numbers for your own distribution, and treat persistent low performance as a possible hiring or fit question, not only a skill gap.

Practice:

- Identify the specific stage where lower-converting reps or cohorts lose deals or users relative to higher-converting ones (for example discovery depth, multi-threading, next-step discipline, activation follow-up).
- Turn the observed behavior of higher performers on that stage into a concrete, observable practice.
- Train in short sessions, then reinforce on real calls or accounts.
- Measure the stage conversion per person before and after; not activity counts alone.
- Handle sustained underperformance with a separate plan with clear timeline and criteria.

### Retrospectives and learning loops

At the end of every cycle, record in a shared log:

```yaml
cycle: "2026-Q3-cycle-2"
constraint: "signup to activated, SMB segment"
hypothesis: "Guided setup raises activation by 5 relative percent"
change: "Added guided setup checklist"
primary_metric: { baseline: 0.40, result: 0.43 }
guardrails: { support_tickets_per_signup: "no change", paid_conversion: "no change" }
decision: keep
learning: "Checklist step 3 had the largest drop-off; next cycle targets it"
owner: "growth lead"
```

Review the log quarterly: which hypotheses keep failing, which stages improved, which improvements decayed after the cycle ended (a sign that coaching or product support stopped).

### Alerting on simultaneous metric shifts

A single metric moving is often noise; several related metrics moving together in the same period usually signals a real change (tracking break, pricing change, channel shift, product regression).

| Pattern | Likely cause | First check |
|---|---|---|
| Several stage rates drop at once across all segments | Tracking or definition change | Event volumes, recent releases to instrumentation, CRM field changes |
| Top-of-funnel volume up, early conversion down | Channel mix shift to lower-fit sources | Conversion by source |
| Activation down, support tickets up | Product regression or onboarding change | Release log, error rates |
| Win rate down, cycle length up, discount depth up | Competitive or pricing pressure | Loss reasons, competitor mentions |
| Usage down, then contraction and churn up | Value erosion in a segment | Health scores, cohort usage by segment |

Implement alerts as: for each key metric, compare the latest period to a trailing baseline (for example a trailing mean and standard deviation, or a percentage band); flag when two or more related metrics breach in the same period; route to the metric owner with the segment cut attached.

## Metrics

| Metric | Formula | Unit | Grain | Pitfalls |
|---|---|---|---|---|
| Stage conversion rate | see below | percent | per stage, segment, cohort period | Mixing cohort and period views; changing stage definitions mid-series |
| Stage velocity | see below | days | per stage, segment | Averages hide long tails; report median and 80th percentile |
| Funnel yield | see below | percent | per segment, cohort | Ignoring time lag between stages |
| Improvement rate | see below | percent | per cycle | Crediting seasonality to the change |
| Cycle win ratio | see below | percent | per quarter | Only logging successes |

```text
stage_conversion_rate = count_entering_next_stage_from_cohort / count_entering_stage_in_cohort
stage_velocity        = median(days between stage entry and next stage entry)
funnel_yield          = r1 * r2 * ... * rn
improvement_rate      = (result_metric - baseline_metric) / baseline_metric
cycle_win_ratio       = cycles_with_decision_keep / total_cycles_completed
```

## Implementation guide

1. **Stage history table.** Store every stage entry and exit with timestamps, segment, source, and owner (`stage_transitions(account_id, from_stage, to_stage, entered_at, segment, source, owner_id)`). Conversion and velocity for any cut then become queries, not projects.
2. **Funnel view by cohort.** Build a warehouse view that computes conversion and velocity per stage by cohort month and segment, with trailing averages.

```sql
-- Stage conversion by cohort month with trailing 6-month average (PostgreSQL)
WITH entered AS (
  SELECT date_trunc('month', entered_at) AS cohort, to_stage AS stage, account_id
  FROM stage_transitions
),
advanced AS (
  SELECT e.cohort, e.stage, COUNT(DISTINCT e.account_id) AS n_in,
         COUNT(DISTINCT t.account_id) AS n_next
  FROM entered e
  LEFT JOIN stage_transitions t
    ON t.account_id = e.account_id AND t.from_stage = e.stage
  GROUP BY e.cohort, e.stage
)
SELECT cohort, stage, n_in, n_next,
       n_next::numeric / NULLIF(n_in, 0) AS conversion,
       AVG(n_next::numeric / NULLIF(n_in, 0))
         OVER (PARTITION BY stage ORDER BY cohort ROWS BETWEEN 6 PRECEDING AND 1 PRECEDING) AS trailing_avg
FROM advanced
ORDER BY stage, cohort;
```

Recent cohorts are immature: exclude cohorts younger than the typical stage duration or mark them as incomplete.
3. **Scenario model.** Keep a versioned spreadsheet or notebook reading current rates from the funnel view; scenarios override individual rates or volumes.
4. **Experiment registry.** A table or document with hypothesis, metrics, guardrails, sample size, start and end dates, decision. Link feature flags to registry entries.
5. **Feature flags and assignment logging.** Log the variant per user or account in the event stream so results can be computed in the warehouse.
6. **Per-person stage metrics** for coaching: stage conversion by owner with enough volume to be meaningful; suppress or flag cells with small counts.
7. **Anomaly job.** A scheduled job that computes deviations for key metrics, groups related metrics, and alerts owners when multiple related metrics shift in the same period.
8. **Cycle calendar.** Fixed start dates for improvement cycles and a standing evaluation meeting, so the rhythm does not depend on someone remembering.

## Anti-patterns

- Working on the stage that is most visible or easiest instead of the confirmed constraint.
- Buying more leads while a downstream stage is below trend.
- Declaring a win from a test that was stopped early or has no guardrails.
- Launching large redesigns with several simultaneous changes and no attribution plan.
- Coaching only to activity counts (calls made, emails sent) instead of stage conversion.
- Allocating coaching time by habit or seniority instead of by modeled team lift.
- Quarter-long initiatives with no intermediate evaluation.
- No written record of past experiments, so the same failed idea is retried.
- Treating benchmark ranges from other companies as targets without segment calibration.
- Alerting on every single-metric wiggle, so real simultaneous shifts are ignored.

## Audit checklist

| ID | Check | Evidence to look for | Severity |
|---|---|---|---|
| CI-01 | Stage transitions are recorded with timestamps and segment | Stage history table or CRM field history | High |
| CI-02 | Conversion and velocity are reported per stage and segment with trend | Funnel dashboard with trailing averages | High |
| CI-03 | The current constraint stage is named and documented | Recent diagnosis note or planning document | Medium |
| CI-04 | Input vs conversion investments are compared with a scenario model | Model file with baseline and scenarios | Medium |
| CI-05 | Experiments have written hypothesis, primary metric, and guardrails | Experiment registry entries | High |
| CI-06 | Sample size or duration is set before launch | Registry fields or pre-launch notes | Medium |
| CI-07 | Variant assignment is logged for analysis | Events with experiment and variant properties | Medium |
| CI-08 | Improvement work is prioritized with impact, confidence, and effort | Scored backlog | Low |
| CI-09 | Improvement cycles run on a regular cadence with a check step | Cycle calendar, evaluation meeting notes | Medium |
| CI-10 | Coaching targets stage conversion, prioritized by expected team lift | Per-person stage metrics, coaching plans | Medium |
| CI-11 | Retrospectives are recorded, including failures | Learning log with keep and revert decisions | Medium |
| CI-12 | Alerts detect simultaneous shifts across related metrics | Anomaly job configuration, alert history | Medium |
| CI-13 | Immature cohorts are excluded or flagged in conversion reports | Report logic or annotations | Low |
| CI-14 | External benchmarks are used as calibrated ranges, not targets | Target-setting documents referencing own trend | Low |

## Related

- [Customer lifecycle](01-customer-lifecycle.md)
- [Metrics](02-metrics.md)
- [Demand and acquisition](05-demand-and-acquisition.md)
- [Sales process](06-sales-process.md)
- [Onboarding and activation](07-onboarding-and-activation.md)
- [Data and instrumentation](09-data-and-instrumentation.md)
- [Revenue operations](10-revenue-operations.md)
- [Growth stages](11-growth-stages.md)
