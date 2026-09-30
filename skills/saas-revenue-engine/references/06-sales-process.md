# Sales Process

> Scope: how a SaaS company runs a customer-centric, sales-assisted buying process from first conversation to signed contract and handoff. Load when: designing or auditing discovery, qualification, pipeline stages, forecasting, deal approval, CRM fields, or the sales to onboarding handoff.

## Why it matters

A sales process is a repeatable way of helping a buyer make a decision they can defend internally. When it is vague, three things break at once: forecasts miss because stages mean different things to different reps, deals close that the product cannot serve (and churn within a year), and onboarding starts from zero because nothing the customer said during the sale was written down. A documented process with explicit exit criteria turns the pipeline into data you can trust and turns the contract into the first chapter of the customer's success plan instead of the last chapter of the sale.

## Core principles

1. **Sell to an outcome, not a feature list.** Every opportunity records the business outcome the customer expects and how they will measure it. If you cannot write it in one sentence, the deal is not qualified.
2. **Stages are defined by buyer evidence, not seller activity.** "Demo delivered" is an activity. "Economic buyer confirmed budget and timeline" is evidence. Advance stages only on evidence.
3. **Every deal has a reason to act by a date.** Without an external deadline driver (contract expiry, regulatory date, launch, fiscal year, hiring plan), the default outcome is "no decision".
4. **Map the committee early.** B2B purchases involve several people with different concerns. A single enthusiastic contact is not a buying process.
5. **Make the plan mutual.** Write the remaining steps to signature and go-live with the buyer, with owners on both sides and dates. Share it.
6. **Protect price and terms with a deal desk.** Discounts and non-standard terms follow published rules and approval thresholds, not rep negotiation skill.
7. **Treat the CRM as the system of record.** If it is not in the CRM, it did not happen. Required fields are enforced per stage.
8. **Hand off the commitments, not just the account.** Onboarding receives the agreed outcomes, deadlines, stakeholders, and risks captured during the sale.
9. **Pay for revenue that stays.** Compensation includes mechanisms that discourage deals likely to churn.
10. **Learn from every closed deal.** Win and loss reasons feed pricing, product, positioning, and qualification rules on a fixed cadence.

## Model / framework

### Discovery: what to learn

Run discovery as a structured conversation. The seller should talk less than the buyer. Capture answers in CRM fields, not only in call notes.

| Area | Questions to answer | Why it matters |
|------|---------------------|----------------|
| Stakeholders | Who uses, who pays, who approves, who can block | Feeds the buying committee map |
| Problems | What is not working? Who feels it? How often? What do they use today, and what workarounds exist? | Establishes need and gives a baseline for measuring value later |
| Alternatives | What else are they considering, including doing nothing or building in house | Shapes positioning and pricing |
| Success measures | Which numbers should move (revenue, cost, risk, time, quality) and by how much? | Becomes the success criteria in onboarding |
| Timing | Why now? What date or event forces a decision, and what happens if it slips? | Predicts close date and prevents stalls |
| Buying process | Steps to buy: evaluation, security review, legal, procurement, budget cycle | Predicts timeline and hidden blockers |

### Qualification

Qualification decides whether to invest seller time. Use one consistent framework across the team. Public options include BANT (budget, authority, need, timeline; simple, suited to smaller deals) and MEDDICC (metrics, economic buyer, decision criteria, decision process, identify pain, champion, competition; suited to complex enterprise deals). You can also define your own; the requirement is that each criterion has a yes, no, or unknown value in the CRM.

Minimum qualification gate before a deal enters forecastable pipeline:

- [ ] A problem the product demonstrably solves (fits your ideal customer profile)
- [ ] A measurable business outcome stated by the customer
- [ ] A deadline driver or a credible reason to act this quarter or next
- [ ] Access to, or a named path to, the economic buyer
- [ ] Budget exists or a known process to obtain it
- [ ] No disqualifying requirement (missing capability, unsupported region, compliance gap)

Disqualify early and politely. A fast "no" frees capacity and keeps pipeline data honest.

### Buying committee roles

