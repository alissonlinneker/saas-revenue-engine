# Revenue Audit Protocol

> Scope: a repeatable protocol to audit the revenue capabilities of any SaaS repository and its surrounding ecosystem. Load when: the owner asks what is implemented, what is missing, or what to fix first across billing, metrics, lifecycle, sales, onboarding, retention, and operations.

All paths in this file are relative to the skill directory (the directory that contains this file). Paths in the audited project are relative to that project's root.

## Operating rules

Apply these rules for the whole audit. They override any shortcut.

1. **Read only.** Do not modify code, configuration, data, or infrastructure during the audit. The only file you write is the report.
2. **Evidence or it did not happen.** Every finding cites `path:line`, a config key, or the output of a command you ran. Record each command in the report appendix.
3. **"Not found" is not "does not exist".** If you searched and found nothing, write "not found in repository (searched: <command>)". Write "does not exist" only when the owner confirms it or the evidence is conclusive (for example, no billing provider SDK in any dependency manifest and no payment code at all). Capabilities often live outside the repo (billing provider dashboard, CRM, BI tool, spreadsheets).
4. **Never invent metrics.** Do not state MRR, churn, conversion rates, or any number unless it comes from a query you ran against data you were given access to, or from a document in the repo. Otherwise write "not measured" and list the metric under "Metrics to instrument".
5. **Load the reference before judging a dimension.** Never score from memory. Each dimension section below names the reference file to load first.
6. **Keep secrets out.** Never copy API keys, tokens, passwords, connection strings, webhook signing secrets, customer names, emails, or other personal data into the report. Refer to them by file and key name only (for example `config/billing.ts:12 (STRIPE_SECRET_KEY read from env)`). If you find a committed secret, report its location as a High severity finding without the value.
7. **Assume, record, ask later.** When business context is ambiguous, write an explicit assumption and continue. Collect questions for the owner at the end instead of blocking.
8. **Parallelize when the host supports it.** After Phase 1, dimensions are independent. If subagents are available, give each one dimension (or a small group), the Phase 0 context, the Phase 1 inventory, and the reference file path. Each returns scores, evidence, and gaps in the Phase 3 format. Merge results yourself and resolve contradictions.
9. **Mark N/A with a reason.** A check that does not apply to this business (for example sales process checks for a pure self-serve product with no sales team) is N/A, with a one-line justification. N/A items do not lower the score.

## Phase 0: Business context

Goal: know what kind of revenue engine this product should have before judging what it has. The same gap is critical for one business and irrelevant for another.

Sources, in order: `README*`, `docs/`, marketing site or landing app, pricing page components, plan and price definitions in code or seed data, billing provider configuration, CRM integration code, terms of service, investor or planning docs if present.

Record each item with its evidence and a confidence level (High, Medium, Low):

| Item | Values to choose from | Where to look |
|---|---|---|
| Revenue model | subscription, usage-based, hybrid, seat-based, one-time plus maintenance, marketplace take rate | plan definitions, billing code, pricing page |
| Pricing structure | tiers, value metric, free plan, trial, annual discount, add-ons | pricing page, plan constants, price IDs |
| Customer segment | consumer, prosumer, SMB, mid-market, enterprise | pricing levels, SSO/SAML, audit logs, contracts, sales pages |
| Contract value range | annual value per account, order of magnitude only | price points times typical seats; never guess customer data |
| Go-to-market motions | self-serve, product-led, inside sales, field sales, partner, mixed | "contact sales" CTAs, demo booking, CRM sync, checkout flow |
| Stage | pre-product-market-fit, early traction, scaling, mature | README, docs, number of plans, team roles in docs, data volume if visible |
| Billing provider | named provider or in-house | dependency manifests, webhook routes |

Write assumptions as testable statements, for example: "Assumption A1: sales-assisted deals exist for the top tier, because `pricing.tsx:88` shows a Contact sales button. Confirm with owner." Every later finding that depends on an assumption references its ID.

