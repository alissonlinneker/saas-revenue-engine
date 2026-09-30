# Implementation Protocol

> Scope: turn revenue audit findings into shipped, tested, and verified capabilities in the owner's repository. Load when: an audit report exists (see `AUDIT.md`) and the owner wants gaps fixed.

All paths in this file are relative to the skill directory. Paths in the target project are relative to its root.

## Operating rules

1. **No audit, no implementation.** Start from a report produced with `AUDIT.md` (default location `docs/revenue-audit.md` in the target project). If none exists, run the audit first, or at least Phases 0 and 1 plus the dimensions in scope.
2. **The owner confirms scope.** Present the chosen gaps and the slice plan, then wait for explicit approval before editing code.
3. **Follow the target repository, not this skill.** Match its language, framework, folder layout, naming, migration tool, test framework, lint rules, commit conventions, and contribution guide. Read `CONTRIBUTING*`, `AGENTS.md`, `CLAUDE.md`, or equivalent before the first edit.
4. **Small vertical slices.** Each slice delivers one observable capability end to end (data, logic, event, surface) and can be merged alone. Avoid horizontal layers such as "all migrations first".
5. **Tests ship with the code.** No slice is done without automated tests that fail before the change and pass after it.
6. **Verify numbers against data.** Any slice that produces or changes a metric is verified with SQL checks adapted from `templates/sql/`.
7. **Money paths are high risk.** Changes to billing, webhooks, entitlements, or invoicing need idempotency, test mode verification with the billing provider, and a rollback plan. Never run migrations or backfills against production without the owner's explicit go.
8. **No secrets in code or commits.** Read keys from the environment or the project's secret manager, and add new variables to the example env file with placeholder values.
9. **Load the reference first.** Before designing a slice, load the reference file for its dimension (the same mapping as in `AUDIT.md`).

## Step 1: Select gaps

From the report's prioritized roadmap, take the "Now" items. Order them with the implementation sequence below; a gap that depends on an unbuilt foundation moves behind it.

For each selected gap, write one line: finding ID, audit check ID (for example `MT-03`), expected outcome, and the metric that will prove it.

## Step 2: Confirm with the owner

Present:

| Gap | Check ID | Proposed slice | Effort (S/M/L) | Risk | Depends on |
|---|---|---|---|---|---|

Ask the open questions from the report that affect these slices (for example the definition of an active account, or whether annual plans exist). Record answers in the report under "Open questions" as resolved.

## Step 3: Plan slices

For each slice, fill this plan before coding:

```yaml
slice: <short name>
closes: [<check IDs>]
reference: references/<NN-file>.md
hypothesis: "<what changes and how it will be observed>"
not_changing: "<explicit out of scope>"
layers:
  schema: "<tables, columns, indexes, migration name>"
  events: "<event names and properties, added to the tracking plan>"
  jobs: "<scheduled or webhook-driven processing>"
  ui: "<screens, emails, admin views>"
  dashboards: "<queries or panels>"
tests: "<unit, integration, webhook fixture, SQL assertion>"
verification_sql: "templates/sql/<file> adapted to <table names>"
rollback: "<how to revert safely>"
```

Skip layers that the slice does not need; do not add layers to look complete.

## Recommended implementation order

Build foundations first. Later layers read from earlier ones, so errors upstream corrupt everything downstream.

| Order | Area | Typical slices | Reference | Check prefixes |
|---|---|---|---|---|
| 1 | Lifecycle data model | account and subscription tables as the system of record, lifecycle stage with history table, single "customer" definition | `references/01-customer-lifecycle.md` | LC |
| 2 | Billing correctness | signed and idempotent webhook handling, subscription state sync, plan and entitlement source of truth, failed payment handling | `references/03-pricing-and-packaging.md`, `references/08-retention-and-expansion.md` | PR, RE |
| 3 | Instrumentation | tracking plan, server-side revenue events, identity and account grouping, attribution capture on signup | `references/09-data-and-instrumentation.md`, `references/05-demand-and-acquisition.md` | DI, AQ |
| 4 | Metrics layer | MRR movements table, retention cohorts, metrics dictionary, one query per metric | `references/02-metrics.md` | MT |
| 5 | Activation and retention | activation event and time to value, behavior-triggered onboarding, cancellation flow with reasons, health score, expansion triggers | `references/07-onboarding-and-activation.md`, `references/08-retention-and-expansion.md` | ON, RE |
| 6 | Sales process tooling | CRM sync of product data, lead routing, deal stages with exit criteria, motion routing | `references/06-sales-process.md`, `references/04-go-to-market-motions.md`, `references/10-revenue-operations.md` | SP, GM, RO |
| 7 | Optimization | experiment log, pricing and onboarding experiments behind flags, review cadence, alerts on metric drift | `references/12-continuous-improvement.md`, `references/11-growth-stages.md` | CI, GS |

Skip rows that the audit marked N/A. A "Now" item from a later row can jump ahead only if it does not read data from an unfinished earlier row.

## Step 4: Implement each slice

1. Create a branch following the repo's convention.
2. Write the failing tests first: unit tests for state transitions and calculations, integration tests for webhooks using recorded or provider-documented fixtures, and SQL assertions for metrics.
3. Implement schema changes with the project's migration tool. Make migrations reversible and backfills idempotent and batched.
4. Implement logic in the layer the repo already uses for domain logic. Reuse existing clients for the billing provider, CRM, and analytics; do not add a second client.
5. Emit events exactly as named in the tracking plan. Add new events to the project's tracking plan (create one from `templates/tracking-plan.yaml` if absent).
6. Add or update metric definitions in the project's metrics dictionary (create one from `templates/metrics-dictionary.yaml` if absent).
7. Run the repo's full test suite, linters, and type checks.

## Step 5: Verify metric correctness

Adapt the relevant queries from `templates/sql/` to the target schema and run them against a development or staging database, or a read replica the owner approves. Check at least:

| Check | Pass condition |
|---|---|
| Reconciliation | Sum of MRR movements for a period equals ending MRR minus starting MRR |
| Source agreement | MRR from internal tables matches the billing provider's active subscriptions within an explained tolerance (currency, tax, discounts) |
| No double counting | One active subscription row per account and product at any point in time, unless multi-subscription is intended |
| Stage integrity | Every account has exactly one current lifecycle stage; transition timestamps are monotonic |
| Event completeness | Every paid conversion in billing has a matching server-side event within the expected delay |
| Edge cases | Trials, annual plans (normalized to monthly), refunds, pauses, reactivations, and currency are handled as defined in the metrics dictionary |

Record queries and results (counts and pass or fail only, no customer data) in the slice's pull request description.

## Step 6: Update the report

In the audit report, update each closed finding: status (Done, In progress, Blocked), link to the commit or pull request, the verification result, and the new dimension score if it changed. Record blockers as blockers; do not mark an item done because code was written.

## Definition of done per slice

- [ ] Owner approved the slice scope.
- [ ] Reference file for the dimension was loaded and its relevant checks now Pass.
- [ ] Code follows the target repo's conventions and passes its lint, type, and test gates.
- [ ] New tests cover the happy path, at least one failure path, and idempotency where money or webhooks are involved.
- [ ] Migrations are reversible; backfills are idempotent and were dry run.
- [ ] Events are in the tracking plan and verified firing with correct properties.
- [ ] Metrics are in the metrics dictionary and pass the Step 5 SQL checks.
- [ ] No secrets committed; new env variables documented with placeholders.
- [ ] Rollback steps are written in the pull request.
- [ ] Audit report updated with status and evidence.
- [ ] An owner is named for any new dashboard, alert, or recurring job.
