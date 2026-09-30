# SaaS Revenue Engine

[Português (Brasil)](README.pt-BR.md)

An agent skill that helps SaaS builders implement and audit sales and revenue best practices across the full customer lifecycle.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Validate](https://img.shields.io/github/actions/workflow/status/alissonlinneker/saas-revenue-engine/validate.yml?branch=main&label=validate)](https://github.com/alissonlinneker/saas-revenue-engine/actions/workflows/validate.yml)

## What it does

SaaS Revenue Engine gives your coding agent a working knowledge of how SaaS companies acquire, convert, onboard, retain, and expand customers, plus the metrics, pricing, data, and operations that hold it together. It works in three modes:

| Mode | What you get |
| --- | --- |
| **Advise** | Answers grounded in practice: which metric to track, how to structure a trial, when to add a sales team, how to price a new tier. |
| **Audit** | An end to end review of a whole SaaS project (code, schema, events, billing, docs) against a scored checklist, written to `docs/revenue-audit.md` with evidence and severity for every finding. |
| **Implement** | Builds the missing pieces in your stack: lifecycle stages in the schema, tracking plan and events, metrics queries, dunning, activation flows, expansion triggers. |

Coverage spans acquisition, sales, onboarding and activation, retention and expansion, metrics, pricing and packaging, data instrumentation, revenue operations, growth stages, and continuous improvement.

## What's inside

```text
skills/saas-revenue-engine/
  SKILL.md          entry point, always loaded
  AUDIT.md          protocol to audit a SaaS project end to end
  IMPLEMENT.md      protocol to implement missing capabilities
  references/       loaded on demand
  templates/        metrics dictionary, tracking plan, audit report, SQL
```

### Reference files

| File | Topic |
| --- | --- |
| [01-customer-lifecycle.md](skills/saas-revenue-engine/references/01-customer-lifecycle.md) | Lifecycle stages, stage definitions, conversion and velocity between stages |
| [02-metrics.md](skills/saas-revenue-engine/references/02-metrics.md) | MRR, ARR, churn, retention, NRR, CAC, LTV, payback, and how to compute them |
| [03-pricing-and-packaging.md](skills/saas-revenue-engine/references/03-pricing-and-packaging.md) | Value metrics, tiers, trials, freemium, discounts, price changes |
| [04-go-to-market-motions.md](skills/saas-revenue-engine/references/04-go-to-market-motions.md) | Self-serve, product-led, inside sales, field sales, enterprise, hybrid motions |
| [05-demand-and-acquisition.md](skills/saas-revenue-engine/references/05-demand-and-acquisition.md) | Channels, lead qualification, attribution, acquisition economics |
| [06-sales-process.md](skills/saas-revenue-engine/references/06-sales-process.md) | Pipeline stages, qualification, discovery, forecasting, deal hygiene |
| [07-onboarding-and-activation.md](skills/saas-revenue-engine/references/07-onboarding-and-activation.md) | Activation metrics, time to value, onboarding flows, handoffs |
| [08-retention-and-expansion.md](skills/saas-revenue-engine/references/08-retention-and-expansion.md) | Health scores, churn prevention, dunning, renewals, upsell and cross-sell |
| [09-data-and-instrumentation.md](skills/saas-revenue-engine/references/09-data-and-instrumentation.md) | Event design, tracking plans, identity, data model, warehouse |
| [10-revenue-operations.md](skills/saas-revenue-engine/references/10-revenue-operations.md) | Systems, process ownership, data governance, reporting cadence |
| [11-growth-stages.md](skills/saas-revenue-engine/references/11-growth-stages.md) | What to prioritize from first customers to scale |
| [12-continuous-improvement.md](skills/saas-revenue-engine/references/12-continuous-improvement.md) | Experiments, reviews, feedback loops, operating rhythm |

Also in `references/`: [cheatsheet.md](skills/saas-revenue-engine/references/cheatsheet.md) (one page summary) and [glossary.md](skills/saas-revenue-engine/references/glossary.md) (definitions).

### Templates

| File | Purpose |
| --- | --- |
| [metrics-dictionary.yaml](skills/saas-revenue-engine/templates/metrics-dictionary.yaml) | Canonical metric definitions, formulas, owners, and grain |
| [tracking-plan.yaml](skills/saas-revenue-engine/templates/tracking-plan.yaml) | Lifecycle events, properties, and identity rules |
| [audit-report.md](skills/saas-revenue-engine/templates/audit-report.md) | Structure of the scored audit report |
| [sql/](skills/saas-revenue-engine/templates/sql/) | PostgreSQL reference schema and metric queries |

## Installation

### With the skills CLI

```bash
npx skills add https://github.com/alissonlinneker/saas-revenue-engine --skill saas-revenue-engine
```

### Manual install

Clone the repository, then copy or symlink the skill folder into the location your agent host reads skills from.

```bash
git clone https://github.com/alissonlinneker/saas-revenue-engine.git
cd saas-revenue-engine
```

| Host | User-level location |
| --- | --- |
| Claude Code | `~/.claude/skills/` |
| Codex, Amp, Copilot CLI, OpenCode | `~/.agents/skills/` |

```bash
# Claude Code
mkdir -p ~/.claude/skills
ln -s "$(pwd)/skills/saas-revenue-engine" ~/.claude/skills/saas-revenue-engine

# Codex, Amp, Copilot CLI, OpenCode
mkdir -p ~/.agents/skills
ln -s "$(pwd)/skills/saas-revenue-engine" ~/.agents/skills/saas-revenue-engine
```

Use `cp -R` instead of `ln -s` if you prefer a frozen copy.

### Project-local install

To share the skill with everyone working on a repository, place it inside that repository:

```bash
# pick the folder your host reads
mkdir -p .claude/skills     # or .github/skills
cp -R /path/to/saas-revenue-engine/skills/saas-revenue-engine .claude/skills/
```

## Usage

Ask your agent in plain language. Examples:

```text
Audit this project with saas-revenue-engine.
Implement the top 3 gaps from docs/revenue-audit.md.
Define our activation metric.
Design a tracking plan for our trial to paid funnel.
Write the SQL for net revenue retention by monthly cohort.
We sell to SMBs with a free trial. Should we add a sales-assisted tier?
```

### Sample output

An illustrative excerpt of the scorecard produced by an audit (hypothetical project, round numbers):

```text
Revenue audit scorecard (illustrative)

Area                          Score   High   Medium   Low
Customer lifecycle            2 / 4      2        1     0
Metrics                       2 / 4      1        2     1
Pricing and packaging         3 / 4      0        1     1
Onboarding and activation     1 / 4      3        0     0
Retention and expansion       2 / 4      1        2     0
Data and instrumentation      2 / 4      2        1     1

Top gaps
1. ON-01  No activation event defined; trial conversion cannot be measured.
2. DI-05  Signup and subscription events lack a stable account identifier.
3. RE-08  Failed payments are not retried; no dunning emails.
```

## Design principles

- **Actionable over theoretical.** Every reference includes an audit checklist with evidence to look for and a severity.
- **Measure before optimizing.** Metrics come with formulas, units, grain, and common mistakes.
- **Progressive disclosure.** `SKILL.md` stays small; reference files load only when the task needs them.
- **Stack neutral.** Advice applies to any billing provider, CRM, or analytics tool; SQL targets PostgreSQL as a readable baseline.
- **Honest benchmarks.** Only widely published ranges, framed as starting points to calibrate to your segment.
- **Vendor and methodology neutral.** Built from general, publicly known SaaS practice, not from any single proprietary framework.

## FAQ

**Is it only for B2B?**
No. The lifecycle, metrics, retention, and pricing material apply to B2C and prosumer subscriptions as well. Sections on sales process and account management matter most for B2B, and the skill skips them when they do not fit your motion.

**Does it work with Stripe or other billing providers?**
Yes. Guidance is written against concepts (subscriptions, invoices, payment failures, plan changes) rather than a specific API. When your codebase uses Stripe, Paddle, Chargebee, or a homegrown billing system, the agent maps the recommendations to what it finds.

**What if there is no sales team?**
That is a first-class case. Self-serve and product-led motions are covered in depth, and the audit marks sales-only checks as not applicable instead of failing them. The growth stages reference also explains the signals that suggest when adding sales assistance is worth it.

**Does it change my code without asking?**
The audit mode only reads and writes its report. Implementation happens when you ask for it, one gap at a time, so you can review each change.

## Contributing

Contributions are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) and the [authoring guide](docs/AUTHORING.md) before opening a pull request, and run `python3 scripts/validate.py` locally.

## License

[MIT](LICENSE), copyright 2026 Alisson Linneker.