Then load `references/11-growth-stages.md` and note which capabilities are expected at this stage. Use that expectation to set severity in Phase 3: a missing capability that is not expected at the current stage is Low severity, not High.

## Phase 1: Ecosystem inventory

Goal: map every place revenue data is created, moved, stored, or displayed. Build the inventory table used in the report.

### 1.1 Stack and structure

```bash
ls -la
find . -maxdepth 3 \( -name package.json -o -name pyproject.toml -o -name requirements*.txt -o -name Gemfile -o -name go.mod -o -name composer.json -o -name pom.xml -o -name build.gradle* -o -name Cargo.toml \) -not -path '*/node_modules/*'
find . -maxdepth 2 -type d -not -path '*/node_modules/*' -not -path '*/.git*'
rg --files -g '*.sql' -g '*migration*' -g '*schema*' -g '*.prisma' | head -100
rg --files -g 'docker-compose*' -g '*.tf' -g 'serverless*' -g 'vercel.json' -g 'fly.toml' -g 'render.yaml' -g 'Procfile'
```

### 1.2 Integrations (dependency manifests first)

```bash
# Billing and payments
rg -il 'stripe|paddle|chargebee|recurly|braintree|lemonsqueezy|lemon_squeezy|adyen|mercadopago|pagar\.?me|iugu|zuora|maxio|chargify|orb|lago|metronome' -g '!*.lock' -g '!node_modules'
# CRM and sales tooling
rg -il 'hubspot|salesforce|pipedrive|close\.com|closeio|attio|zoho|freshsales|copper' -g '!*.lock'
# Product analytics and tracking
rg -il 'segment|rudderstack|amplitude|mixpanel|posthog|heap|june\.so|gtag|google-analytics|ga4|plausible|fathom|snowplow|jitsu' -g '!*.lock'
# Email and messaging
rg -il 'sendgrid|postmark|mailgun|resend|ses|customer\.io|customerio|loops|braze|intercom|mailchimp|brevo|sendinblue' -g '!*.lock'
# Support and success
rg -il 'zendesk|intercom|helpscout|freshdesk|crisp|front|gainsight|vitally|churnzero|planhat' -g '!*.lock'
# BI and dashboards
rg -il 'metabase|looker|superset|grafana|redash|tableau|mode|hex|dbt|cube' -g '!*.lock'
```

### 1.3 Revenue term sweep

Run these and keep the counts plus the top files. High counts show where logic lives; zero counts are candidates for "not found".

```bash
for t in subscription plan trial invoice webhook churn mrr arr lead stage onboarding activation cohort health renewal upgrade downgrade referral utm track; do
  printf '%-14s %s\n' "$t" "$(rg -il "$t" -g '!*.lock' -g '!node_modules' -g '!dist' -g '!build' | wc -l)"
done
```

```bash
rg -n -i 'subscription(s)?\b' -g '!*.lock' | head -50
rg -n -i '\b(plan|tier|price)_?id\b' -g '!*.lock' | head -50
rg -n -i 'trial(_| )?(end|start|expire|days)' -g '!*.lock'
rg -n -i 'invoice\.(paid|payment_failed|created|finalized)|invoice_(paid|failed)' -g '!*.lock'
rg -n -i 'webhook' -g '!*.lock' | head -50
rg -n -i '\b(churn|cancel(l)?ed|cancellation|cancel_at)\b' -g '!*.lock' | head -50
rg -n -i '\b(mrr|arr|nrr|grr|ltv|cac|arpa|arpu)\b' -g '!*.lock'
rg -n -i '\b(lead|mql|sql|opportunit(y|ies)|deal|pipeline)\b' -g '!*.lock' | head -50
rg -n -i '\b(lifecycle_?stage|funnel_?stage|deal_?stage|stage)\b' -g '!*.lock' | head -50
rg -n -i 'onboarding|activation|activated|aha|first_value|setup_complete' -g '!*.lock' | head -50
rg -n -i 'cohort|retention' -g '!*.lock' | head -50
rg -n -i 'health_?score|at_?risk|usage_?score' -g '!*.lock'
rg -n -i 'renewal|renew(s|ed)?_at|auto_?renew' -g '!*.lock'
rg -n -i 'upgrade|downgrade|proration|prorate|change_?plan' -g '!*.lock' | head -50
rg -n -i 'referral|invite|affiliate|promo_?code|coupon' -g '!*.lock' | head -50
rg -n -i 'utm_(source|medium|campaign|term|content)|gclid|fbclid|referrer' -g '!*.lock'
rg -n -i '\b(track|identify|capture|logEvent|analytics\.)\(' -g '!*.lock' | head -100
```

