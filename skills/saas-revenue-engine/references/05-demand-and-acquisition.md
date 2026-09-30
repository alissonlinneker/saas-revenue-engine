# Demand and Acquisition

> Scope: defining who to acquire (ICP and personas), which channels to use, and how leads are captured, enriched, scored, routed, qualified, and attributed, within privacy law. Load when: building or auditing the top of the funnel, lead handling, scoring, attribution, or outreach practices.

## Why it matters

Acquisition spend is wasted when it attracts accounts that never activate or churn quickly. The goal is not more leads but more of the right accounts, reached through channels whose cost fits the motion, and handled fast enough that intent is not lost. Weak data hygiene (missing UTMs, duplicate records, no consent records) makes every later decision about budget guesswork and creates legal exposure.

## Core principles

1. **Define the ICP from retained, expanding customers, not from wishful targeting.** Refresh it on a schedule.
2. **Score leads on two axes: fit and intent.** Fit says whether they should buy; intent says whether they are ready now.
3. **Respond fast to high-intent inbound.** Response time is one of the cheapest conversion levers available.
4. **Route deterministically.** Every lead has one owner decided by written rules, and every decision is logged.
5. **Qualify on the customer's problem and priority,** using a framework consistently rather than a checklist of form fields.
6. **Treat attribution as directional evidence, not truth.** Combine models and self-reported data, and test with experiments where possible.
7. **Capture consent and honor it everywhere.** Privacy compliance is part of the data model, not a footer link.
8. **Prefer relevance over volume in outreach.** Mass unsolicited messaging damages domain reputation, brand, and legal standing.
9. **Measure channels on downstream outcomes** (pipeline, revenue, retention), not on clicks or lead counts.

## Model / framework

### ICP and personas

The ideal customer profile describes the account; personas describe the people inside it.

| ICP dimension | Examples of criteria |
|---|---|
| Firmographic | Industry, employee count, revenue band, region, business model (B2B, B2C), funding stage |
| Technographic | Tools already used (CRM, data warehouse, cloud), integrations required |
| Behavioral | Actions that precede success: invites teammates in week one, connects a data source, uses a core feature weekly |
| Situational triggers | New funding, hiring for a relevant role, new regulation, leadership change, expansion to a new market |
| Exclusions | Segments with poor retention, high support cost, or needs the product does not meet |

| Persona field | Content |
|---|---|
| Role and seniority | Economic buyer, champion, end user, technical evaluator, blocker |
| Jobs and goals | What they are trying to achieve (Jobs To Be Done is a useful public lens) |
| Pains and current workaround | What they do today and why it hurts |
| Evaluation criteria | What they check before buying |
| Where they learn | Channels, communities, publications |
| Objections | Security, cost, switching effort, internal priority |

**Feedback loop from retained customers to ICP (run quarterly):**

```text
1. Take accounts acquired 6 to 18 months ago.
2. Label outcomes: retained and expanded, retained flat, contracted, churned.
3. Compare firmographic, technographic, and early behavioral attributes across labels.
4. Keep attributes that separate good from bad outcomes; drop those that do not.
5. Update ICP criteria, scoring weights, targeting lists, and exclusions.
6. Record the change and date so future cohorts can be compared.
```

### Channels

| Channel | Strength | Weakness | Fits motion |
|---|---|---|---|
| Inbound (website, demo and trial requests) | High intent, compounding | Depends on awareness from other channels | All |
| Content and SEO | Compounding, low marginal cost | Slow to build, needs consistency | Self-serve, inside sales |
| Paid search | Captures existing demand, measurable | Costs rise with competition | Self-serve, inside sales |
| Paid social | Creates demand, precise targeting | Lower intent, creative fatigue | All, depends on audience |
| Outbound (email, phone, social selling) | Controllable, targets specific accounts | Costly per meeting, reputation risk if careless | Inside, field, enterprise |
| Partners | Borrowed trust and distribution | Slower, shared control | Mid-market, enterprise |
| Referrals and word of mouth | High win rate, low CAC | Hard to scale directly | All |
| Community | Trust, feedback, advocacy | Long horizon, hard to attribute | Self-serve, developer tools |
| Events | Relationship depth | Expensive, hard to measure | Field, enterprise |
| Marketplaces and integrations directories | Buyers already in context | Platform dependency, fees | Self-serve, product-led |

