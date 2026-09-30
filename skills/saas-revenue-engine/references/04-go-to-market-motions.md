# Go-to-Market Motions

> Scope: how a SaaS company reaches, sells to, and serves customers (self-serve, product-led sales, inside sales, field sales, enterprise, partners), how to choose and combine motions, and how to keep cost to serve aligned with customer value. Load when: deciding how to sell, adding a sales team or a new segment, designing handoffs between self-serve and sales, or auditing unit economics by segment.

## Why it matters

The motion determines cost of acquisition, sales cycle length, the team you hire, and the systems you build. A motion that costs more to run than the customer is worth destroys margin no matter how good the product is; a motion that is too light for a complex purchase leaves large deals unwon. Most growth stalls that look like "demand problems" are motion mismatches: enterprise buyers sent to a credit card form, or small accounts consuming account executive time.

## Core principles

1. **Match cost to serve to customer value.** Human touch is expensive; spend it where contract value and expansion potential justify it.
2. **Choose motion by contract value and deal volume, then validate with data.** Buyer complexity (number of stakeholders, security review, procurement) is the tiebreaker.
3. **Segment every metric by motion.** Blended numbers hide one motion subsidizing another.
4. **Define explicit handoff rules between motions.** Every lead and account has exactly one owner and one path at any moment.
5. **Master one motion before adding the next.** A new motion is a new business with its own hiring, tooling, and learning curve.
6. **Let the product carry as much of the load as it can.** Even sales-led companies benefit from self-serve evaluation, onboarding, and expansion paths.
7. **Align marketing and customer success models to the motion,** not to a generic org chart.
8. **Revisit the motion mix as the company moves upmarket or downmarket.** What worked at one stage often breaks at the next.

## Model / framework

### Motion definitions

| Motion | How customers buy | Typical team | Typical cycle |
|---|---|---|---|
| Self-serve / product-led | Sign up, activate, and pay without talking to anyone | Product, growth, lifecycle marketing, support | Minutes to days |
| Product-led sales | Self-serve start; sales engages accounts with strong usage or fit signals | Growth plus a small team of product specialists or account executives | Days to weeks |
| Inside sales | Remote sales team runs demos and closes over video and email | Sales development, account executives, solutions support | Weeks to a few months |
| Field sales | Account executives with solution engineers, often in person, multi-stakeholder | Account executives, solution engineers, sales managers | Months |
| Enterprise / strategic accounts | Large, complex deals with procurement, legal, security, custom terms | Dedicated account teams, executive sponsors, deal desk | Several months to a year or more |
| Partner / channel | Resellers, integrators, marketplaces, or referral partners sell or influence | Partner managers, partner marketing, enablement | Varies by partner type |

### Choosing by contract value and deal volume

Typical ranges, calibrate to your segment and region.

| Annual contract value (illustrative bands) | Feasible volume | Default motion |
|---|---|---|
| Under about 1,000 to 2,000 per year | Very high | Self-serve only; human touch only for support |
| About 2,000 to 15,000 per year | High | Self-serve plus product-led sales or light inside sales |
| About 15,000 to 75,000 per year | Medium | Inside sales, possibly with solution support |
| About 75,000 to 250,000 per year | Low to medium | Field sales with solution engineers |
| Above about 250,000 per year | Low | Enterprise / strategic account teams |

Adjust for buying complexity:

| Factor | Pushes toward a heavier motion |
|---|---|
| Many stakeholders or a buying committee | Yes |
| Security, legal, or compliance review required | Yes |
| Implementation or data migration needed | Yes |
| Product replaces an entrenched system | Yes |
| Buyer is also the user and can try it alone | No, pushes lighter |
| Clear self-explanatory value in the first session | No, pushes lighter |

Decision tree:

```text
Can a single user reach value without help within the trial window?
  no  -> sales-assisted (inside or field) with guided evaluation
  yes -> Is expected ACV below the cost of one sales cycle?
           yes -> self-serve only
           no  -> self-serve start + product-led sales on qualified accounts
Does the deal need procurement, security review, or custom terms?
  yes -> add enterprise path with deal desk and legal support
```

### Cost to serve must match customer value

Rough checks per motion:

```text
cost_of_sales_cycle = (loaded_cost_per_rep_hour * hours_per_deal) / win_rate
fully_loaded_CAC    = (sales_cost + marketing_cost + tooling) / new_customers
payback_months      = CAC / (new_MRR_per_customer * gross_margin)
LTV_to_CAC          = (ARPA * gross_margin * min(1 / monthly_gross_revenue_churn, horizon_months)) / CAC
```

If a motion's payback is far longer than its customers' typical lifetime, either raise price, lower touch, or change the segment. A frequently cited healthy range is payback under roughly 12 to 24 months and LTV to CAC around 3 or higher, with self-serve generally expected at the faster end; calibrate to your segment and capital position.

### Hybrid motions and handoff rules

