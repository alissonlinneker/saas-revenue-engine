# Onboarding and Activation

> Scope: getting new accounts from signup or signature to the first real value, and defining the activation metric that predicts retention. Load when: designing or auditing onboarding flows (self-serve or sales-led), choosing an activation metric, reducing time to value, or instrumenting the early customer journey.

## Why it matters

Most churn is decided early. An account that never reaches meaningful value in its first days or weeks rarely recovers, no matter how good renewal and success programs are later. Onboarding is also where acquisition spend is either converted into a durable customer or wasted: every signup that fails to activate is paid acquisition cost with no return. Improving activation is usually the cheapest lever on retention and on trial to paid conversion, because it acts on accounts that already showed intent.

## Core principles

1. **Define value from the customer's point of view.** Activation is the customer achieving something they came for, not completing your setup steps.
2. **Pick an activation metric that predicts retention.** Validate it with data per cohort. A metric that does not correlate with retention is a vanity milestone.
3. **Shorten time to value relentlessly.** Remove, defer, or automate every step that is not required to reach first value.
4. **Separate setup from value.** Setup (invite team, connect integration) is a means. Track it, but do not confuse it with activation.
5. **Design for the empty state.** A new account has no data. Templates, sample data, and imports make the product useful before the customer invests effort.
6. **Carry sales commitments into onboarding.** For sales-led accounts, the success plan starts from outcomes and deadlines agreed during the sale.
7. **Instrument before you optimize.** Every onboarding step must emit an event with account and user identity so funnels can be built.
8. **Measure per cohort, not in aggregate.** Activation rate by signup week, segment, source, and plan reveals changes that averages hide.
9. **Treat onboarding churn as its own failure mode.** Accounts that leave before activating need different fixes from accounts that leave after using the product.

## Model / framework

### Key definitions

| Term | Definition |
|------|------------|
| Time to value (TTV) | Elapsed time from signup or contract start to the first value milestone |
| Setup complete | All required configuration done (account created, integration connected, users invited) |
| First value milestone | First time the customer gets the core outcome (report generated, first invoice sent, first deployment, first campaign delivered) |
| Activation | A behavioral threshold that, when reached in a defined window, predicts retention (example shape: "did X at least N times with at least M users within D days") |
| Habit or adoption | Repeated use at the expected frequency for the use case (daily, weekly, monthly) |
| Onboarding churn | Accounts that cancel, stop paying, or go inactive before reaching activation |

### Discovering the aha moment and activation metric

Use this method. It works with a few hundred accounts and improves as volume grows.

1. **Define the retention outcome.** Pick what "retained" means for your product: still paying at day 90, still active in week 8, renewed at year one. Choose a horizon you can observe for historical cohorts.
2. **List candidate behaviors.** From product knowledge and customer interviews, list 10 to 30 early actions: created first project, invited a teammate, connected data source, used core feature N times, shared output externally.
3. **Build the dataset.** For each account in several past cohorts, compute whether each behavior happened within the first D days (try 1, 7, 14, 30) and the retention outcome.
4. **Compare retention with and without each behavior.** Look for behaviors where retention is much higher among accounts that did it, and where a meaningful share of accounts reach it (a behavior only 2% reach is not useful as a target).
5. **Find thresholds.** For frequency behaviors, test counts (1, 3, 5, 10) and team size (1, 2, 3+ users). Look for the point where the retention gain flattens.
6. **Check it is not just a proxy for engagement.** Heavy users do everything. Prefer behaviors that are specific to the core value and that you can influence through product changes.
7. **Validate with interviews.** Talk to retained and churned customers to confirm the behavior reflects the moment they understood the value.
8. **Test causality where possible.** Run an experiment that pushes more accounts to the behavior. If retention of the treated group rises, the metric is causal enough to steer by.
9. **Re-validate at least yearly** and after major product or ICP changes.

Correlation is not causation. Treat the activation metric as a hypothesis you keep testing, not a fixed truth.

### Activation metric quality checklist

- [ ] Behavioral (something the customer does), not a page view or a setup checkbox
- [ ] Measured within a fixed window after signup or start date
- [ ] Clearly higher retention for accounts that reach it, across several cohorts
- [ ] Reached by a meaningful share of accounts, with room to grow
- [ ] Defined at account level for B2B (team behavior), not only user level
- [ ] Computable daily from event data, written in the metrics dictionary

### Self-serve onboarding flow