Channel selection rules:

- Start with one or two channels where the ICP already spends attention, and get them working before adding more.
- Match channel cost to motion: expensive channels need high contract values.
- Retire channels whose pipeline does not convert to retained revenue, even if lead volume looks healthy.

### Lead capture and enrichment

- Keep forms short: work email and one or two qualifying fields; enrich the rest.
- Enrich from a data provider or public sources (company size, industry, location, technology) at capture time, and store the enrichment source and date.
- Deduplicate on normalized email and on company domain; associate leads to existing accounts before routing.
- Flag personal email domains and competitors; do not silently discard them.
- Store first and latest touch attribution fields, consent status, and form identity on the record.

### Lead scoring (fit plus intent)

| Axis | Example signals | Illustrative weight |
|---|---|---|
| Fit | Company size in ICP range, target industry, target region, role seniority, required technology present | Points per match, penalty for exclusions |
| Intent | Demo request, pricing page visits, trial signup, product usage milestones, webinar attendance, reply to outreach | Points per action, decaying over time |

Use a two-dimensional grid rather than a single sum, so a perfect-fit account with no intent is not treated the same as a poor-fit account with high intent.

| | High intent | Low intent |
|---|---|---|
| High fit | Route to sales now | Nurture, target with account-based programs |
| Low fit | Self-serve path, light touch | Nurture or ignore |

Scoring rules:

- Decay intent points (for example halve after 30 days) so old activity does not inflate scores.
- Calibrate quarterly: compare scores against conversion to opportunity and to closed-won; adjust weights.
- Start with a simple rules model; move to statistical models only once you have enough labeled outcomes and a way to explain the score to sales.

### Speed to lead

- High-intent inbound (demo request, contact sales) deserves the fastest response your team can staff; many teams target minutes during business hours rather than hours or days.
- Offer instant booking on the form confirmation page to remove a round trip.
- Measure response time from form submission to first human touch, per rep and per hour of day.
- Outside business hours, send a useful automated reply and set expectations.

### Routing

```text
route(lead):
  if lead.domain matches existing account: assign account owner
  elif lead.fit_tier == "enterprise": assign enterprise territory owner
  elif lead.intent == "high": round robin within inside sales pod for region
  elif lead.fit_tier in ("mid","small") and lead.is_trial: self-serve nurture
  else: marketing nurture
  log(rule_id, owner_id, timestamp)
```

- Round robin must skip absent reps and respect capacity.
- Reassign automatically if the owner does not act within the SLA.
- Keep routing rules in one place, versioned.

### Qualification frameworks (neutral overview)

| Framework | What it checks | Good for | Limitation |
|---|---|---|---|
| BANT | Budget, Authority, Need, Timeline | Quick early screen in transactional sales | Buyers often lack budget until value is clear; can disqualify good deals too early |
| MEDDICC | Metrics, Economic buyer, Decision criteria, Decision process, Identify pain, Champion, Competition | Complex, multi-stakeholder deals | Heavy for small deals; becomes form-filling if not used in conversations |
| Problem-first discovery (generic) | A costly problem with a named owner, a measurable business case, and a reason to buy this quarter | Most B2B SaaS, especially inside sales | Needs skilled discovery; harder to standardize |

Pick one primary framework per motion, define what "qualified" means in observable terms, and record it in CRM fields that can be reported on. Depth of qualification should scale with deal size.

### Attribution and its limits

| Model | Credits | Useful for | Blind spot |
|---|---|---|---|
| First touch | The first known interaction | Which channels create awareness | Ignores everything that closed the deal |
| Last touch | The final interaction before conversion | Which channels capture demand | Overcredits branded search and direct |
| Multi-touch (linear, time decay, position based) | Distributes credit across touches | Seeing the path | Rules are arbitrary; misses untracked touches |
| Data-driven / algorithmic | Statistical credit | Large volumes with clean data | Opaque, needs volume, still misses offline |
| Self-reported ("How did you hear about us?") | What the buyer remembers | Dark social, word of mouth, podcasts, communities | Recall bias, vague answers |

Limits to accept:

- Cookie restrictions, ad blockers, cross-device journeys, and private sharing (messaging apps, internal forwarding) hide many touches.
- Attribution measures correlation. Use holdout tests, geographic splits, or budget on/off tests to estimate incremental impact of major channels.
- Report software attribution and self-reported source side by side; large disagreements are a signal to investigate.