| Role | What they care about | Seller action |
|------|----------------------|---------------|
| Economic buyer | Return on investment, risk, budget fit | Confirm outcome and value in their terms; meet them before proposal |
| Champion | Personal and team win; has influence and will sell internally | Equip with business case, answers, internal slides |
| Coach or ally | Wants you to win but lacks authority | Use for information, do not mistake for champion |
| Technical evaluator | Integration, security, reliability, admin effort | Run focused technical validation |
| End users | Daily usability, workload | Involve in trial or pilot |
| Procurement and legal | Terms, price benchmarks, vendor risk | Engage early with standard paper and security package |
| Blocker | Loses budget, control, or a preferred tool | Identify and address concerns directly or via champion |

Test the champion: a real champion has influence, shares non-public information, and takes actions (schedules meetings with the economic buyer, pushes internal steps). Someone who only likes the product is a fan.

### Mutual action plan

A shared document (spreadsheet, doc, or a feature of your deal room) listing every step from now to go-live.

| Step | Customer owner | Vendor owner | Target date | Status |
|------|----------------|--------------|-------------|--------|
| Technical validation complete | IT lead | Solutions engineer | | |
| Security questionnaire returned | Security | Sales engineer | | |
| Business case reviewed by economic buyer | Champion | Account executive | | |
| Commercial terms agreed | Procurement | Account executive | | |
| Contract signed | Economic buyer | Account executive | | |
| Kickoff held | Project lead | Onboarding lead | | |
| First value milestone reached | Project lead | Onboarding lead | | |

Work backward from the customer's deadline driver. Include go-live, not only signature: it keeps the conversation on outcomes and makes the handoff natural.

### Proposal and pricing approval (deal desk)

A deal desk is the function (a person, a rotation, or a workflow) that approves non-standard pricing and terms.

| Request | Typical approver | Rule to publish |
|---------|------------------|-----------------|
| Discount within rep band (example: up to 10%) | Rep | No approval, reason code required |
| Discount beyond rep band | Sales manager | Requires give-get (longer term, upfront payment, case study, larger volume) |
| Discount beyond manager band | Deal desk or finance | Requires margin check and written justification |
| Non-standard payment terms, caps, custom SLAs | Finance and legal | Standard fallback clauses offered first |
| Custom features or roadmap commitments | Product | Never written into contract without product sign-off |

Rules: every discount has a reason code, discounts are tied to something the company receives in return, and list price stays visible on the order form so renewals do not inherit an unexplained discount forever.

### Proof of concept rules

A proof of concept (POC) or paid pilot is expensive for both sides. Run one only when all are true:

- The customer has agreed in writing to success criteria that are measurable within the POC window.
- The economic buyer has agreed that meeting those criteria leads to a purchase decision, with commercial terms discussed upfront.
- The scope is time-boxed (commonly 2 to 6 weeks) with a named customer owner.
- The data and integrations used are representative of production.

Prefer a paid pilot or a short initial term with an opt-out over a free, open-ended trial for complex deals. Record POC outcome (met, partly met, not met) as a field.

### Stage definitions with exit criteria

Illustrative stage model. Rename stages to fit your motion, but keep exit criteria evidence-based.

| Stage | Exit criteria (buyer evidence) | Typical probability band |
|-------|--------------------------------|--------------------------|
| 1. Discovery | Problem, outcome, and deadline driver captured; fits ICP | Low |
| 2. Qualified | Qualification gate passed; economic buyer identified | Low to medium |
| 3. Solution validation | Technical fit confirmed; POC criteria met if a POC ran | Medium |
| 4. Business case and proposal | Economic buyer reviewed value and pricing; mutual plan agreed | Medium to high |
| 5. Commit and paperwork | Verbal selection; legal and procurement in progress with dates | High |
| Closed won / Closed lost | Signed order form / documented loss reason | Final |

Calibrate probability bands from your own historical stage-to-close conversion, not from defaults in the CRM.

### Forecast categories

Stages describe where a deal is; forecast categories describe the rep's judgment on whether it closes this period.

| Category | Meaning | Rule |
|----------|---------|------|
| Commit | Will close this period; rep stakes credibility | Requires stage 4 or later, mutual plan with signature date inside the period, no open blockers |
| Best case | Could close this period with reasonable effort | Clear path, at least one open risk |
| Pipeline | Real opportunity, not expected this period | Qualified, close date in a future period |
| Omitted | Not counted | Unqualified or stalled |

Track forecast accuracy by rep and by category. Coaching conversations should focus on what evidence moved a deal into commit.

### Pipeline hygiene rules

