# Revenue Operations

> Scope: the operating function that keeps marketing, sales, customer success, finance, and product working from one set of definitions, systems, and rhythms. Load when: numbers disagree between teams, forecasts miss, tooling sprawls, or a company is formalizing how it plans and reviews revenue.

## Why it matters

Most revenue problems that look like people problems are process and definition problems. Marketing reports leads that sales says are not qualified; finance reports churn that customer success does not recognize; the board sees a forecast nobody believes. Revenue operations (RevOps) owns the shared layer underneath: definitions, stages, data, tools, cadence, and planning math. When it works, meetings are about decisions instead of reconciling spreadsheets.

## Core principles

1. **One metric dictionary, one owner per metric.** Every metric has a single definition, formula, grain, source, and accountable owner. Dashboards reference the dictionary; they do not redefine.
2. **Definitions change through change control, not in a dashboard filter.** Proposals are written, reviewed, versioned, dated, and announced, with history restated or annotated.
3. **Stages are shared across functions.** Marketing, sales, and customer success use the same lifecycle stages with explicit entry and exit criteria, and each handoff has an SLA.
4. **Separate operating views from reporting views.** Weekly dashboards drive action; monthly and quarterly views drive judgment. Do not show the board the weekly noise.
5. **Forecast with a method, then measure the method.** Track forecast accuracy over time and improve the method, not just the number.
6. **Plan capacity from math, not hope.** Quota, ramp, attainment distribution, and pipeline coverage produce hiring and target plans that are internally consistent.
7. **Fewer tools, clearer ownership.** Each tool has an owner, a purpose, and a system-of-record role. Overlap is removed deliberately.
8. **Write processes down where people work.** Playbooks, stage criteria, and routing rules live in version control or a maintained wiki, and automation matches the written rule.
9. **Review processes, not people.** Misses are analyzed as system failures with blameless reviews and tracked actions.

## Model / framework

### RevOps scope

| Area | Owns | Does not own |
|---|---|---|
| Definitions | Metric dictionary, stage criteria, change log | Target setting (leadership owns) |
| Systems | CRM configuration, routing, integrations, tool stack | Product analytics instrumentation (engineering owns, RevOps consumes) |
| Data | Revenue data models, dashboards, data quality for GTM data | Product database schema |
| Planning | Capacity models, territory and quota design, pipeline targets | Final budget approval |
| Cadence | Meeting structure, pre-reads, forecast process | Decisions made in those meetings |
| Enablement support | Process documentation, playbook maintenance | Content and coaching (sales enablement or managers) |

At early stage, one person or a founder covers this part time. Formalize it once there are separate marketing, sales, and customer success owners who each report numbers.

### Shared stage definitions

Use one table for every team. Adapt the criteria; keep the structure.

| Stage | Entry criteria | Exit criteria | Owner | Handoff SLA |
|---|---|---|---|---|
| Lead | Contact info captured with consent | Qualified or disqualified | Marketing | Scored within 1 business day |
| Qualified lead (marketing or product) | Meets fit and engagement or usage threshold | Accepted or rejected by sales | Marketing | Routed immediately |
| Sales accepted | Rep reviewed and accepted | Discovery held or disqualified | Sales | First touch within an agreed window, often same day |
| Opportunity | Discovery done, pain, budget path, and timeline identified | Won or lost | Sales | Stage updated at every change |
| Customer, onboarding | First payment or signed contract | Activation milestone reached | Customer success | Kickoff within agreed days |
| Customer, active | Activation milestone reached | Renewal, expansion, or risk flag | Customer success / account management | Health reviewed on a fixed cadence |
| At risk | Health below threshold or payment failure | Recovered or churned | Customer success | Plan within agreed days |
| Churned | Subscription ended | Reactivated | Marketing (win-back) | Exit reason recorded |

Rules:

- Rejected handoffs require a reason code from a fixed list. Review the distribution monthly; it is the best signal of a broken definition.
- Stage definitions live in the dictionary and in the CRM validation rules. If the CRM allows moving to a stage without meeting its entry criteria, the definition is advisory only.

### Metric dictionary structure

Each entry (see `templates/metrics-dictionary.yaml`):

