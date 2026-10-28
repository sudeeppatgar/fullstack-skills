# Contributing

Thanks for helping improve Fullstack Skills.

## Before submitting

- Explain the use case and which skill should own the guidance.
- Keep skills focused and avoid duplicating shared guidance.
- Use practical, framework-aware instructions.
- Do not include secrets, proprietary code, or machine-specific paths.
- For any third-party content, record its source, applicable license, required attribution, and modifications in [`docs/THIRD_PARTY_SKILLS.md`](docs/THIRD_PARTY_SKILLS.md).
- Run `bash scripts/validate-skills.sh`.

## Validator setup

The validator requires Python 3 and PyYAML. Install its pinned dependency with:

```bash
python3 -m pip install PyYAML==6.0.2
```

Run its tests with `python3 -m unittest discover -s tests -v`.

## Adding a skill

Create `skills/<skill-name>/SKILL.md`. Every immediate directory under `skills/` must contain a regular `SKILL.md` file. Use lowercase kebab-case for the directory and frontmatter name.

Each skill should say:
- what it helps with;
- when to use it;
- what workflow to follow;
- how to verify results;
- what it does not install or guarantee.

## Third-party content

Do not copy third-party content until you have reviewed its license and attribution requirements. Keep required notices intact and record the source, license, attribution, and modifications in [`docs/THIRD_PARTY_SKILLS.md`](docs/THIRD_PARTY_SKILLS.md). If terms are unclear, link to the source rather than redistributing it.