Most companies above early stage run at least two motions. The failure point is the seam between them.

| Handoff | Trigger (define precisely) | Owner after handoff | Service level |
|---|---|---|---|
| Self-serve to product-led sales | Product-qualified lead: fit criteria met plus usage signal (for example several active users from one domain, limit reached, pricing page visited repeatedly) | Assigned rep | Contact within one business day |
| Marketing to sales development | Marketing-qualified lead passes fit plus intent score | Sales development rep | Minutes to hours for inbound demo requests |
| Sales development to account executive | Qualified meeting held and accepted | Account executive | Accept or reject within one to two business days |
| Inside to field or enterprise | Deal exceeds ACV threshold or requires procurement | Field or enterprise team | Transfer with notes, joint call |
| Sales to onboarding / customer success | Contract signed | Onboarding owner | Kickoff within days |
| Customer success to account management | Expansion opportunity qualified | Account manager | Per team SLA |

Handoff rules:

- Write each trigger as a query that can run on your data, not a judgment call.
- A self-serve customer contacted by sales must not lose self-serve abilities (they can still upgrade online).
- Define rules of engagement for existing self-serve accounts: which ones sales may contact, and how credit is assigned when a self-serve account upgrades after contact.
- Transfer context, not just the record: usage summary, stated goals, stakeholders, open questions.
- Rejected handoffs return to the prior owner with a reason code, so criteria can be tuned.

### Segmenting metrics by motion

Report these per motion (and per segment within the motion):

| Metric | Why segment |
|---|---|
| New MRR / ARR | Shows which motion actually grows the business |
| CAC and payback | Motions differ by an order of magnitude |
| Win rate and cycle length | Blended values are meaningless across motions |
| Gross and net revenue retention | Enterprise and self-serve retain differently |
| Support and success cost per account | Reveals over-served segments |
| Discount rate | Tends to rise with sales touch |

Store `motion` and `segment` on the account and on each opportunity at creation, and keep the historical value when it changes, so reports reflect how the customer was acquired.

### When to add a new motion

Add a motion when:

- A clear, repeated signal exists (many self-serve accounts from large companies stalling at security or procurement; inbound requests for invoices and contracts; large prospects asking for demos).
- The current motion is repeatable: predictable conversion, known CAC, retention within target.
- You can fund it long enough to learn, typically several sales cycles.

Start small: one or two experienced people, a narrow segment, explicit success criteria and a time box, and separate reporting.

Risks of too many motions:

| Risk | Symptom |
|---|---|
| Channel conflict | Reps and partners compete for the same account; self-serve customers get pushed into contracts |
| Product fragmentation | Roadmap split between enterprise asks and self-serve simplicity |
| Diluted focus | Every motion mediocre, none repeatable |
| Metric confusion | Blended CAC and win rate hide failures |
| Tooling sprawl | Multiple CRMs, duplicate records, broken routing |

### Marketing and customer success models by motion

| Motion | Marketing model | Customer success model |
|---|---|---|
| Self-serve | Content, SEO, paid acquisition, lifecycle email, in-product messaging, community | Pooled, digital-first: help center, in-app guides, automated health alerts, support queue |
| Product-led sales | Same as self-serve plus usage-based signals feeding sales | Digital-first with pooled success managers for accounts above a threshold |
| Inside sales | Demand generation for demos, webinars, targeted paid, sales development outreach | Pooled or named success managers with a large portfolio |
| Field sales | Account-based marketing on target lists, events, analyst and peer references | Named success manager, onboarding project, business reviews |
| Enterprise | Account-based marketing, executive programs, events, references | Dedicated account team, success plans, executive sponsor, often paid premium support |
| Partner / channel | Co-marketing, partner enablement content, marketplace listings | Shared model; define who owns support and renewal per partner type |

Partner types to distinguish: referral (partner introduces, you sell), reseller (partner sells and often bills), implementation or services (partner delivers setup), technology or integration (joint value, co-marketing), marketplace (cloud or platform marketplaces handle procurement). Each has different margin, control, and data-sharing implications.

## Metrics

**Cost to serve per account**

```text
cost_to_serve = (support_cost + success_cost + account_mgmt_cost + infra_cost) / active_accounts
```

Unit: currency per account per period. Grain: per motion, per segment, per month or quarter. Pitfall: excluding shared staff time or infrastructure, which makes small accounts look profitable.

**CAC by motion**

```text
CAC_motion = (sales_cost_motion + marketing_cost_motion + tooling_motion) / new_customers_motion
```

Unit: currency per new customer. Grain: per quarter per motion. Pitfall: allocating all marketing to sales-led and treating self-serve as free.

**CAC payback by motion**

```text
payback_months = CAC_motion / (avg_new_MRR_motion * gross_margin)
```

Unit: months. Grain: per quarter per motion. Pitfall: using revenue instead of gross margin.

**Product-qualified lead conversion**

