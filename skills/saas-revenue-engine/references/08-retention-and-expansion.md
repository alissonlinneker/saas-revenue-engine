# Retention and Expansion

> Scope: keeping customers, recovering failed payments, managing renewals, and growing revenue from the existing base. Load when: designing or auditing churn measurement, health scores, renewal cadences, customer success coverage, expansion motions, cancellation flows, or dunning.

## Why it matters

Recurring revenue compounds only if it recurs. Each cohort of customers either shrinks (churn and contraction exceed expansion) or grows (expansion exceeds losses). When net revenue retention is above 100%, the existing base grows on its own and new sales add on top; when it is well below, new sales mostly refill a leaking bucket. Retention also drives customer lifetime value, which caps how much you can afford to spend on acquisition. Small, durable improvements in monthly churn produce large differences in revenue a few years out because the effect accumulates every period.

Illustrative only: a base losing 3% of revenue per month keeps roughly 69% after a year; one losing 1% per month keeps roughly 89%. The gap widens each following year.

## Core principles

1. **Measure churn by type.** Voluntary, involuntary (payment failure), and downgrade churn have different causes and different owners. Never report one blended number only.
2. **Report both logo and revenue retention.** Logo retention shows how many customers stay; revenue retention shows how much money stays and grows.
3. **Predict, then act early.** Health scores and warning signals exist to trigger action months before renewal, not to decorate a dashboard.
4. **Validate the health score against actual churn.** An unvalidated score is an opinion.
5. **Recover involuntary churn with systems, not people.** Retries, card updaters, and dunning flows recover revenue customers never meant to lose.
6. **Start renewals early.** For annual contracts, renewal work begins at least 90 to 120 days before the end date.
7. **Review delivered outcomes, not activity.** Business reviews show progress against the outcomes agreed at the sale and in onboarding.
8. **Make expansion ownership explicit.** Decide who sells expansion and who protects the relationship, and pay accordingly.
9. **Detect champion change immediately.** Losing the internal sponsor is one of the strongest churn predictors in B2B.
10. **Let customers cancel cleanly and learn why.** A respectful cancellation flow with reason capture beats hidden cancel buttons, which create chargebacks, complaints, and legal risk.

## Model / framework

### Churn taxonomy

| Type | Definition | Primary owner | Main levers |
|------|-----------|---------------|-------------|
| Voluntary logo churn | Customer decides to cancel or not renew | Customer success, product | Value delivery, health monitoring, save offers |
| Involuntary churn | Subscription ends because payment failed | Billing, finance | Retries, card updater, dunning, payment method options |
| Downgrade (contraction) | Customer stays but pays less: fewer seats, lower tier, removed add-on | Customer success, account management | Adoption, right-sizing, packaging |
| Revenue churn | Total recurring revenue lost from churn plus contraction | Company | All of the above |
| Onboarding churn | Churn before activation | Onboarding | See [07-onboarding-and-activation.md](07-onboarding-and-activation.md) |

Record a reason code on every churn and contraction event. Keep the list short and mutually exclusive, for example: no value realized, missing capability, price or budget, switched to competitor, business closed or acquired, champion left, poor support experience, seasonal or project ended, payment failure.

### Health scoring

A health score summarizes risk per account. Build it in three steps.

**1. Inputs (pick those you can measure reliably)**

| Category | Example inputs |
|----------|---------------|
| Product usage | Active users vs purchased seats, core action frequency, breadth of features used, trend over 30 to 90 days |
| Outcome progress | Success plan milestones achieved, customer-reported metric vs target |
| Relationship | Champion engaged, executive sponsor contact, last meaningful conversation date |
| Support | Ticket volume trend, open high-severity tickets, escalations |
| Commercial | Payment issues, discount level, contract end date proximity, downgrade requests |
| Sentiment | Survey responses, CSM judgment (as one input, not the whole score) |

**2. Weighting.** Start with simple, explainable weights (for example, usage 40, outcomes 25, relationship 20, support 15), score each input on a small scale, and map totals to green, yellow, red. Avoid complex formulas before you have validation data.

**3. Validation.** Every quarter, compare the score each account had 90 to 180 days before its renewal or churn with the actual outcome.

| Score band at T-120 | Accounts | Churned or contracted | Rate |
|---------------------|----------|----------------------|------|
| Green | | | |
| Yellow | | | |
| Red | | | |