### 1.4 Data model, jobs, and surfaces

```bash
# Tables and models that carry revenue state
rg -n -i '(create table|model |class .*\(.*Model|@Entity|schema\.table|pgTable|defineTable).*(account|customer|organization|workspace|subscription|plan|invoice|payment|usage|event|lead|deal)' -g '!*.lock'
# Scheduled and background jobs
rg -n -i 'cron|schedule|@scheduled|celery|sidekiq|bullmq|bull|agenda|resque|delayed_job|rq|temporal|inngest|trigger\.dev' -g '!*.lock' | head -50
# Pricing, checkout, billing portal, and dashboards in the UI
rg -il 'pricing|checkout|billing|customer.?portal|paywall|upgrade' -g '*.{tsx,jsx,vue,svelte,html,erb,blade.php,twig,astro}'
rg -il 'dashboard|report|kpi|metric' -g '*.{tsx,jsx,vue,svelte,sql,py,rb}' | head -50
# Docs about process
rg -il 'playbook|runbook|pricing|sales|onboarding|retention|metrics' docs/ 2>/dev/null
```

### 1.5 Inventory output

Fill one row per component. Mark external systems that the repo only calls as "external, config not visible".

| Component | Present | Location (evidence) | Notes |
|---|---|---|---|
| Apps and services | | | |
| Database and schema | | | |
| Billing provider integration and webhooks | | | |
| CRM | | | |
| Product analytics and tracking | | | |
| Email and lifecycle messaging | | | |
| Support and success tools | | | |
| Dashboards and BI | | | |
| Background jobs | | | |
| Docs and playbooks | | | |
| Landing and pricing pages | | | |

## Phase 2: Dimension assessment

For each dimension: load the reference first (mandatory), run its audit checklist against the Phase 1 evidence, and record for every check ID: status (Pass, Partial, Fail, N/A), evidence, and severity from the reference. The key checks listed below are the minimum to cover; run the full checklist in the reference.

### D1. Customer lifecycle

- **Why it matters:** without explicit lifecycle stages, no conversion rate or handoff can be measured or owned.
- **Load first:** `references/01-customer-lifecycle.md`
- **Key checks:** all `LC-*` items, prioritizing a persisted lifecycle stage per account, timestamped stage transitions, and a single definition of "customer".
- **Weak signals:** stage stored only in the CRM with no sync; status derived on the fly from several booleans; no history table, so stage entry dates are lost; "customer" meaning different things in billing and analytics.

### D2. Metrics

- **Why it matters:** revenue decisions are only as good as the definitions behind MRR, churn, and retention.
- **Load first:** `references/02-metrics.md`
- **Key checks:** all `MT-*` items, prioritizing MRR movement components (new, expansion, contraction, churn, reactivation), gross and net revenue retention, and a written metrics dictionary.
- **Weak signals:** MRR computed from invoice totals including one-time charges, taxes, or unamortized annual payments; churn counted on cancel click instead of period end; metric logic duplicated in several queries with different results; no `templates/metrics-dictionary.yaml` equivalent in the project.

### D3. Pricing and packaging