| Field | Example content |
|---|---|
| `name` | net_revenue_retention |
| `definition` | Recurring revenue retained from a starting cohort including expansion, contraction, churn |
| `formula` | Written once, referenced by the SQL model |
| `grain` | per cohort, per month |
| `source_model` | Warehouse model name |
| `owner` | A named role, for example the finance lead |
| `version` and `effective_from` | Version number and date |
| `known_caveats` | Exclusions, currency handling |

### Change control for definitions

1. Proposal written (current definition, proposed definition, reason, affected dashboards, impact estimate on recent history).
2. Review by the metric owner and one representative from each consuming team.
3. Approval recorded with date and version bump.
4. Implementation in the metrics layer through a reviewed pull request.
5. History restated, or dashboards annotated with a break marker at `effective_from`.
6. Announcement in the operating cadence with before and after numbers for the last period.

Never change a definition mid-quarter for a metric tied to compensation or board reporting without explicit leadership sign-off.

### Dashboard hierarchy

| Level | Audience | Cadence | Content | Design rule |
|---|---|---|---|---|
| Operational | Team leads and individual contributors | Daily to weekly | Pipeline created, stage movement, activation queue, at-risk accounts, SLA breaches | Lists of records to act on, not only charts |
| Management | Functional leaders, executive team | Monthly | Funnel conversion and velocity, bookings vs plan, retention and expansion, CAC payback, forecast accuracy | Trends with plan and prior period |
| Board | Board and investors | Quarterly | ARR and growth, net and gross revenue retention, efficiency (for example Burn Multiple, Magic Number), cash runway, forecast vs actual | Few metrics, consistent definitions quarter over quarter |

Every tile links to its dictionary entry. A number without a definition link is not allowed on management or board views.

### Forecasting

| Method | How it works | Good for |
|---|---|---|
| Rep commit roll-up | Reps categorize deals (commit, best case, pipeline) and managers adjust | Near-term sales-led bookings |
| Stage-weighted pipeline | Pipeline value times historical stage-to-close rate | Sanity check on the roll-up |
| Cohort and run-rate model | Existing ARR times expected retention plus expected new from historical rates | Self-serve and renewal revenue |
| Blended | Combine methods and explain the gap | Most companies past early stage |

Cadence: weekly forecast call for the current quarter; monthly refresh of the full-year view; quarterly re-plan.

Track accuracy every period:

```text
forecast_error_pct = (actual - forecast) / forecast
forecast_accuracy  = 1 - abs(forecast_error_pct)
```

Record the forecast at fixed snapshot points (for example week 2, week 6, week 10 of the quarter) so accuracy can be compared across quarters. Also track bias (average signed error): consistent under-forecasting is sandbagging, consistent over-forecasting is optimism, and both are fixable.

### Capacity planning

Core relationships:

```text
productive_capacity = sum over reps of (quota * ramp_factor(tenure_month) * expected_attainment)
required_pipeline   = bookings_target / win_rate
pipeline_coverage   = open_pipeline_for_period / remaining_target
hiring_lead_time    = recruiting_time + ramp_time
```

| Input | How to set it | Pitfall |
|---|---|---|
| Quota | Derived from rep cost and target efficiency, validated against historical productivity | Setting quota from the top-down target alone |
| Ramp schedule | Percentage of full quota by tenure month from historical data | Assuming full productivity on day one |
| Attainment distribution | Share of reps at or above quota, in bands | Planning as if every rep hits 100 percent |
| Win rate and cycle length | Trailing periods by segment | Using blended rates across segments |
| Attrition | Historical rep turnover | Ignoring backfill ramp time |

Typical guidance, calibrate to your segment: a healthy plan expects a majority but not all reps to reach quota; if nearly everyone hits, quotas are low, and if few do, the plan or the process is broken. Illustrative example: a target of 1,000,000 in new ARR with a win rate of 25 percent needs about 4,000,000 in qualified pipeline created early enough to close within the period.

### Tooling consolidation

Inventory every GTM tool with: owner, purpose, system-of-record role, users, annual cost, integrations, overlap. Then:

| Finding | Action |
|---|---|
| Two tools do the same job | Pick one, migrate, retire the other with a date |
| Tool with no owner | Assign or retire |
| Tool writes to CRM fields another tool also writes | Define field ownership, restrict write access |
| Manual export and import between tools | Replace with integration or reverse ETL |
| Low usage relative to licenses | Reduce seats at renewal |

Review the inventory at least twice a year and before each renewal.

### Process documentation as code