A useful score shows clearly higher loss rates in red than green. If the rates are similar, reweight or replace inputs. Also check misses: churned accounts that were green reveal missing signals.

### Early warning signals

| Signal | Detection rule (illustrative) | Default action |
|--------|-------------------------------|----------------|
| Usage drop | Weekly active users down more than a threshold vs 4-week average | CSM outreach within days |
| Seat underuse | Active seats well below purchased seats for 60+ days | Adoption plan before renewal |
| Champion change | Primary contact deactivated, email bounces, job change detected | Re-map stakeholders, meet new owner |
| Admin or owner removed | Account owner role reassigned | Confirm new owner and priorities |
| Support spike or severe ticket | High-severity ticket open longer than SLA | Escalation and follow-up |
| Payment failure | Charge declined | Dunning flow |
| Downgrade or cancellation page visit | Billing page events | Proactive check-in for high-value accounts |
| Data export or integration removal | Export events, disconnected integrations | Risk review |
| No login by sponsor or admin | No activity by key roles for 30+ days | Executive touchpoint |

Every signal creates a task or alert with an owner and a due date, and the outcome of the action is logged.

### Save playbooks

| Risk reason | Playbook |
|------------|----------|
| No value realized | Re-run discovery, reset success plan, targeted training, time-boxed recovery plan with a dated goal |
| Missing capability | Confirm workaround or roadmap timing honestly; escalate to product with revenue at risk |
| Price or budget | Right-size (fewer seats, lower tier), temporary pause, payment terms; avoid deep permanent discounts |
| Champion left | Identify new owner, re-establish outcomes, offer onboarding for the new team |
| Poor support experience | Senior escalation, root cause fix, follow-up review |
| Seasonal usage | Offer pause or seasonal plan instead of cancel |

Track save attempts and results so you know which playbooks work.

### Dunning and payment recovery

Involuntary churn is often a meaningful share of total churn for card-billed, self-serve products, and much of it is recoverable.

- [ ] Smart retries: several retry attempts spread over days, timed around common pay cycles, rather than a single immediate retry.
- [ ] Automatic card updater services from your payment processor enabled.
- [ ] Pre-expiry emails asking customers to update cards before they expire.
- [ ] Dunning email sequence (example: day 0, 3, 7, 14) with a one-click update link that does not require login.
- [ ] In-app banner for admins while payment is failing.
- [ ] Grace period before access is restricted; restrict gradually (read-only before lockout).
- [ ] Alternative payment methods (bank debit, invoice) for larger accounts.
- [ ] Failed payment reasons logged (insufficient funds, expired card, do not honor) to tune retries.

### Renewal management (annual and multi-year contracts)

| Timing | Activities |
|--------|-----------|
| T-120 days | Renewal forecast created; health review; confirm stakeholders and decision process; identify expansion or risk |
| T-90 days | Business review with outcomes delivered; agree renewal scope; raise any price change with notice required by contract |
| T-60 days | Proposal sent; procurement and legal engaged; save playbook active if at risk |
| T-30 days | Paperwork in signature; escalate blockers |
| T-0 | Renewed, or churn recorded with reason |

Rules: store the contract end date, notice period, and auto-renew terms as structured fields. Track renewal forecast categories just like new business. Never let a renewal lapse by accident.

### Customer success coverage models

| Model | Typical fit | Characteristics |
|-------|------------|-----------------|
| Digital or pooled | Low ACV, high volume | Automated lifecycle messaging, community, help center, pooled team responds to signals |
| Assigned portfolio | Mid-market | Named CSM for a book of accounts, periodic check-ins, signal-driven outreach |
| Dedicated | High ACV, strategic | Named CSM for few accounts, regular business reviews, success plans, executive alignment |

Segment by revenue and potential, not by customer request. Define the minimum set of touches per segment and measure whether they happen. Book sizes vary widely by product complexity; calibrate from workload data.

### Expansion types

| Type | Example | Trigger signal |
|------|---------|---------------|
| Seat growth | More users added | Seat utilization near limit, invites blocked |
| Tier upgrade | Move to a higher plan | Hitting plan limits, requesting gated features |
| Add-on | Buy an extra module | Usage pattern that the add-on serves |
| Cross-sell to new team | New department adopts | Users from new email domains or departments; referral from champion |
| Usage growth | Consumption-based billing grows | Usage trend; approaching committed volume |