```text
PQL_to_paid = PQLs_converted_to_paid_within_window / PQLs_created
```

Unit: percent. Grain: per PQL cohort month. Pitfall: counting accounts that would have converted anyway; compare against a holdout where possible.

**Handoff acceptance rate**

```text
acceptance_rate = handoffs_accepted / handoffs_sent
```

Unit: percent. Grain: per handoff type per month. Pitfall: reps silently ignoring handoffs instead of rejecting them with a reason.

**Motion revenue mix**

```text
mix(m) = new_ARR_motion(m) / total_new_ARR
```

Unit: percent. Grain: per quarter. Pitfall: reclassifying accounts after the fact.

## Implementation guide

- **Data model.** Add `acquisition_motion`, `current_motion`, `segment`, and `owner_id` to the account; add `motion` and `source` to opportunities. Keep a history table for owner and motion changes.
- **Product signals.** Emit events that drive product-led sales: `workspace_created`, `teammate_invited`, `limit_reached`, `pricing_page_viewed`, `integration_connected`, `billing_page_viewed`. Aggregate daily into an account-level usage table.
- **PQL job.** A scheduled job evaluates fit (from enrichment: company size, industry, region) plus usage signals, writes a `pql_at` timestamp and reason, and creates a task or record in the CRM for the assigned owner. Make the rule configurable, not hard-coded.
- **Routing.** One routing service or CRM rule set decides the owner by motion, segment, territory, and existing ownership. Log every routing decision with the rule that fired.
- **Self-serve paths inside sales-led deals.** Keep in-product upgrade, invoices, and seat management available so accounts are not blocked waiting for a rep.
- **Enterprise readiness.** Security documentation, SSO, audit logs, data processing agreement, contract templates, invoice billing, and a deal desk process for non-standard terms.
- **Partner tracking.** Partner id on accounts and opportunities, deal registration with expiry, and attribution rules that avoid double counting.
- **Reporting.** Dashboards filtered by motion by default; blended totals only as a roll-up.

## Anti-patterns

- Hiring enterprise account executives before any repeatable motion exists.
- Sending every signup to sales regardless of fit, which wastes rep time and annoys users.
- Blocking self-serve upgrade so that sales can "own" the deal.
- PQL defined as "any signup" or "any active user", producing noise.
- Blended CAC and win rate reported to leadership.
- Field-level service (named success manager, business reviews) for accounts paying a small monthly fee.
- Launching three new motions in a year while the core one is still unpredictable.
- Partner program with no deal registration, causing channel conflict.
- Motion stored only in someone's head or in a spreadsheet rather than on the account record.

## Audit checklist

| ID | Check | Evidence to look for | Severity |
|---|---|---|---|
| GM-01 | Primary motion is explicitly chosen and documented with rationale (ACV, volume, buyer complexity) | GTM document, decision record | High |
| GM-02 | Cost to serve per account is measured by motion and segment | Query or dashboard | High |
| GM-03 | CAC and payback are reported per motion, not only blended | Finance or RevOps reports | High |
| GM-04 | Motion and segment are stored on accounts and opportunities with history | CRM fields, history table | Medium |
| GM-05 | Handoff triggers are written as data rules with owners and SLAs | Routing config, PQL job, SLA doc | High |
| GM-06 | Rejected handoffs require a reason code | CRM picklist, rejection report | Medium |
| GM-07 | PQL definition combines fit and usage signals and is measured against conversion | PQL job code, PQL cohort report | Medium |
| GM-08 | Self-serve upgrade remains available to accounts in a sales process | Product flow, entitlement logic | Medium |
| GM-09 | Rules of engagement for sales contacting self-serve accounts and crediting upgrades | Written policy, compensation plan | Medium |
| GM-10 | New motions launched with a time box, narrow segment, and success criteria | Launch plan, review notes | Medium |
| GM-11 | Customer success coverage model tiered by account value | CS coverage doc, portfolio sizes | Medium |
| GM-12 | Marketing programs map to the motion they feed | Campaign plan with motion tag | Low |
| GM-13 | Enterprise readiness assets exist if selling above the inside sales band | Security docs, SSO, DPA, contract templates | High |
| GM-14 | Partner program has deal registration and attribution rules | Partner portal or CRM objects | Low |
| GM-15 | Routing decisions are logged with the rule that fired | Routing logs | Low |

## Related

- [01-customer-lifecycle.md](01-customer-lifecycle.md)
- [02-metrics.md](02-metrics.md)
- [03-pricing-and-packaging.md](03-pricing-and-packaging.md)
- [05-demand-and-acquisition.md](05-demand-and-acquisition.md)
- [06-sales-process.md](06-sales-process.md)
- [08-retention-and-expansion.md](08-retention-and-expansion.md)
- [10-revenue-operations.md](10-revenue-operations.md)
- [11-growth-stages.md](11-growth-stages.md)