### UTM hygiene

| Parameter | Rule | Example |
|---|---|---|
| `utm_source` | Platform or site, lowercase | `linkedin`, `newsletter` |
| `utm_medium` | Channel type from a fixed list | `cpc`, `paid_social`, `email`, `referral`, `partner` |
| `utm_campaign` | Campaign id from a naming convention | `2026q3_webinar_security` |
| `utm_content` | Creative or link variant | `hero_cta_v2` |
| `utm_term` | Keyword (paid search) | `saas_billing_software` |

- Maintain a shared taxonomy and a link builder; reject unknown values in reporting.
- Never put UTMs on internal links, which overwrite the real source.
- Persist first-touch and last-touch UTMs server side on signup and on lead creation.

### Consent and privacy basics (LGPD and GDPR)

This is not legal advice; involve counsel for your specifics.

- Identify a lawful basis for each processing purpose (consent, legitimate interest, contract). Marketing email to individuals often requires consent or a carefully assessed legitimate interest depending on jurisdiction.
- Consent must be specific, informed, freely given, and as easy to withdraw as to give. Do not pre-tick boxes.
- Record consent: who, what purpose, when, how (form version), and withdrawal.
- Cookie and tracking scripts that are not strictly necessary should load only after consent where required.
- Honor data subject requests (access, correction, deletion, portability) within legal deadlines, across CRM, marketing automation, analytics, and enrichment tools.
- Keep a record of processing and data processing agreements with vendors, including enrichment providers.
- Other regimes apply by region (for example CAN-SPAM and state privacy laws in the US, CASL in Canada).

### Avoiding volume-driven spam outreach

- Target named accounts that match the ICP with a specific reason to reach out now.
- Personalize based on research, not token insertion.
- Cap daily volume per mailbox, warm up new domains, authenticate email (SPF, DKIM, DMARC), and send outbound from a separate subdomain to protect the primary domain.
- Include a clear opt-out and honor it immediately across all tools.
- Stop sequences on reply, bounce, or out-of-office logic, and suppress existing customers and open opportunities.
- Monitor bounce, spam complaint, and reply rates; pause sequences that exceed thresholds set by your email provider.

## Metrics

**Lead to opportunity conversion**

```text
lead_to_opp = opportunities_created_from_leads_in_cohort / leads_in_cohort
```

Unit: percent. Grain: per lead cohort month, per channel and fit tier. Pitfall: using calendar period instead of cohort.

**Speed to lead**

```text
speed_to_lead = first_human_touch_at - lead_created_at
```

Unit: minutes. Grain: per lead; report median and 90th percentile per rep and channel. Pitfall: counting automated emails as a touch.

**Pipeline by channel**

```text
pipeline(channel) = sum(opportunity_amount where source_channel = channel)
```

Unit: currency. Grain: per quarter. Pitfall: mixing first-touch and last-touch definitions across reports.

**Channel CAC**

```text
channel_CAC = channel_spend_including_people / new_customers_attributed_to_channel
```

Unit: currency per customer. Grain: per quarter. Pitfall: excluding salaries and tools; attributing all customers from untracked sources to direct.

**ICP match rate**

```text
icp_match_rate = new_customers_meeting_ICP / new_customers
```

Unit: percent. Grain: per month. Pitfall: ICP definition changed without versioning, breaking trend comparison.

**Retention by acquisition channel**

```text
NRR_by_channel = revenue_now_from_cohort(channel) / starting_revenue_of_cohort(channel)
```

Unit: percent. Grain: per acquisition cohort and channel. Pitfall: small cohorts produce noisy results; aggregate or widen windows.

**Score calibration**

```text
conversion_by_score_band = closed_won_in_band / leads_in_band
```

Unit: percent. Grain: per score band per quarter. Pitfall: bands with near-identical conversion mean the score does not discriminate.

## Implementation guide