- **Why it matters:** pricing is the highest leverage revenue lever and is often hard coded in ways that block experiments.
- **Load first:** `references/03-pricing-and-packaging.md`
- **Key checks:** all `PR-*` items, prioritizing a single source of truth for plans and entitlements, a value metric aligned with customer value, and support for grandfathering and price changes.
- **Weak signals:** plan limits scattered as `if plan == "pro"` conditionals; prices duplicated between pricing page and billing code; no entitlement layer; changing a price requires a deploy.

### D4. Go-to-market motions

- **Why it matters:** the product, pricing, and tooling must match how customers actually buy.
- **Load first:** `references/04-go-to-market-motions.md`
- **Key checks:** all `GM-*` items, prioritizing that each motion (self-serve, product-led, inside sales, field sales) has an entry point, a routing rule, and an owner.
- **Weak signals:** "Contact sales" form that emails a shared inbox with no CRM record; enterprise features sold but not gated; self-serve checkout unavailable for plans priced for self-serve.

### D5. Demand and acquisition

- **Why it matters:** acquisition spend and effort cannot be allocated without source attribution tied to revenue.
- **Load first:** `references/05-demand-and-acquisition.md`
- **Key checks:** all `AQ-*` items, prioritizing capture and persistence of first-touch and last-touch attribution (UTM, referrer) on signup, and linkage from source to paid conversion.
- **Weak signals:** UTM parameters read by the analytics script but never stored on the account; referral program without fraud limits or tracking; CAC not computable because spend and conversions live in unconnected systems.

### D6. Sales process

- **Why it matters:** for sales-assisted motions, a defined and instrumented process drives forecast accuracy and win rate.
- **Load first:** `references/06-sales-process.md`
- **Key checks:** all `SP-*` items, prioritizing defined deal stages with exit criteria, lead routing and response time tracking, and qualification fields captured in the CRM.
- **Weak signals:** deal stages named by activity rather than buyer commitment; no product usage data visible to sales; manual lead assignment. Mark the whole dimension N/A when Phase 0 confirms no sales team and no sales-assisted motion.

### D7. Onboarding and activation

- **Why it matters:** activation is the strongest early predictor of conversion and retention.
- **Load first:** `references/07-onboarding-and-activation.md`
- **Key checks:** all `ON-*` items, prioritizing a defined, measurable activation event, time to value tracking, and onboarding flows triggered by product behavior.
- **Weak signals:** "activated" set on signup or email confirmation; onboarding checklist with no events behind it; trial emails sent on fixed days regardless of usage.

### D8. Retention and expansion

- **Why it matters:** in recurring revenue, retained and expanded revenue compounds; lost revenue must be replaced before growth counts.
- **Load first:** `references/08-retention-and-expansion.md`
- **Key checks:** all `RE-*` items, prioritizing failed payment recovery (dunning), cancellation flow with reason capture, account health scoring, and expansion triggers.
- **Weak signals:** no handling of `payment_failed` webhooks; cancellation is a single button with no reason; health score exists but nothing acts on it; renewals tracked in a spreadsheet.

### D9. Data and instrumentation

- **Why it matters:** every other dimension depends on trustworthy events and tables.
- **Load first:** `references/09-data-and-instrumentation.md`
- **Key checks:** all `DI-*` items, prioritizing a tracking plan (compare with `templates/tracking-plan.yaml`), server-side tracking for revenue events, idempotent webhook processing, and identity stitching between anonymous, user, and account.
- **Weak signals:** event names inconsistent in case and tense; revenue events fired only client-side; webhook handler without signature verification or idempotency key; no account-level grouping in analytics.

### D10. Revenue operations

- **Why it matters:** systems, data flows, and ownership must connect so teams act on one version of the truth.
- **Load first:** `references/10-revenue-operations.md`
- **Key checks:** all `RO-*` items, prioritizing billing to CRM to analytics sync, a documented system of record per field, and reporting cadence with owners.
- **Weak signals:** the same field edited in two systems with no sync direction; dashboards nobody owns; manual CSV exports as the main integration.

