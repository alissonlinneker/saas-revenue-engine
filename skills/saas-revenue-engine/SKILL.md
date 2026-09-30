---
name: saas-revenue-engine
description: "Sales and revenue best practices for SaaS products across the full customer lifecycle: acquisition, sales process, onboarding and activation, retention, expansion, pricing, metrics (MRR, ARR, GRR, NRR, LTV, CAC, payback), data instrumentation and revenue operations. Use when designing or reviewing any of these, defining metrics correctly, or auditing a SaaS codebase and its ecosystem to find what is implemented, partial or missing (see AUDIT.md), or implementing the gaps (see IMPLEMENT.md)."
---

# SaaS Revenue Engine

A practitioner toolkit to build, measure and improve how a SaaS business acquires, converts, retains and expands customers. It works at two levels: **advice** (answer questions with the right model, metric and trade-off) and **codebase work** (audit a real project and implement what is missing).

## How to use this skill

| Request | What to do |
|---|---|
| A question about a topic (pricing, churn, activation, pipeline, a metric) | Load the matching reference file from the index below, then answer. |
| "Audit this project", "what is missing in our revenue stack" | Follow [AUDIT.md](AUDIT.md) end to end. |
| "Implement the gaps", "fix the top findings" | Follow [IMPLEMENT.md](IMPLEMENT.md). |
| "Define metric X" or "is our NRR right?" | Load [references/02-metrics.md](references/02-metrics.md) and the SQL in [templates/sql/](templates/sql/). |
| Quick decision or threshold | Load [references/cheatsheet.md](references/cheatsheet.md). |

Rules for every answer:

1. Load the relevant reference before giving a recommendation. Do not answer from general memory when a reference covers the topic.
2. State assumptions about the business (revenue model, segment, contract value, sales motion, stage) before recommending. Advice that fits a self-serve product at 20 USD per month is often wrong for an enterprise contract, and the reverse.
3. Every metric you mention needs a definition, a formula and a grain. Ambiguous metrics cause more damage than missing ones.
4. Benchmarks are typical public ranges, never targets. Compare a business with its own trend first, then with peers in the same segment.

---

## Core principles

**1. Recurring revenue is earned after the sale.** In a subscription business most lifetime value arrives after the first invoice. A customer who never reaches the outcome they bought will churn, whatever the sales team promised. Design the business around delivering and proving customer outcomes, not around closing deals.

**2. Model the whole lifecycle, not only the funnel.** A classic funnel stops at "closed won", which is where recurring revenue starts. Model every stage from first touch to renewal and expansion, with explicit entry and exit criteria, an owner, a system of record and a timestamped transition event. See [01-customer-lifecycle.md](references/01-customer-lifecycle.md).

**3. One definition per metric, measured in one place.** Win rate, churn and NRR mean nothing until the numerator, denominator, grain and time window are fixed and shared by marketing, sales, success and finance. Keep a metric dictionary under change control. See [02-metrics.md](references/02-metrics.md) and [10-revenue-operations.md](references/10-revenue-operations.md).

**4. Growth has three sources that behave differently.** New customers add revenue once; retention preserves the base; expansion compounds it. As the base grows, percentage growth naturally slows, and retention plus expansion become the main growth engine. A business that keeps investing only in acquisition as it scales becomes inefficient. See [11-growth-stages.md](references/11-growth-stages.md).

**5. Conversions multiply, retention compounds.** Acquisition output is the product of several stage conversion rates, so small simultaneous gains (or losses) across stages have an outsized effect. Retained revenue accumulates year over year through net retention. Before buying more volume, check whether a leaking stage downstream would waste it. See [12-continuous-improvement.md](references/12-continuous-improvement.md).

**6. Match the cost to serve with the value of the customer.** Self-serve, product-led, inside sales, field sales and strategic account motions have very different costs. Choose the motion from contract value and deal volume, measure every metric per motion, and add motions deliberately. See [04-go-to-market-motions.md](references/04-go-to-market-motions.md).

**7. Pricing is a product decision with data consequences.** The value metric, packaging, billing terms and discount policy shape conversion, retention and expansion. Keep the plan catalog and entitlements as data, not as scattered conditionals. See [03-pricing-and-packaging.md](references/03-pricing-and-packaging.md).

