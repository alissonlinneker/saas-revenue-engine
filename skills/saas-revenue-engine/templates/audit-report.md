# Revenue Audit: <Project name>

| Field | Value |
|---|---|
| Date | <YYYY-MM-DD> |
| Repository | <name, branch, commit SHA> |
| Scope | <apps and services audited; systems excluded> |
| Auditor | <name or role> |
| Protocol | AUDIT.md, scoring 0 to 4 |

## 1. Executive summary

<Three to five sentences: what kind of revenue engine this business needs, how much of it exists today, the single biggest risk, and the first thing to fix.>

- **Overall maturity:** <average of scored dimensions, one decimal> / 4 (<n> dimensions scored, <n> N/A)
- **Top risks:** <1 to 3 bullets, each with finding ID>
- **Top opportunities:** <1 to 3 bullets, each with finding ID>

## 2. Context and assumptions

| Item | Value | Evidence | Confidence |
|---|---|---|---|
| Revenue model | | | High / Medium / Low |
| Pricing structure | | | |
| Customer segment | | | |
| Contract value range | | | |
| Go-to-market motions | | | |
| Stage | | | |
| Billing provider | | | |

**Assumptions**

| ID | Assumption | Based on | Affects findings |
|---|---|---|---|
| A1 | | | |

## 3. Ecosystem inventory

| Component | Present | Location (evidence) | Notes |
|---|---|---|---|
| Apps and services | Yes / No / Not found / External | | |
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

## 4. Scorecard

Scores: 0 Missing, 1 Ad hoc, 2 Partial, 3 Implemented, 4 Optimized. N/A requires a justification.

| Dimension | Score | Confidence | Top gap (finding ID) |
|---|---|---|---|
| D1 Customer lifecycle (LC) | | | |
| D2 Metrics (MT) | | | |
| D3 Pricing and packaging (PR) | | | |
| D4 Go-to-market motions (GM) | | | |
| D5 Demand and acquisition (AQ) | | | |
| D6 Sales process (SP) | | | |
| D7 Onboarding and activation (ON) | | | |
| D8 Retention and expansion (RE) | | | |
| D9 Data and instrumentation (DI) | | | |
| D10 Revenue operations (RO) | | | |
| D11 Growth stages (GS) | | | |
| D12 Continuous improvement (CI) | | | |

**N/A justifications**

- <Dimension or check ID>: <reason tied to a context fact or assumption ID>

## 5. Strengths (well implemented)

| ID | Check ID | What works | Evidence |
|---|---|---|---|
| S1 | | | `path:line` |

## 6. Partial items

| ID | Check ID | What exists | What is missing | Evidence | Severity |
|---|---|---|---|---|---|
| P1 | | | | `path:line` | High / Medium / Low |

## 7. Missing items

State "not found" (searched, nothing found) or "does not exist" (confirmed) explicitly.

| ID | Check ID | Capability | Not found or does not exist | Search evidence | Severity |
|---|---|---|---|---|---|
| M1 | | | | `<command>` | |

## 8. Prioritized roadmap

Impact and effort from 1 (low) to 3 (high). Priority = impact x (1 / effort). Billing correctness and data loss issues are always Now.

| Bucket | Finding IDs | Action | Impact | Effort | Depends on |
|---|---|---|---|---|---|
| Now | | | | | |
| Next | | | | | |
| Later | | | | | |

## 9. Quick wins

Items with impact 2 or more and effort 1.

- [ ] <finding ID>: <action>, <expected result>

## 10. Metrics to instrument

Only metrics that are not measured today or are measured incorrectly. No values here unless computed from real data during the audit.

| Metric | Formula | Unit | Grain | Source tables or events | Status |
|---|---|---|---|---|---|
| | | | | | Not measured / Incorrect |

Formulas used above:

```text
<metric> = <formula>
```

## 11. Open questions for the owner

| ID | Question | Why it matters | Changes finding or assumption |
|---|---|---|---|
| Q1 | | | |

## 12. Implementation status

Filled in by `IMPLEMENT.md` as work progresses.

| Finding ID | Status | Pull request or commit | Verification result | New score |
|---|---|---|---|---|
| | Not started / In progress / Blocked / Done | | | |

## Appendix A. Commands run

| # | Command | Result summary |
|---|---|---|
| 1 | `<command>` | <counts or one-line result, no secrets> |

## Appendix B. Check results by dimension

<One subsection per dimension listing every check ID with status Pass, Partial, Fail, or N/A, plus evidence.>

### D1 Customer lifecycle

| Check ID | Status | Evidence |
|---|---|---|
| LC-01 | | |
