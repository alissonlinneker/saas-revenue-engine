# Pricing and Packaging

> Scope: how a SaaS product charges (model, value metric, packaging, discounts, price changes) and how billing is implemented so pricing can evolve safely. Load when: designing or changing prices, plans, trials, discounts, or the billing system, or auditing any of them.

## Why it matters

Price is the single lever that changes revenue without changing volume. A small, well-executed price improvement usually moves revenue more than a comparable improvement in conversion or churn, and a bad pricing structure silently caps expansion, attracts the wrong customers, and forces sales into discounting. Pricing is also an engineering problem: if plans, limits, and prices are hard-coded, every pricing experiment becomes a release, and the company stops experimenting.

## Core principles

1. **Charge on a metric that grows with the value the customer receives.** Revenue should expand automatically as the customer succeeds.
2. **Keep the model explainable in one sentence.** If a buyer cannot estimate their bill, they stall or ask for a custom deal.
3. **Package for distinct segments, not for feature count.** Each tier should be the obvious choice for one type of buyer.
4. **Separate price, plan, and entitlement in the data model.** Prices change often, plans change sometimes, entitlements are checked on every request.
5. **Treat discounts as a governed cost.** Every discount needs a reason, an owner, an expiry, and an approval level.
6. **Change prices deliberately and communicate early.** Grandfathering, notice periods, and migration paths are part of the price change, not an afterthought.
7. **Price in the buyer's currency and include taxes correctly.** Localization is a conversion lever and tax is a legal obligation.
8. **Make billing events idempotent and auditable.** Money flows must reconcile exactly between the product, the billing provider, and accounting.
9. **Review pricing on a schedule** (at least yearly, and after major product changes), using win/loss, usage, and discount data rather than opinion.

## Model / framework

### Monetization models

| Model | How it charges | Fits when | Main risk |
|---|---|---|---|
| Flat rate | One price for the product | Narrow product, homogeneous customers | Leaves money on the table with large customers, no expansion path |
| Per seat | Price times number of users | Value scales with people using it (collaboration, CRM, helpdesk) | Seat compression, password sharing, discourages broad rollout |
| Usage based | Price per unit consumed (API calls, GB, messages, compute) | Consumption varies widely and maps to value (infrastructure, communications) | Unpredictable bills, revenue volatility, harder forecasting |
| Tiered | Fixed packages with limits and features | Clear segments with different needs | Too many tiers, arbitrary gates, cliffs between tiers |
| Hybrid | Platform fee plus seats or usage | Need predictable base revenue and upside with growth | Complexity, harder to explain |
| Outcome based | Share of a measurable result | Result is attributable and measurable | Attribution disputes, slow revenue recognition |

Hybrid (a base platform fee, a tiered package, and a usage or seat component) is the most common mature structure because it balances predictability for both sides with expansion.

### Acquisition models for the entry point

| Model | Mechanics | Use when | Watch |
|---|---|---|---|
| Freemium | Permanent free plan with limits | Large addressable market, low marginal cost, strong network or viral effects | Free users that never convert, support cost, free plan too generous |
| Free trial (opt-in) | Full or paid-tier access for N days, no card | Product value visible within the trial window | Low intent signups, activation must happen inside the window |
| Free trial (card required) | Trial converts automatically unless canceled | Clear value, want high intent | Fewer signups, chargebacks and refund requests if reminders are poor |
| Reverse trial | Starts on paid tier for N days, then drops to free plan | Want users to experience premium features and still keep a free fallback | Users must notice what they lose; needs clear downgrade messaging |
| Demo or pilot | Sales-led evaluation, sometimes paid | High contract value, complex setup | Long cycles, pilots without success criteria |

Decision rule: pick the trial length from time to first value, not convention. If activation takes 3 days, a 30 day trial mostly adds delay. If it needs data integration, a guided pilot beats a self-serve trial.

### Selecting the value metric

A good value metric scores well on all five tests:

| Test | Question |
|---|---|
| Value alignment | Does the customer get more value as this number goes up? |
| Predictability | Can the buyer estimate it before purchase? |
| Measurability | Can the product count it accurately and show it to the customer? |
| Expansion | Does it grow naturally as the account succeeds? |
| Fairness | Would the customer agree the charge is reasonable? |

Process: list 3 to 6 candidate metrics (seats, active users, records, transactions, projects, locations, revenue processed), score each 1 to 5 on the tests, check how usage is distributed across current customers for the top two candidates, and model current revenue under each. Prefer active users over provisioned seats when broad adoption is the goal.

### Packaging