**8. Qualify on the customer's problem and urgency, not on your product.** Discovery records who is involved and how they buy, the problem worth solving, what success looks like in their numbers, the alternatives they weigh and why they need to act now. That same record drives onboarding, success planning and renewal. See [05-demand-and-acquisition.md](references/05-demand-and-acquisition.md) and [06-sales-process.md](references/06-sales-process.md).

**9. Time to value is the most important onboarding metric.** Define activation as a behavior that predicts retention, measure it per cohort and shorten the time to reach it. See [07-onboarding-and-activation.md](references/07-onboarding-and-activation.md).

**10. Gross retention measures quality; net retention measures growth.** Track both per cohort. Expansion can hide a leaking base, so never report NRR without GRR. Recover failed payments before you call it churn. See [08-retention-and-expansion.md](references/08-retention-and-expansion.md).

**11. Instrument before you optimize.** Server-side lifecycle events, idempotent billing webhooks, resolved identities across product, billing and CRM, and a transitions table make every other practice measurable. See [09-data-and-instrumentation.md](references/09-data-and-instrumentation.md).

**12. Improve in short cycles on a few stages.** Find the constraint stage, form a testable hypothesis, run short plan-do-check-act cycles, write down what was learned and change the system (definitions, tooling, playbooks) when a result repeats. See [12-continuous-improvement.md](references/12-continuous-improvement.md).

---

## Reference index

| File | Covers | Audit prefix |
|---|---|---|
| [01-customer-lifecycle.md](references/01-customer-lifecycle.md) | Lifecycle stages, transitions, velocity, stage conversion | LC |
| [02-metrics.md](references/02-metrics.md) | MRR movements, ARR, GRR, NRR, LTV, CAC, payback, efficiency ratios, anti-manipulation | MT |
| [03-pricing-and-packaging.md](references/03-pricing-and-packaging.md) | Monetization models, value metric, packaging, discounts, billing implementation | PR |
| [04-go-to-market-motions.md](references/04-go-to-market-motions.md) | Self-serve, product-led sales, inside, field, enterprise, partners, cost to serve | GM |
| [05-demand-and-acquisition.md](references/05-demand-and-acquisition.md) | ICP, channels, lead scoring, speed to lead, qualification, attribution, consent | AQ |
| [06-sales-process.md](references/06-sales-process.md) | Discovery, buying committee, mutual action plans, forecasting, handoff | SP |
| [07-onboarding-and-activation.md](references/07-onboarding-and-activation.md) | Time to value, activation metric, onboarding flows | ON |
| [08-retention-and-expansion.md](references/08-retention-and-expansion.md) | Churn taxonomy, health scores, dunning, renewals, expansion | RE |
| [09-data-and-instrumentation.md](references/09-data-and-instrumentation.md) | Systems of record, identity, event taxonomy, webhooks, data quality | DI |
| [10-revenue-operations.md](references/10-revenue-operations.md) | Metric governance, dashboards, forecasting, capacity, cadence | RO |
| [11-growth-stages.md](references/11-growth-stages.md) | What to build and measure at each stage, growth rate math | GS |
| [12-continuous-improvement.md](references/12-continuous-improvement.md) | Bottlenecks, compounding gains, experiments, improvement cycles | CI |
| [cheatsheet.md](references/cheatsheet.md) | Decision rules, formulas, thresholds, warning signs | |
| [glossary.md](references/glossary.md) | Terms and definitions | |

## Templates

| File | Use |
|---|---|
| [templates/metrics-dictionary.yaml](templates/metrics-dictionary.yaml) | Starting point for a shared metric dictionary |
| [templates/tracking-plan.yaml](templates/tracking-plan.yaml) | Example event tracking plan for a B2B SaaS |
| [templates/sql/](templates/sql/) | PostgreSQL schema and reference queries (MRR bridge, cohorts, GRR and NRR, funnel, LTV and CAC) |
| [templates/audit-report.md](templates/audit-report.md) | Output template for AUDIT.md |

## Scope and limits

This skill covers commercial practice for subscription and usage-based software businesses, B2B first, with notes for B2C and product-led models. It does not replace legal, tax or accounting advice: revenue recognition, tax on digital services and privacy law vary by country. Benchmarks change with market conditions; treat them as orientation.
