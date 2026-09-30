# Authoring Guide

This guide defines how content in this repository is written. Every contributor (human or tool) follows it.

## Repository layout

```text
saas-revenue-engine/
  skills/saas-revenue-engine/
    SKILL.md                      entry point, always loaded (keep under ~2,500 words)
    AUDIT.md                      protocol to audit a SaaS project end to end
    IMPLEMENT.md                  protocol to implement missing capabilities
    references/                   loaded on demand
      01-customer-lifecycle.md
      02-metrics.md
      03-pricing-and-packaging.md
      04-go-to-market-motions.md
      05-demand-and-acquisition.md
      06-sales-process.md
      07-onboarding-and-activation.md
      08-retention-and-expansion.md
      09-data-and-instrumentation.md
      10-revenue-operations.md
      11-growth-stages.md
      12-continuous-improvement.md
      cheatsheet.md
      glossary.md
    templates/
      metrics-dictionary.yaml
      tracking-plan.yaml
      audit-report.md
      sql/                        PostgreSQL reference queries and schema
  scripts/validate.py             repository linter (run in CI)
  docs/AUTHORING.md               this file
```

## Language and style

- Content language: **English** (US spelling). Only `README.pt-BR.md` is in Portuguese.
- **Never use the em dash or the en dash characters.** Use a comma, colon, parentheses, a period, or "to" for ranges ("3 to 5", "10-20"). CI fails on them.
- Write for a practitioner who will act: imperative voice, "Do X when Y because Z". No filler, no marketing tone, no emojis.
- Prefer tables, checklists and formulas over prose paragraphs.
- Every metric has: definition, formula (in a code block), unit, grain (per account, per cohort, per month), common mistakes.
- Benchmarks: only widely published industry ranges, always framed as "typical ranges, calibrate to your segment", never as universal truth. No invented statistics, no fake precision, no fabricated case studies. Illustrative examples must be labeled as illustrative and use round, obviously hypothetical numbers.
- Do not mention AI, language models, or any tool vendor as the author of content.

## Originality rules (mandatory)

This repository is original work built from general, publicly known SaaS practice. Do **not** reference, paraphrase, or reuse the structure, examples, or proprietary vocabulary of any specific book, course, or consultancy. Do not adopt trademarked or branded method names as the backbone of the content, and do not copy distinctive examples, numbered schemes, or benchmark tables from any single source. Use neutral industry vocabulary instead: customer lifecycle, funnel stages, stage conversion rate, stage velocity, self-serve, product-led, inside sales, field sales, enterprise, account management, customer success.

Well-known public frameworks may be named with a one-line neutral description when useful (for example MEDDICC, BANT, Jobs To Be Done, AARRR, Rule of 40, Magic Number, Burn Multiple), but the repository must not depend on any single proprietary methodology.

## Reference file template

Each `references/NN-*.md` file follows this skeleton (omit a section only if it is truly empty):

```text
# <Title>

> Scope: one sentence. Load when: one sentence.

## Why it matters
## Core principles            (numbered, each one actionable)
## Model / framework          (tables, stage definitions, decision trees)
## Metrics                    (definition, formula, grain, pitfalls)
## Implementation guide       (what to build in the product and stack: schema, events, jobs, integrations, UI)
## Anti-patterns
## Audit checklist            (table: ID | Check | Evidence to look for | Severity High/Medium/Low)
## Related                    (links to other reference files)
```

Audit check IDs use a per-file prefix: `LC` lifecycle, `MT` metrics, `PR` pricing, `GM` go-to-market, `AQ` acquisition, `SP` sales process, `ON` onboarding, `RE` retention and expansion, `DI` data and instrumentation, `RO` revenue operations, `GS` growth stages, `CI` continuous improvement. Number them `LC-01`, `LC-02`, ...

Target size per reference file: 1,500 to 3,000 words. Dense beats long.

## Markdown conventions

- One H1 per file. Relative links between files. Fenced code blocks with a language tag.
- Tables stay under ~6 columns so they render on narrow screens.
- Line length is free; do not hard wrap prose.