- **Close date discipline:** a close date is the date the customer expects to sign, backed by the mutual plan. Each push is logged. Deals pushed more than twice move out of commit and get a manager review.
- **Stale deals:** any opportunity with no customer activity in a defined window (example: 30 days) is flagged and must be updated or closed.
- **Stage age limits:** set a maximum days-in-stage per stage based on your historical medians; exceeding it triggers review.
- **No zombie pipeline:** close lost with a reason rather than leave deals open to inflate coverage.

## Metrics

**Pipeline coverage**

- Definition: open qualified pipeline scheduled to close in the period divided by the remaining quota for that period.
- Unit: ratio. Grain: per team and per rep, per period.
- Common mistakes: counting unqualified deals; using a fixed target (such as 3x) without deriving it from your actual win rate.

```text
pipeline_coverage = sum(amount of open qualified opps with close_date in period) / (quota - closed_won_in_period)
required_coverage ≈ 1 / win_rate_by_amount
```

**Win rate**

- Definition: share of opportunities that reached a defined stage (usually Qualified) and closed won.
- Unit: percent, by count and by amount. Grain: per segment, per source, per quarter of creation.
- Common mistakes: including deals closed lost at stage 1 in the denominator in some periods but not others; mixing new business with renewals.

```text
win_rate = closed_won_count / (closed_won_count + closed_lost_count)   -- among opps that reached Qualified
```

**Sales cycle length**

- Definition: median days from Qualified to Closed Won.
- Unit: days. Grain: per segment and deal size band.
- Common mistakes: using the mean (skewed by outliers); measuring from lead creation.

```text
sales_cycle_days = median(closed_won_date - qualified_date)
```

**Average contract value (ACV) and discount rate**

```text
acv = sum(first_year_contract_value) / count(closed_won)
discount_rate = 1 - (net_price / list_price)   -- per deal, then averaged by amount
```

Grain: per deal, aggregated per segment. Pitfall: multi-year deals inflating ACV if total contract value is used.

**Forecast accuracy**

```text
forecast_accuracy = 1 - abs(actual_closed - forecast_commit) / forecast_commit
```

Same definition as [10-revenue-operations.md](10-revenue-operations.md) (error divided by forecast). Grain: per rep, per team, per period. Measure the snapshot taken at a fixed point (example: week 2 of the quarter).

**Stage conversion and stage velocity**

```text
stage_conversion(n) = opps_exiting_stage_n_forward / opps_entering_stage_n
stage_velocity(n)   = median(days_in_stage_n)
```

**First-year churn of new deals (sales quality)**

- Definition: share of new customers, by closing rep or segment, that churn or fail to renew within 12 to 15 months.
- Use it to adjust qualification rules and compensation.

## Implementation guide

### CRM required fields by stage

| Stage entered | Required fields |
|---------------|-----------------|
| Discovery | Account, primary contact, source, segment, problem summary, current solution |
| Qualified | Business outcome (text), success metric and target, deadline driver and date, economic buyer contact, qualification criteria values, estimated amount |
| Solution validation | Technical evaluator, competitors, POC flag and criteria (if any) |
| Business case and proposal | Mutual plan link, champion contact, proposed price, discount and reason code, decision process steps |
| Commit and paperwork | Expected signature date, legal and security status, procurement contact |
| Closed won | Signed amount, term, start date, products, handoff record complete |
| Closed lost | Primary loss reason (picklist), secondary reason, competitor won (if any), notes |

Enforce with validation rules that block stage changes when fields are empty. Keep picklists short (8 to 12 loss reasons) so they are analyzable.

### Data model essentials

```sql
-- Minimal opportunity history for stage analytics
create table opportunity_stage_history (
  opportunity_id  text not null,
  stage           text not null,
  entered_at      timestamptz not null,
  exited_at       timestamptz,
  amount_at_entry numeric(14,2),
  close_date_at_entry date
);
```

Capture every stage change and close date change as history rows. Without history you cannot compute stage velocity, push counts, or forecast accuracy.

### Win and loss analysis

- Record reasons at close for every deal above a size threshold.
- Interview a sample of won and lost buyers each quarter (someone other than the rep runs the interview).
- Review quarterly: top loss reasons by segment, competitor win rates, loss stage distribution, discount levels on wins versus losses.
- Route findings to owners: product gaps to product, pricing objections to pricing, qualification misses to sales leadership.

### Handoff to onboarding

