# Contributing

Thanks for helping improve SaaS Revenue Engine. This repository is a content project: most changes are to Markdown, YAML, and SQL files that an agent reads at runtime. Quality means accurate, actionable, and original guidance.

## How to propose a change

1. **Small fixes** (typos, broken links, a clearer formula): open a pull request directly.
2. **New content or structural changes** (a new reference file, a new audit check, a change to `SKILL.md`): open an issue first using the content request template, so scope can be agreed before you write.
3. Fork the repository, create a branch from `main`, make your change, and open a pull request against `main`.

## Content rules

The full rules live in the [authoring guide](docs/AUTHORING.md). The short version:

- English (US spelling) everywhere except `README.pt-BR.md`.
- Never use the em dash or the en dash characters. CI fails on them.
- Imperative, practitioner voice. Tables, checklists, and formulas over long prose.
- Every metric states its definition, formula, unit, grain, and common mistakes.
- Benchmarks are only widely published ranges, framed as "typical ranges, calibrate to your segment". No invented statistics or fabricated case studies. Illustrative examples are labeled and use round, obviously hypothetical numbers.
- Original work only. Do not reproduce or paraphrase the structure, examples, or proprietary vocabulary of any book, course, or consultancy. See the originality rules in the authoring guide for the list of terms to avoid.
- Reference files follow the template in the authoring guide and end with an `## Audit checklist` section.
- Keep `SKILL.md` lean. It is always loaded, so any growth must earn its place.

## Run the validator

The validator uses only the Python standard library (Python 3.9 or newer). PyYAML is optional; when installed, YAML files are also parsed.

```bash
python3 scripts/validate.py
```

It checks skill frontmatter, relative links, forbidden dash characters, YAML syntax, non-empty SQL files, and the presence of audit checklists. Fix every reported `file:line` message before opening a pull request. CI runs the same script plus markdownlint.

## Commit convention

Use [Conventional Commits](https://www.conventionalcommits.org/) in English:

```text
feat(references): add expansion triggers to retention reference
fix(sql): correct cohort boundary in nrr query
docs: clarify manual install for project-local skills
chore(ci): pin markdownlint action version
```

Common types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `ci`.

## Pull request checklist

- [ ] `python3 scripts/validate.py` passes locally.
- [ ] Content follows the [authoring guide](docs/AUTHORING.md), including the originality rules.
- [ ] No em dash or en dash characters.
- [ ] New or changed metrics include definition, formula, unit, grain, and pitfalls.
- [ ] Benchmarks, if any, are widely published ranges and framed as starting points.
- [ ] Links are relative and resolve.
- [ ] `SKILL.md` did not grow without a clear reason stated in the PR description.
- [ ] Commits follow Conventional Commits.

## Code of conduct

By participating you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).