- **Good, better, best.** Three tiers are the common default: an entry tier for small teams or self-serve, a core tier where most revenue lands, and an advanced tier for larger organizations. Design the middle tier as the default choice.
- **Fence tiers by segment needs**, not by crippling core value. Typical fences: limits on the value metric, administrative and security features (SSO, audit logs, roles), support level, integrations, compliance.
- **Enterprise tier** usually has "contact sales" pricing, includes security, procurement, and support commitments, and has a floor price.
- **Add-ons** monetize capabilities that only a minority needs (extra storage, advanced analytics, premium support). Rule: an add-on should be bought by under roughly a third of customers; if most buy it, fold it into a tier.
- **Limit the matrix.** Every tier and add-on combination is a support, billing, and sales training cost.

Smells: most customers on the lowest tier (entry too generous), almost nobody on the top tier (missing large-buyer features), sales custom-builds most deals (packaging does not match segments).

### Billing frequency and prepay

| Option | Benefit to vendor | Benefit to buyer | Common incentive |
|---|---|---|---|
| Monthly | Low friction, more conversions | Flexibility | None |
| Annual paid monthly | Commitment, lower churn | Lower price | Small discount |
| Annual prepaid | Cash up front, lower churn | Largest discount | Typically framed as "2 months free" (about 15 to 20 percent), calibrate to your segment |
| Multi-year | Longer commitment, price lock | Price protection | Price cap on renewal rather than deeper discount |

Offer annual at checkout and again after activation, when perceived value is highest. Model the cash benefit against the discount cost before increasing the annual discount.

### Discount policy and approval matrix

Every non-list price follows a written policy.

| Discount level | Who approves | Required justification |
|---|---|---|
| 0 to 10 percent | Account executive | Standard annual or volume reason |
| 10 to 20 percent | Sales manager | Competitive situation or multi-year |
| 20 to 30 percent | Head of sales plus finance | Strategic account, documented give-get |
| Above 30 percent or non-standard terms | Executive and finance | Written business case |

Rules:

- Illustrative thresholds above; set yours from your margin structure.
- Trade discount for something: longer term, prepayment, volume commitment, case study, faster signature.
- Every discount has an expiry and a defined renewal behavior (does it roll forward or step back to list?).
- Never discount the list price shown publicly for self-serve; use promotions with codes and end dates instead.

### Price changes and grandfathering

| Approach | Description | Use when |
|---|---|---|
| Full grandfathering | Existing customers keep old price indefinitely | Small increase, strong loyalty concerns; creates long-term legacy debt |
| Time-boxed grandfathering | Old price for a fixed period (for example 6 to 12 months), then new price | Default for most increases |
| Migrate at renewal | New price applies at next renewal | Annual contracts |
| Value-add migration | Existing customers move to new plan with added features | Increase is paired with new capability |

Execution checklist: analyze impact per cohort, choose grandfathering rule, give notice (commonly 30 to 90 days, and check contract terms), explain the reason in terms of value, arm support and account managers with answers, monitor churn and downgrades for the affected cohort for at least two renewal cycles.

### Localization and taxes

- Show prices in local currency for major markets; set price points per currency deliberately, not by daily exchange rate.
- Adjust for purchasing power only where the segment justifies it; guard against arbitrage (billing country must match payment method and tax location).
- Decide tax-inclusive (common for consumers in VAT regions) versus tax-exclusive (common for business) display, and be consistent.
- Collect and validate business tax IDs to apply reverse charge where applicable.
- Register and remit sales tax, VAT, or GST where thresholds are exceeded; use a tax engine or the billing provider's tax module rather than hand-rolled rates.
- In Brazil and similar jurisdictions, electronic invoice (nota fiscal) issuance may be mandatory; confirm local requirements with an accountant.

### Pricing page best practices

- Three or four plans visible, the recommended plan highlighted.
- The value metric and its limits stated in plain words.
- Monthly and annual toggle with the saving shown.
- A comparison table grouped by job, not a raw feature dump.
- FAQ covering billing, overages, cancellation, refunds, and data export.
- Clear call to action per plan (start trial, buy, contact sales).
- Enterprise plan with its key differentiators and a "contact sales" path.
- Currency and tax treatment stated.
- Instrument the page: view, toggle, plan click, and checkout start events.

## Metrics

**Average revenue per account (ARPA)**

```text
ARPA = MRR / active paying accounts
```

Unit: currency per month. Grain: per month, segment by plan and motion. Pitfall: mixing free accounts into the denominator, or comparing across currencies without conversion.

**Plan mix**