| Element | What to build | Purpose |
|---------|---------------|---------|
| Signup | Minimal fields; ask 1 to 3 questions about role and goal | Personalize path without friction |
| Empty states | Every blank screen explains what goes here and offers one primary action | Avoid dead ends |
| Templates | Pre-built starting points by use case | Skip configuration, show what good looks like |
| Sample data | Optional demo dataset that can be removed | Let users see value before importing real data |
| Import and integrations | Guided import, connectors for common sources | Get real data in fast |
| Checklist | 3 to 5 steps leading to the first value milestone, with progress | Clear next action; stop showing it once complete |
| In-product guidance | Contextual tips at the point of need, not long tours | Teach while doing |
| Team invites | Prompt to invite at the moment collaboration becomes useful | Multi-user accounts retain better in most B2B products |
| Lifecycle emails | Behavior-triggered, not only time-based | Recover stalled users |
| Human help | Chat, office hours, or sales assist for high-fit accounts | Rescue valuable accounts that stall |

Lifecycle email logic (illustrative):

| Trigger | Message goal |
|---------|--------------|
| Signed up, no core action after 1 day | One-step path to first value, link to template |
| Completed setup, no first value after 3 days | Show example outcome, offer help |
| Reached first value | Reinforce, suggest next step toward activation |
| Activated | Introduce collaboration or second use case |
| Inactive for 7 days during trial | Ask what blocked them, offer a call for high-fit accounts |
| Trial ends in 3 days | Summarize value achieved, clear upgrade path |

Suppress emails that no longer apply as soon as the behavior happens.

### Sales-led onboarding flow

| Phase | Activities | Exit criteria |
|-------|-----------|---------------|
| Internal handoff | Review handoff record from sales: outcomes, deadlines, stakeholders, commitments, risks | Onboarding lead confirms understanding |
| Kickoff | Meeting with customer project lead and sponsor; restate outcomes and success metrics; confirm timeline | Signed-off success plan |
| Success plan | Document with outcomes, metrics and targets, milestones, owners on both sides, dates | Shared and agreed |
| Technical implementation | Provisioning, SSO, integrations, data migration, configuration | Environment production-ready |
| Training and enablement | Admin training, user training by role, materials | Target users trained |
| First value milestone | The first agreed outcome is achieved in production | Customer confirms |
| Transition | Hand over to customer success or account management with a health baseline | Onboarding closed, retention owner assigned |

Implementation milestones should be dated from the customer's deadline driver captured during the sale. Track planned versus actual date for each milestone.

### First value milestone tracking

Store milestones as data, not only in project tools.

| Field | Example |
|-------|---------|
| account_id | acct_123 |
| milestone_key | first_integration_live |
| planned_date | from success plan |
| achieved_at | timestamp from event or CSM confirmation |
| source | event or manual |
| owner | onboarding lead |

Alert when a milestone passes its planned date without being achieved.

## Metrics

**Activation rate**

- Definition: share of new accounts in a cohort that reach the activation threshold within the window.
- Unit: percent. Grain: per signup cohort (week or month), segmented by source, plan, segment.
- Common mistakes: counting users instead of accounts in B2B; measuring cohorts that have not finished their window.

```text
activation_rate(cohort) = accounts_activated_within_D_days / accounts_in_cohort   -- only cohorts older than D days
```

**Time to value (TTV)**

- Definition: median time from start (signup or contract start date) to first value milestone.
- Unit: hours or days. Grain: per account, reported as median per cohort and segment.
- Common mistakes: using mean; excluding accounts that never reach value (report the share that did not, alongside the median).

```text
ttv = median(first_value_at - start_at)   -- among accounts that reached it
never_reached_share = accounts_without_first_value_after_window / accounts_in_cohort
```

**Onboarding step conversion**

```text
step_conversion(n) = accounts_completing_step_n / accounts_completing_step_(n-1)
```

Grain: per cohort. Use it to find the largest drop-off.

**Activation to retention lift**

- Definition: difference in retention between activated and non-activated accounts. Tracks whether the metric still predicts.

```text
retention_lift = retention_rate(activated) - retention_rate(not_activated)   -- same cohort, same horizon
```

**Trial to paid conversion by activation status**

```text
trial_to_paid(activated)     = paid_accounts_activated / trial_accounts_activated
trial_to_paid(not_activated) = paid_accounts_not_activated / trial_accounts_not_activated
```

**Onboarding churn rate**

- Definition: share of new paying accounts that churn before reaching activation or within the first 90 days.

```text
onboarding_churn = accounts_churned_within_90_days / new_paying_accounts_in_cohort
```

**Milestone on-time rate (sales-led)**

```text
milestone_on_time_rate = milestones_achieved_by_planned_date / milestones_due
```

Typical ranges for activation and TTV vary so much by product category and price point that published benchmarks are rarely useful. Calibrate to your own history and improve against your baseline.