### D11. Growth stages

- **Why it matters:** the right investment depends on stage; overbuilding early and underbuilding late both waste money.
- **Load first:** `references/11-growth-stages.md`
- **Key checks:** all `GS-*` items, prioritizing that current capabilities match stage expectations and that the next stage's constraints are identified.
- **Weak signals:** complex tooling with no data flowing through it; scaling spend without retention evidence; no stage-appropriate north star metric.

### D12. Continuous improvement

- **Why it matters:** a revenue engine improves only when changes are measured and fed back into decisions.
- **Load first:** `references/12-continuous-improvement.md`
- **Key checks:** all `CI-*` items, prioritizing an experiment or change log tied to metrics, regular metric reviews, and feature flags or a mechanism to test pricing and onboarding changes.
- **Weak signals:** feature flags exist but are never tied to outcome metrics; no record of past pricing or onboarding changes; retrospectives without follow-up actions.

## Phase 3: Scoring

Score each dimension 0 to 4 from the check results. Pick the highest level whose criteria are all met.

| Score | Label | Objective criteria |
|---|---|---|
| 0 | Missing | No evidence of the capability in the repo or confirmed external tools. High severity checks all Fail or not found. |
| 1 | Ad hoc | Some pieces exist but are manual, inconsistent, or undocumented (for example a one-off script, a spreadsheet mentioned in docs). Most High severity checks Fail. |
| 2 | Partial | Core mechanism exists in code or config, but at least one High severity check Fails or data is incomplete (for example tracked client-side only, no history, no tests). |
| 3 | Implemented | All High severity checks Pass. Logic is in code or config, documented, and covered by tests or verifiable queries. Some Medium checks may Fail. |
| 4 | Optimized | Score 3 criteria plus a closed feedback loop: the output is reviewed on a cadence, someone owns it, and changes are measured against it (evidence: experiment log, alerts, review docs, automated actions). |

Rules:

- **N/A:** a check or dimension marked N/A needs a one-line justification tied to a Phase 0 fact or assumption. Compute the score from the applicable checks only. Show N/A dimensions as "N/A" in the scorecard, not as 0.
- **Confidence:** High when evidence is in code and tests; Medium when it relies on config or docs; Low when it depends on assumptions or external systems you could not inspect.
- **Priority of a gap:** `priority = impact x (1 / effort)`, with impact 1 to 3 (revenue at risk or unlocked, weighted by stage expectation from Phase 0) and effort 1 to 3 (1 is under a day, 2 is under a week, 3 is longer). Billing correctness and data loss issues are always "Now".
- **Buckets:** Now (high impact, or blocks other work), Next (high impact, higher effort), Later (low impact or not yet stage-appropriate).

## Phase 4: Report

1. Copy `templates/audit-report.md` and fill every section. Leave no placeholder; write "none found" where a section is empty.
2. Save to `docs/revenue-audit.md` in the audited project unless the owner specifies another path. If the file exists, write `docs/revenue-audit-YYYY-MM-DD.md` instead and do not overwrite.
3. Include every command you ran in the appendix, with a one-line summary of the result.
4. List questions for the owner, each linked to the assumption ID or finding it would change.
5. Scan the finished report for secrets and personal data before saving (see rule 6).
6. Reply to the owner with: the scorecard, the top three "Now" items, and the open questions. To act on the findings, follow `IMPLEMENT.md`.

## Checklist before finishing

- [ ] Phase 0 table filled, assumptions numbered.
- [ ] Inventory table covers all eleven component rows.
- [ ] Every dimension scored or marked N/A with justification, after loading its reference.
- [ ] Every finding has evidence (`path:line` or command output).
- [ ] No invented metrics; unmeasured metrics listed with formulas.
- [ ] No code changed; no secrets in the report.
- [ ] Report saved and path given to the owner.