Build product surfaces for expansion: limits with clear upgrade paths, admin views of usage vs entitlement, and in-product requests that route to the owner.

### Expansion ownership

| Option | When it fits | Watch out for |
|--------|-------------|---------------|
| CSM owns renewal and expansion | Small, frequent expansions; trust-based relationship | CSM becomes a seller and loses advisory role |
| Account manager owns commercial, CSM owns adoption | Larger expansions, mid-market and up | Handoffs between roles; clear rules of engagement |
| New business rep owns cross-sell to new teams | New department is effectively a new sale | Conflicts over account credit |
| Self-serve upgrade | Low ACV, product-led | Ensure no human is paid for self-serve upgrades they did not influence |

Write rules of engagement: who owns which motion, how credit is split, and when to bring in another role.

### Business reviews

Hold them at a cadence set by segment (quarterly for dedicated, semiannually or annually for others). Agenda:

1. Outcomes agreed at sale and onboarding, with current values vs targets.
2. Adoption summary tied to those outcomes (not raw usage totals).
3. Open issues and their resolution.
4. Next period's goals and the plan to reach them.
5. Changes in the customer's business, team, or priorities.

Invite the economic buyer or sponsor, not only day-to-day users.

### NPS and CSAT limits

Survey scores are useful signals, not retention metrics. Limitations: low and biased response rates, individual respondents may not be decision makers, scores lag reality, and a satisfied user can still lose their budget. Use NPS for trend and for the verbatim comments; use CSAT for support interactions. Never substitute them for usage and outcome data in health scores without validation.

### Cancellation flow

- One clear path to cancel, reachable from billing settings. Comply with applicable consumer protection and auto-renewal rules in your markets.
- Ask for a reason (single required choice plus optional text).
- Offer a relevant alternative based on the reason: pause, downgrade, discount for a limited time, help session, export of data.
- Confirm cancellation and effective date by email.
- Keep data for a stated period to make reactivation easy.

### Reactivation

- Segment churned accounts by reason; target those whose reason has since been addressed (feature shipped, price plan added).
- Send win-back messages at intervals (example: 30, 90, 180 days) with specific changes, not generic offers.
- Make reactivation one step: restore previous data and settings.
- Track reactivated accounts as a separate revenue movement.

## Metrics

**Gross revenue retention (GRR)**

- Definition: share of starting recurring revenue retained after churn and contraction, excluding expansion.
- Unit: percent. Grain: per cohort or per period, typically trailing 12 months.

```text
grr = (starting_mrr - churned_mrr - contraction_mrr) / starting_mrr
```

Compute churn, contraction and expansion per account between the cohort start and end snapshots (not by summing monthly movements), so this equals the cohort formula in [02-metrics.md](02-metrics.md): `sum(min(MRR_i(end), MRR_i(start))) / sum(MRR_i(start))`. Reference SQL: [../templates/sql/grr_nrr.sql](../templates/sql/grr_nrr.sql).

**Net revenue retention (NRR)**

```text
nrr = (starting_mrr - churned_mrr - contraction_mrr + expansion_mrr) / starting_mrr
```

Grain: same cohort of accounts that existed at start. Pitfall: including new customers acquired during the period.

**Logo churn rate**

```text
logo_churn_rate = customers_lost_in_period / customers_at_start_of_period
```

Grain: monthly or annual, by segment. Do not count customers acquired in the period in the denominator.

**Involuntary churn rate and recovery rate**

```text
involuntary_churn_rate = mrr_lost_to_payment_failure / starting_mrr
recovery_rate = failed_payment_mrr_recovered / failed_payment_mrr_total
```

**Renewal rate**

```text
renewal_rate = contracts_renewed / contracts_up_for_renewal   -- by count and by amount
```

**Health score predictive accuracy**

```text
loss_rate(band) = accounts_lost_or_contracted(band) / accounts_in_band   -- band measured at T-120
```

**Save rate**

```text
save_rate = accounts_retained_after_save_attempt / accounts_with_save_attempt
```

**Expansion rate**

```text
expansion_rate = expansion_mrr_in_period / starting_mrr
```

Typical ranges, calibrate to your segment: GRR for B2B SaaS is commonly reported in the 80s to low 90s percent, with enterprise-focused companies higher and SMB lower; NRR above 100% is commonly associated with strong mid-market and enterprise products. Use your own trend as the primary reference.

## Implementation guide

### Data model essentials