- Keep stage definitions, routing rules, lead scoring weights, and SLA values in a versioned file (YAML or similar) that both documentation and automation read.
- Playbooks (discovery, handoff, onboarding, renewal, escalation) live in a maintained location with an owner and a last-reviewed date.
- Every automation (routing, scoring, alerts) references the rule it implements. When the rule changes, the automation changes in the same review.

### Operating cadence

| Meeting | Frequency | Attendees | Inputs | Outputs |
|---|---|---|---|---|
| Pipeline review | Weekly | Sales leaders, RevOps, marketing lead | Stage movement, new pipeline, slipped deals, forecast categories | Deal actions, forecast update |
| Retention review | Weekly or biweekly | Customer success leads, RevOps | At-risk list, renewals in next 90 days, payment failures | Save plans, escalations |
| Monthly business review | Monthly | Executive team, functional leads | Management dashboard, variance vs plan, experiments | Decisions, owner and date for each |
| Quarterly planning | Quarterly | Executive team, finance, RevOps | Board dashboard, capacity model, forecast accuracy | Targets, hiring plan, priority bets |
| Definitions and process forum | Monthly | One lead each from marketing, sales, CS, product, finance, RevOps | Definition change proposals, handoff rejection data, tooling issues | Approved changes, cross-functional fixes |

Meeting rules: pre-reads sent in advance, one owner per agenda item, decisions and actions logged with owners and due dates, and the first item reviews last meeting's actions.

### Blameless process reviews

Run a review when a forecast misses beyond tolerance, a large deal or account is lost unexpectedly, a handoff SLA is systematically breached, or a data error reaches a management or board view.

1. Timeline of facts from system records.
2. What the process expected to happen versus what happened.
3. Contributing factors in definitions, data, tooling, incentives, and cadence.
4. Actions that change the system (rule, automation, definition, training), each with an owner and date.
5. Follow-up at the next definitions and process forum.

Focus on why the system allowed the outcome, not on who made the mistake.

## Metrics

**Forecast accuracy**
Definition: closeness of forecast to actual at a fixed snapshot point.

```text
forecast_accuracy = 1 - abs(actual - forecast) / forecast
```

Unit: percent. Grain: per period, per snapshot week, per segment. Pitfalls: measuring only the final-week forecast; mixing segments.

**Forecast bias**

```text
forecast_bias = mean((actual - forecast) / forecast) over last N periods
```

Unit: percent, signed. Grain: per team, per period. Pitfall: reporting accuracy without direction hides sandbagging.

**Pipeline coverage**

```text
pipeline_coverage = qualified_open_pipeline_closing_in_period / remaining_bookings_target
```

Unit: ratio. Grain: per segment, weekly. Pitfalls: counting unqualified or stale deals; one coverage target for all segments when win rates differ.

**Quota attainment distribution**

```text
share_at_or_above_quota = reps_with_attainment_ge_100pct / ramped_reps
```

Unit: percent. Grain: per period, ramped reps only. Pitfall: including ramping reps.

**Handoff acceptance rate**

```text
acceptance_rate = handoffs_accepted / handoffs_sent
```

Unit: percent. Grain: per handoff type, per month. Pitfall: ignoring the rejection reason codes.

**SLA compliance**

```text
sla_compliance = handoffs_actioned_within_sla / handoffs_sent
```

Unit: percent. Grain: per team, weekly.

**Data freshness and definition coverage**

```text
definition_coverage = dashboard_tiles_linked_to_dictionary / total_tiles
```

Unit: percent. Grain: per dashboard level. Pitfall: linking tiles to entries that no longer match the query.

## Implementation guide

- **Dictionary file**: create `metrics-dictionary.yaml` from the template, one entry per metric used on management or board views. Add a CI check that every metric model in the warehouse has a dictionary entry and vice versa.
- **Change log**: add a `CHANGELOG` section or table in the dictionary with version, date, metric, change, approver.
- **Stage config**: store stage criteria and SLAs in a versioned config file. Generate CRM validation rules and routing from it where the CRM supports it, or document the mapping.
- **CRM hygiene**: required fields per stage, reason codes on closed-lost and rejected handoffs, locked edits on closed periods, audit history enabled.
- **Forecast snapshots**: a scheduled job that writes forecast values to a `forecast_snapshots` table (`period`, `snapshot_date`, `segment`, `method`, `value`), so accuracy is computed from data, not memory.
- **Capacity model**: a versioned spreadsheet or SQL model with inputs in one clearly labeled place and outputs for hiring and pipeline targets.
- **Dashboards**: three folders (operational, management, board) with ownership and a review date. Archive anything unused for a quarter.
- **Tool inventory**: a maintained table with owner, purpose, cost, renewal date.
- **Meeting templates**: pre-read and decision log templates stored with the playbooks.
- **Review template**: blameless review document with the five sections above, stored and indexed.