## Implementation guide

### Instrumentation required

Every event carries `account_id`, `user_id`, `timestamp`, and plan or segment context. Define them in the tracking plan (see [09-data-and-instrumentation.md](09-data-and-instrumentation.md)).

| Event | Key properties |
|-------|----------------|
| `account_created` | source, plan, signup_answers |
| `user_invited` / `user_joined` | inviter_id, role |
| `onboarding_step_completed` | step_key, step_index |
| `template_used` / `sample_data_loaded` | template_id |
| `integration_connected` | integration_type |
| `data_imported` | row_count, source |
| `core_action_performed` | action_type (the value-producing action) |
| `first_value_reached` | milestone_key (emit once per account) |
| `account_activated` | activation_definition_version |
| `checklist_dismissed` | step_index |
| `lifecycle_email_sent` / `opened` / `clicked` | campaign_key |

Compute `first_value_reached` and `account_activated` server side from source events, and store the definition version so historical rates stay comparable when the definition changes.

### Data model

```sql
create table account_milestones (
  account_id     text not null,
  milestone_key  text not null,
  planned_date   date,
  achieved_at    timestamptz,
  source         text not null check (source in ('event','manual')),
  definition_version int not null default 1,
  primary key (account_id, milestone_key)
);
```

A daily job evaluates each account against the activation rule within its window and writes the result. Expose activation status to the CRM and to customer success tools so humans can act on stalled accounts.

### Product work

- Audit every screen a new account sees for empty states without a clear action.
- Remove or defer fields and steps not needed for first value (billing details during trial, advanced settings, profile completion).
- Ship templates for the top use cases identified from signup answers.
- Add a dismissible checklist linked to first value, not to setup completeness.
- Route high-fit stalled accounts to a human (sales assist or onboarding specialist) using a rule on fit score plus inactivity.

### Experiments

Run onboarding experiments against activation rate as the primary metric and retention at a later horizon as the guardrail. Ensure sample sizes are sufficient before reading results; small cohorts produce noisy rates.

## Anti-patterns

- Activation defined as "completed signup" or "logged in twice".
- Long product tours shown before the user has done anything.
- Asking for credit card, company size, phone, and ten preferences before first value.
- Checklists that measure setup completeness instead of value.
- Time-based email drips that ignore what the user already did.
- Sales-led onboarding that restarts discovery because the handoff lost the customer's goals.
- Reporting a single all-time activation rate instead of cohort trends.
- Changing the activation definition without versioning, breaking historical comparisons.
- Declaring a behavior causal based only on correlation with heavy users.

## Audit checklist

| ID | Check | Evidence to look for | Severity |
|----|-------|---------------------|----------|
| ON-01 | An activation metric is defined in behavioral terms with a time window | Metrics dictionary entry | High |
| ON-02 | Activation metric was validated against retention across cohorts | Analysis notebook or report comparing retention by activation status | High |
| ON-03 | Activation rate is reported per signup cohort and segment | Dashboard with cohort breakdown | Medium |
| ON-04 | Time to value is measured as a median with the never-reached share | TTV report | Medium |
| ON-05 | Onboarding events are instrumented with account and user ids | Tracking plan; event data sample | High |
| ON-06 | First value and activation are computed server side with a definition version | Job or model code; version column | Medium |
| ON-07 | Empty states offer a primary action and templates or sample data exist | Product walkthrough of a new account | Medium |
| ON-08 | Onboarding checklist leads to first value, not only setup | Checklist step definitions | Medium |
| ON-09 | Lifecycle emails are triggered by behavior and suppressed when irrelevant | Email tool rules | Medium |
| ON-10 | Stalled high-fit accounts are routed to a human | Routing rule, alert, or task automation | Medium |
| ON-11 | Sales-led accounts get a kickoff and a written success plan from handoff data | Success plan template; completion rate | High |
| ON-12 | Implementation milestones have planned and actual dates stored as data | Milestone table or fields | Medium |
| ON-13 | Onboarding churn is measured separately from later churn | Report of early churn by cohort | Medium |
| ON-14 | Signup and trial flow avoid non-essential steps before first value | Signup form and flow review | Low |
| ON-15 | Onboarding experiments use activation as primary metric and retention as guardrail | Experiment log | Low |

## Related

- [01-customer-lifecycle.md](01-customer-lifecycle.md)
- [02-metrics.md](02-metrics.md)
- [06-sales-process.md](06-sales-process.md)
- [08-retention-and-expansion.md](08-retention-and-expansion.md)
- [09-data-and-instrumentation.md](09-data-and-instrumentation.md)
- [12-continuous-improvement.md](12-continuous-improvement.md)