```sql
create table mrr_movements (
  account_id    text not null,
  movement_date date not null,
  movement_type text not null check (movement_type in
    ('new','expansion','contraction','churn','reactivation')),
  mrr_delta     numeric(14,2) not null,
  reason_code   text,
  churn_type    text check (churn_type in ('voluntary','involuntary') or churn_type is null)
);

create table account_health_snapshots (
  account_id    text not null,
  snapshot_date date not null,
  score         int not null,
  band          text not null check (band in ('green','yellow','red')),
  inputs        jsonb not null,
  model_version int not null,
  primary key (account_id, snapshot_date)
);
```

Snapshot health daily or weekly and keep history; validation requires the score as it was, not as it is now.

### Jobs and integrations

- Daily job computing health scores and writing snapshots; push band to CRM and CS tool.
- Signal detectors (usage drop, champion change, seat underuse) creating tasks with owners.
- Payment processor webhooks for failed, retried, and recovered payments, feeding dunning and `mrr_movements`.
- Renewal task automation at T-120, T-90, T-60, T-30 from contract end dates.
- Contact change detection: bounced emails, deactivated users, role changes in the product.
- Cancellation flow writing reason codes to the movement record.

### Product surfaces

- Usage vs entitlement view for admins.
- Limit notices with upgrade paths.
- Pause option and downgrade path in billing settings.
- Self-serve payment method update without login via secure link.

## Anti-patterns

- A single churn number mixing voluntary, involuntary, and downgrade churn.
- Health score built from opinion and never checked against outcomes.
- Renewal outreach starting 30 days before contract end.
- Business reviews that present usage charts with no link to customer outcomes.
- Hiding the cancel button or requiring a phone call to cancel.
- Deep save discounts that reset the price anchor for every future renewal.
- Treating NPS as the retention metric.
- Payment failure handled by one retry and an immediate lockout.
- Paying CSMs and account managers both full credit for the same expansion without rules.
- Ignoring champion departures until the renewal conversation.

## Audit checklist

| ID | Check | Evidence to look for | Severity |
|----|-------|---------------------|----------|
| RE-01 | Churn is reported by type: voluntary, involuntary, contraction | Revenue movement report with types | High |
| RE-02 | GRR, NRR, and logo churn are calculated with documented formulas | Metrics dictionary; dashboard | High |
| RE-03 | Churn and contraction events carry a reason code | Reason field populated on recent events | Medium |
| RE-04 | Health score exists with documented inputs and weights | Health model spec | Medium |
| RE-05 | Health score is validated against actual churn at least quarterly | Validation report by band | High |
| RE-06 | Early warning signals create owned tasks | Automation rules; task records | Medium |
| RE-07 | Champion change is detected and triggers action | Contact change detection; playbook | Medium |
| RE-08 | Dunning includes smart retries, card updater, emails, grace period | Payment processor settings; email sequence | High |
| RE-09 | Involuntary churn and recovery rate are measured | Report from payment events | Medium |
| RE-10 | Contract end dates, notice periods, auto-renew terms are structured fields | CRM or billing schema | High |
| RE-11 | Renewal cadence starts at T-120 or T-90 for annual contracts | Renewal task automation | High |
| RE-12 | CS coverage model is defined by segment | Coverage policy; book assignments | Medium |
| RE-13 | Expansion ownership and credit rules are written | Rules of engagement document | Medium |
| RE-14 | Product exposes usage vs entitlement and upgrade paths | Product review | Medium |
| RE-15 | Business reviews report outcomes against agreed targets | Review template and recent examples | Medium |
| RE-16 | NPS or CSAT is not used as the sole retention indicator | Health model inputs | Low |
| RE-17 | Cancellation flow is clear, captures reason, offers relevant alternatives | Product walkthrough | Medium |
| RE-18 | Save attempts and outcomes are tracked | Save log and save rate | Low |
| RE-19 | Reactivation campaigns are segmented by churn reason | Campaign setup | Low |

## Related

- [01-customer-lifecycle.md](01-customer-lifecycle.md)
- [02-metrics.md](02-metrics.md)
- [03-pricing-and-packaging.md](03-pricing-and-packaging.md)
- [06-sales-process.md](06-sales-process.md)
- [07-onboarding-and-activation.md](07-onboarding-and-activation.md)
- [09-data-and-instrumentation.md](09-data-and-instrumentation.md)
- [10-revenue-operations.md](10-revenue-operations.md)