Code-level and repository signals:

| Look for | What it tells you |
|---|---|
| `metrics-dictionary.yaml` or a semantic layer with descriptions and owners | Shared definitions exist |
| Metric SQL duplicated across dashboard queries | Definitions drift |
| Stage names hardcoded in multiple services with different spellings | No shared stage config |
| `forecast_snapshots` table or equivalent | Accuracy is measurable |
| Routing or scoring logic with magic numbers and no linked rule | Undocumented process |
| Many CRM or analytics SDKs in dependencies | Tool sprawl |

## Anti-patterns

- Each team maintains its own spreadsheet version of pipeline, churn, or ARR.
- Definitions changed silently, producing a step change in a trend that is then presented as performance.
- Marketing optimizes for lead volume under a definition sales does not accept.
- Forecast is a single number from the head of sales with no method or accuracy history.
- Quotas set by dividing the target by headcount without ramp or attainment assumptions.
- Board deck metrics defined differently from the management dashboard.
- New tool bought for every new problem, with no owner and overlapping CRM writes.
- Playbooks written once and never reviewed; automation drifts from the documented rule.
- Meetings without pre-reads, decisions, or action tracking.
- Post-mortems that name individuals and produce no system change.

## Audit checklist

| ID | Check | Evidence to look for | Severity |
|---|---|---|---|
| RO-01 | A single metric dictionary exists with definition, formula, grain, source, owner | Dictionary file or semantic layer | High |
| RO-02 | Dashboards reference dictionary metrics instead of redefining them | Tiles linked to entries; no duplicated metric SQL | Medium |
| RO-03 | Definition changes follow documented change control with a dated log | Change log with versions and approvers | Medium |
| RO-04 | Lifecycle stages are shared by marketing, sales, and CS with entry and exit criteria | One stage table used by all teams | High |
| RO-05 | CRM enforces stage entry criteria and requires reason codes | Validation rules, required fields | Medium |
| RO-06 | Handoffs have SLAs that are measured | SLA compliance report | Medium |
| RO-07 | Dashboards are split into operational, management, and board levels | Folder structure, owners, cadence | Low |
| RO-08 | Board metrics use the same definitions every quarter | Definitions unchanged or restated with notes | High |
| RO-09 | Forecast method is documented and uses more than one approach | Forecast process doc, multiple methods | Medium |
| RO-10 | Forecast accuracy and bias are tracked from stored snapshots | Snapshot table and accuracy report | High |
| RO-11 | Capacity model includes quota, ramp, attainment distribution, attrition | Versioned model with explicit inputs | Medium |
| RO-12 | Pipeline coverage targets are set per segment from win rates | Segment-level coverage report | Medium |
| RO-13 | GTM tool inventory exists with owner, purpose, cost, overlap | Maintained inventory | Low |
| RO-14 | Field write ownership between tools is defined | Integration docs, restricted permissions | Medium |
| RO-15 | Process rules (routing, scoring, SLAs) are versioned and match automation | Config file and automation referencing it | Medium |
| RO-16 | Weekly, monthly, and quarterly operating meetings run with pre-reads and decision logs | Calendar, templates, logs | Medium |
| RO-17 | A cross-functional forum reviews definitions and handoff issues | Forum notes with decisions | Low |
| RO-18 | Misses trigger blameless reviews with tracked system-level actions | Review documents and action follow-up | Low |

## Related

- [01-customer-lifecycle.md](01-customer-lifecycle.md): lifecycle stages this function governs
- [02-metrics.md](02-metrics.md): metric formulas referenced by the dictionary
- [06-sales-process.md](06-sales-process.md): opportunity stages and qualification
- [09-data-and-instrumentation.md](09-data-and-instrumentation.md): systems of record and data quality
- [11-growth-stages.md](11-growth-stages.md): when to formalize RevOps
- [12-continuous-improvement.md](12-continuous-improvement.md): review loops and experiments
- `templates/metrics-dictionary.yaml`