Create the handoff record automatically on Closed Won and require it before the deal is booked.

| Field | Source |
|-------|--------|
| Business outcomes and success metrics with targets | Discovery fields |
| Customer deadline driver and go-live date | Mutual plan |
| Stakeholders and roles (economic buyer, champion, project lead, admins) | Committee map |
| Scope sold: products, seats, integrations, services | Order form |
| Commitments made during the sale (including verbal) | Rep attestation |
| Known risks: technical gaps, political risks, competitor still present | Rep and sales engineer |

Hold a short internal handoff meeting (seller, onboarding lead, customer success) and then a customer-facing kickoff where the seller introduces the onboarding team and restates the agreed outcomes. See [07-onboarding-and-activation.md](07-onboarding-and-activation.md).

### Compensation alignment

- Pay commission on collected or booked revenue with clawbacks if the customer churns or defaults within a defined window (example: first 3 to 6 months).
- Weight or cap commission on multi-year prepaid discounts so reps do not trade price for term blindly.
- Include a component tied to first-year retention or activation of new customers for roles that own the full customer relationship.
- Do not pay full commission on deals that bypass qualification or deal desk rules.
- Review plans annually against observed behavior: if reps push deals that churn, the plan is rewarding it.

## Anti-patterns

- Stages named after seller activities ("demo done", "proposal sent") with no buyer evidence required.
- Close dates set to the end of the quarter by default.
- Single-threaded deals where the only contact is a user-level fan.
- Free, unscoped POCs that never convert and consume sales engineering time.
- Discounts granted without a give-get, then carried into every renewal.
- Loss reason "price" used for most losses, hiding real causes (no urgency, wrong fit, lost to status quo).
- Handoff by forwarding an email thread; onboarding re-asks the customer everything.
- Compensation that pays the same for a deal that churns in 6 months as for one that expands.
- Coverage targets copied from blog posts rather than derived from your own win rate.

## Audit checklist

| ID | Check | Evidence to look for | Severity |
|----|-------|---------------------|----------|
| SP-01 | Stages have written, evidence-based exit criteria | Sales playbook or CRM stage descriptions | High |
| SP-02 | Discovery records stakeholders, problem, success measures, timing and buying process | Required CRM fields and populated values on recent deals | High |
| SP-03 | One qualification framework is used consistently | Qualification fields present and filled on most open opps | Medium |
| SP-04 | Buying committee is mapped for deals above a size threshold | Contact roles on opportunities; more than one contact per deal | Medium |
| SP-05 | Mutual action plans exist for late-stage deals | Plan links on stage 4+ opportunities | Medium |
| SP-06 | Discount approval thresholds and reason codes are defined and enforced | Deal desk policy; approval records; reason code field | High |
| SP-07 | POCs require written success criteria and a time box | POC fields, templates, POC outcome data | Medium |
| SP-08 | Forecast categories are defined separately from stages | CRM forecast category field and rules | Medium |
| SP-09 | Stage and close date history is recorded | History tables or field tracking enabled | High |
| SP-10 | Close date pushes and stale deals are tracked and reviewed | Push count report; stale deal report | Medium |
| SP-11 | Pipeline coverage target is derived from actual win rate | Coverage calculation and win rate report | Medium |
| SP-12 | Required fields are enforced per stage by validation rules | CRM validation rule configuration | High |
| SP-13 | Win and loss reasons are captured and reviewed on a cadence | Loss reason picklist; quarterly review notes | Medium |
| SP-14 | Handoff record carries outcomes, deadlines, stakeholders, commitments, risks | Handoff object or template; completion rate on closed won | High |
| SP-15 | Compensation includes clawback or retention component | Comp plan documents | Medium |
| SP-16 | First-year churn of new deals is reported by rep or segment | Cohort retention report tied to closing owner | Medium |
| SP-17 | Forecast accuracy is measured per period | Forecast snapshots vs actuals | Low |

## Related

- [01-customer-lifecycle.md](01-customer-lifecycle.md)
- [02-metrics.md](02-metrics.md)
- [03-pricing-and-packaging.md](03-pricing-and-packaging.md)
- [04-go-to-market-motions.md](04-go-to-market-motions.md)
- [07-onboarding-and-activation.md](07-onboarding-and-activation.md)
- [08-retention-and-expansion.md](08-retention-and-expansion.md)
- [10-revenue-operations.md](10-revenue-operations.md)