```text
plan_share(p) = accounts_on_plan(p) / total_paying_accounts
```

Unit: percent. Grain: per month. Pitfall: reading mix without cohort, since older cohorts sit on legacy plans.

**Discount rate**

```text
discount_rate = 1 - (contracted_price / list_price)
```

Unit: percent. Grain: per deal, aggregated per rep, segment, and quarter. Pitfall: excluding free months, extra seats, or waived fees, which are discounts too.

**Realized price**

```text
realized_price = sum(net_billed_revenue) / sum(units_of_value_metric)
```

Unit: currency per unit. Grain: per month per segment. Pitfall: ignoring credits and refunds.

**Trial or free to paid conversion**

```text
conversion = new_paid_accounts_from_cohort / trial_or_free_signups_in_cohort
```

Unit: percent. Grain: per signup cohort (week or month). Pitfall: measuring in calendar period instead of cohort, which mixes trials that have not finished.

**Annual plan share**

```text
annual_share = annual_contract_MRR / total_MRR
```

Unit: percent. Grain: per month. Pitfall: counting annual paid monthly the same as prepaid when analyzing cash.

**Involuntary churn rate**

```text
involuntary_churn = MRR_lost_to_failed_payments / starting_MRR
```

Unit: percent. Grain: per month. Pitfall: counting recovered payments as churn, or not separating it from voluntary churn.

**Dunning recovery rate**

```text
recovery_rate = failed_invoice_amount_recovered / failed_invoice_amount
```

Unit: percent. Grain: per month of failure. Pitfall: short windows that miss late recoveries.

## Implementation guide

### Data model (catalog as data)

```sql
-- Illustrative PostgreSQL schema
CREATE TABLE product (id text PRIMARY KEY, name text NOT NULL);
CREATE TABLE plan (
  id text PRIMARY KEY,               -- e.g. 'team_2026'
  product_id text REFERENCES product(id),
  name text NOT NULL,
  version int NOT NULL,
  is_public boolean NOT NULL DEFAULT true,
  archived_at timestamptz
);
CREATE TABLE price (
  id text PRIMARY KEY,
  plan_id text REFERENCES plan(id),
  currency char(3) NOT NULL,
  interval text NOT NULL CHECK (interval IN ('month','year')),
  unit_amount_minor bigint NOT NULL, -- integer minor units, never floats
  billing_scheme text NOT NULL,      -- flat, per_unit, tiered, volume
  external_price_id text             -- id in billing provider
);
CREATE TABLE feature (key text PRIMARY KEY, type text NOT NULL); -- boolean, limit, metered
CREATE TABLE plan_entitlement (
  plan_id text REFERENCES plan(id),
  feature_key text REFERENCES feature(key),
  value jsonb NOT NULL,              -- true, {"limit": 10}
  PRIMARY KEY (plan_id, feature_key)
);
CREATE TABLE account_entitlement_override (
  account_id uuid NOT NULL,
  feature_key text REFERENCES feature(key),
  value jsonb NOT NULL,
  reason text NOT NULL,
  expires_at timestamptz
);
```

Rules:

- Store money as integer minor units with an explicit currency.
- Version plans; never mutate a plan that has subscribers. Create a new version and migrate.
- Keep the catalog in one source of truth (the billing provider or your database) and sync the other side by id.

### Entitlements separated from plans

- Application code checks `can(account, "sso")` or `limit(account, "projects")`, never `plan == "enterprise"`.
- Resolve entitlements as plan entitlements plus overrides (sales-granted, trial, promotional), cached per account and invalidated on subscription change events.
- Enforce limits with a clear upgrade prompt at the moment of need, and emit an event (`limit_reached`) that sales and growth can act on.
- Metered features write usage records with idempotency keys and report aggregates to the billing provider on a schedule.

### Subscription lifecycle and proration

| Change | Default behavior | Notes |
|---|---|---|
| Upgrade mid-cycle | Immediate access, prorated charge now or on next invoice | Charging now reduces bad debt |
| Downgrade mid-cycle | Effective at period end | Avoids refunds and abuse |
| Seat add | Prorated for remaining period | Consider true-up at renewal for annual |
| Seat remove | Effective at period end | Communicate clearly |
| Cancel | Access until period end, then downgrade to free or lock | Offer pause and downgrade options first |

### Dunning

- Enable card updater services where the provider supports them.
- Retry failed payments on a schedule (smart retries or several attempts over roughly 1 to 3 weeks).
- Email and in-app notices at failure, mid-sequence, and before suspension, with a one-click update payment link.
- Grace period, then read-only or restricted access, then cancellation; never delete data at suspension.
- Send pre-expiry card reminders and pre-renewal notices for annual plans (often legally required for auto-renewal in some regions).