- **Schema.** Lead or contact table with: normalized email, domain, account id, `fit_score`, `intent_score`, `fit_tier`, `lifecycle_stage`, `owner_id`, `routed_rule_id`, `first_touch_*` and `last_touch_*` UTM fields, `self_reported_source`, `consent_status`, `consent_captured_at`, `consent_source`, `enriched_at`, `enrichment_source`.
- **Events.** `form_submitted`, `demo_requested`, `trial_started`, `lead_created`, `lead_scored`, `lead_routed`, `lead_first_touch`, `lead_qualified`, `lead_disqualified` (with reason), `consent_given`, `consent_withdrawn`.
- **Capture.** Server-side form handler that validates, stores UTMs from a first-party cookie or session, calls enrichment asynchronously, dedupes, and emits `lead_created`.
- **Scoring job.** Recompute scores on new events and nightly for decay; write score history so calibration can be run.
- **Routing service.** Versioned rule set, SLA timers, reassignment on breach, and a log table.
- **CRM sync.** Bidirectional sync with conflict rules (which system owns which field); consent and suppression propagate to every tool within minutes.
- **Self-reported source field.** Free text or short list on signup or demo form, stored separately from software attribution.
- **Privacy operations.** A deletion job that removes or anonymizes a person across systems; a consent ledger table that is append-only.
- **Dashboards.** Channel performance through to revenue and retention, speed to lead, score calibration, ICP match rate.

## Anti-patterns

- ICP written once from the founders' assumptions and never tested against retention.
- Single lead score that mixes fit and intent, so sales cannot tell why a lead is hot.
- Long forms asking for data enrichment could supply.
- Leads sitting unassigned overnight, or routed by a spreadsheet.
- Qualification fields filled in after the deal closes to satisfy reporting.
- Budget decisions made on last-touch attribution alone.
- UTMs on internal links, inconsistent casing, or free-form campaign names.
- Buying contact lists and emailing them without a lawful basis.
- Outbound measured by emails sent rather than qualified meetings and pipeline.
- Consent recorded in the marketing tool but ignored by the CRM or sales sequences.

## Audit checklist

| ID | Check | Evidence to look for | Severity |
|---|---|---|---|
| AQ-01 | ICP documented with firmographic, technographic, behavioral criteria, and exclusions | ICP document, versioned | High |
| AQ-02 | ICP refreshed from retention and expansion outcomes on a schedule | Quarterly analysis, change log | Medium |
| AQ-03 | Personas documented with role, goals, pains, and objections | Persona docs used in messaging | Low |
| AQ-04 | Channels measured through to pipeline, revenue, and retention | Channel dashboard | High |
| AQ-05 | Lead capture persists first and last touch UTMs server side | Schema fields, form handler code | High |
| AQ-06 | Enrichment and deduplication run at capture with source recorded | Enrichment job, dedupe logic | Medium |
| AQ-07 | Lead scoring separates fit and intent and decays intent | Scoring config or code | Medium |
| AQ-08 | Scores calibrated against conversion at least quarterly | Calibration report | Medium |
| AQ-09 | Speed to lead measured with median and 90th percentile | Timestamp fields, report | High |
| AQ-10 | Routing is rule-based, versioned, logged, with SLA reassignment | Routing service or CRM rules, log table | High |
| AQ-11 | One qualification framework per motion with reportable fields | CRM fields, sales playbook | Medium |
| AQ-12 | Disqualification requires a reason code | CRM picklist, report | Low |
| AQ-13 | Attribution reported with more than one model plus self-reported source | Reports, form field | Medium |
| AQ-14 | Major channel budgets validated with incrementality tests | Test plans and results | Low |
| AQ-15 | UTM taxonomy documented and enforced | Taxonomy doc, link builder, validation | Medium |
| AQ-16 | Consent captured with purpose, time, and source, and withdrawal honored across tools | Consent ledger, sync config | High |
| AQ-17 | Non-essential tracking loads only after consent where required | Consent manager config, page tests | High |
| AQ-18 | Data subject requests handled across all systems | Deletion job, request log | High |
| AQ-19 | Outbound uses authenticated sending domains, volume caps, and opt-out handling | DNS records, sequencing tool settings | High |
| AQ-20 | Outbound suppresses customers, open opportunities, and opted-out contacts | Suppression lists, sequence rules | Medium |

## Related

- [01-customer-lifecycle.md](01-customer-lifecycle.md)
- [02-metrics.md](02-metrics.md)
- [04-go-to-market-motions.md](04-go-to-market-motions.md)
- [06-sales-process.md](06-sales-process.md)
- [07-onboarding-and-activation.md](07-onboarding-and-activation.md)
- [09-data-and-instrumentation.md](09-data-and-instrumentation.md)
- [10-revenue-operations.md](10-revenue-operations.md)