### Invoices and refunds

- Invoices carry legal entity, tax IDs, tax lines, currency, sequential number, line items, and optional PO number; enterprise accounts may need payment terms (net 30) instead of cards.
- Refunds follow a published policy and are issued as credit notes against the original invoice, with a reason code.

### Webhooks and idempotency

```text
on webhook(event):
  verify signature
  if processed_events contains event.id: return 200
  begin transaction
    apply state change keyed by subscription id (upsert, not insert)
    insert event.id into processed_events
  commit
  return 200
```

- Treat the billing provider as the source of truth for payment state and reconcile nightly (subscriptions, invoices, and MRR totals).
- Handle out-of-order events by comparing event timestamps or re-fetching the object.
- Use idempotency keys on every outbound create call (charges, subscriptions, usage records).
- Emit internal events for analytics: `subscription_started`, `subscription_changed`, `subscription_canceled`, `payment_failed`, `payment_recovered`, `invoice_paid`.

## Anti-patterns

- Plan names hard-coded in `if` statements across the codebase.
- Floating point money arithmetic.
- A free plan so generous that the paid plan is only needed by a tiny minority.
- A value metric the customer cannot predict or see in the product.
- Discounts with no expiry, no approval record, and no give-get.
- Silent price increases for existing customers.
- Converting trials to paid without clear reminders, which drives chargebacks.
- Non-idempotent webhook handlers causing double provisioning or credit.
- Deleting customer data when a payment fails.

## Audit checklist

| ID | Check | Evidence to look for | Severity |
|---|---|---|---|
| PR-01 | A value metric is defined and tied to customer value | Pricing doc or page stating the metric; usage data for it | High |
| PR-02 | Plans, prices, and limits are stored as data, not code | Catalog tables or provider catalog; no plan name checks in code | High |
| PR-03 | Entitlements are checked by feature key, separate from plan identity | `can()` or `hasFeature()` style helper; grep for plan name comparisons | High |
| PR-04 | Money stored in integer minor units with currency | Schema column types | High |
| PR-05 | Webhook handlers verify signatures and are idempotent | Processed event table or unique constraint; signature check | High |
| PR-06 | Dunning sequence exists with retries, notices, grace, and restriction | Provider settings, email templates, suspension job | High |
| PR-07 | Nightly reconciliation between product state and billing provider | Scheduled job, reconciliation report | Medium |
| PR-08 | Trial or free model chosen with a documented rationale tied to time to value | Decision record, activation data | Medium |
| PR-09 | Packaging has at most about 3 to 4 public tiers with a clear default | Pricing page, plan mix data | Medium |
| PR-10 | Annual option offered with a modeled incentive | Checkout flow, annual share metric | Medium |
| PR-11 | Written discount policy with approval matrix and expiry | Policy doc, CRM approval fields | High |
| PR-12 | Discount rate reported per rep and segment | Dashboard or query | Medium |
| PR-13 | Price change process includes grandfathering rule and notice | Past change records, customer communications | Medium |
| PR-14 | Plans are versioned; legacy plans tracked | `version` or `archived_at` fields, legacy cohort report | Medium |
| PR-15 | Taxes calculated by an engine and tax IDs collected where needed | Tax configuration, checkout fields | High |
| PR-16 | Local currency pricing for main markets | Price rows per currency | Low |
| PR-17 | Pricing page includes metric, toggle, comparison, FAQ, and instrumentation | Page review, analytics events | Medium |
| PR-18 | Proration and downgrade rules defined and communicated | Provider config, help center article | Medium |
| PR-19 | Refund policy published and implemented as credit notes with reason codes | Policy page, credit note records | Low |
| PR-20 | Involuntary churn and recovery rate tracked separately from voluntary churn | Metrics dashboard | Medium |
| PR-21 | Pricing reviewed at least yearly with data | Review notes, win/loss and discount analysis | Low |

## Related

- [01-customer-lifecycle.md](01-customer-lifecycle.md)
- [02-metrics.md](02-metrics.md)
- [04-go-to-market-motions.md](04-go-to-market-motions.md)
- [07-onboarding-and-activation.md](07-onboarding-and-activation.md)
- [08-retention-and-expansion.md](08-retention-and-expansion.md)
- [09-data-and-instrumentation.md](09-data-and-instrumentation.md)
- [10-revenue-operations.md](10-revenue-operations.md)
