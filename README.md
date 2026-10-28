# Fullstack Skills

Reusable [Agent Skills](https://agentskills.io/) for AI coding agents working on full-stack software projects. Each skill is a focused `SKILL.md` with task-specific guidance that an agent can load when relevant; it does not install tools, dependencies, or services.

This repository currently contains thirteen starter skills. They offer practical workflow guidance, not exhaustive coverage or a guarantee that generated changes are correct. Review skill instructions and agent output as you would other code.

## Skills

| Skill | Use it for |
| --- | --- |
| [`fullstack-core`](skills/fullstack-core/SKILL.md) | Repository orientation, planning, cross-layer implementation, debugging, and delivery checks. |
| [`react-typescript`](skills/react-typescript/SKILL.md) | Building, debugging, refactoring, and testing React + TypeScript interfaces. |
| [`node-api`](skills/node-api/SKILL.md) | Node.js services and REST APIs, including validation, authentication, and error handling. |
| [`database-prisma`](skills/database-prisma/SKILL.md) | Database design, Prisma schemas, migrations, queries, and transactions. |
| [`testing-quality`](skills/testing-quality/SKILL.md) | Test planning, regression investigation, feature validation, and coverage review. |
| [`security-review`](skills/security-review/SKILL.md) | Defensive review of application security risks and configuration. |
| [`docker-devops`](skills/docker-devops/SKILL.md) | Docker, Compose, CI, environment configuration, and deployment reliability. |
| [`ci-cd`](skills/ci-cd/SKILL.md) | CI/CD pipeline triggers, jobs, permissions, artifacts, and delivery gates. |
| [`code-review`](skills/code-review/SKILL.md) | Diff-based review for correctness, regressions, maintainability, and missing verification. |
| [`git-workflows`](skills/git-workflows/SKILL.md) | Branching, commits, merges, conflict resolution, and repository change handoff. |
| [`nestjs-development`](skills/nestjs-development/SKILL.md) | NestJS-specific modules, dependency injection, request lifecycle, and testing. |
| [`rest-api-design`](skills/rest-api-design/SKILL.md) | REST resources, HTTP contracts, errors, pagination, and API compatibility. |
| [`system-design`](skills/system-design/SKILL.md) | System architecture, data flows, scalability, reliability, and design tradeoffs. |

## Compatibility

Skills use the open Agent Skills folder format: a directory containing `SKILL.md` with `name` and `description` metadata and Markdown instructions. The format is supported by a growing range of products, but format support alone does not verify a particular skill's installation or activation in an agent.

The installation test in this repository verified all seven skills that existed at the time copied into an isolated project's OpenCode directory (`.agents/skills/`). The six subsequently added skills have passed repository metadata validation, but have not been independently tested for agent activation. Compatibility with Claude Code, Codex, Cursor, and other agents has not been tested for this repository. The `skills` CLI supports agent-specific targets; consult its current help and your agent's own documentation for supported target identifiers and any additional setup. Some agents may require an adapter or manual placement.

## Install

Prerequisites: Node.js/npm for `npx`, and network access to GitHub. Run these commands from the project directory where you want project-local skills, or add `--global` for user-level installation.

Preview the repository's available skills without installing:

```bash
npx skills add sudeeppatgar/fullstack-skills --list
```

Install all thirteen skills for OpenCode in the current project:

```bash
npx skills add sudeeppatgar/fullstack-skills --skill '*' --agent opencode
```

Install one selected skill instead:

```bash
npx skills add sudeeppatgar/fullstack-skills --skill react-typescript --agent opencode
```

To install globally for the selected agent, include `--global` (or `-g`):

```bash
npx skills add sudeeppatgar/fullstack-skills --skill '*' --agent opencode --global
```

The command may prompt for confirmation; inspect the target and overwrite summary before approving. Replace `opencode` only with an agent identifier supported by your installed CLI. `--agent '*'` targets every agent recognized by the CLI; it does not guarantee that all such agents can use every skill.

### Verify and manage

List project-local skills, optionally filtering for an agent:

```bash
npx skills list --agent opencode
```

For global installs, add `--global` to `list`. To update installed skills, run `npx skills update` from the project (or `npx skills update --global` for global skills). Remove selected project skills with `npx skills remove react-typescript`; add `--global` to remove a global install. These are the management commands shown by the CLI help; check that output for current details with `npx skills --help`.

After installation, check the target directory shown by the CLI (`.agents/skills/` for the verified OpenCode project install) and confirm your agent discovers or activates the skill. Restart or reload the agent if its documentation requires it. If installation fails, first run `npx skills add --help`, confirm the repository URL and skill name, and verify your agent's documented skills directory and format.

The CLI copies and runs skill instructions with the agent's permissions. Review the skills before using them.

## Contribute and validate

To add or change a skill, use `skills/<lowercase-kebab-case-name>/SKILL.md`, include clear `name` and `description` frontmatter, and write actionable guidance. Review [CONTRIBUTING.md](CONTRIBUTING.md) for requirements, especially third-party licensing and attribution.

The validator requires Python 3 and PyYAML. From the repository root:

```bash
python3 -m pip install PyYAML==6.0.2
bash scripts/validate-skills.sh
python3 -m unittest discover -s tests -v
```

The validator checks selected frontmatter and file-structure constraints; passing does not establish technical correctness, security, licensing compliance, or agent compatibility.

## License and security

The repository includes an [MIT License](LICENSE). If third-party content is introduced, its own license and notices apply; see [`docs/THIRD_PARTY_SKILLS.md`](docs/THIRD_PARTY_SKILLS.md) for the register.

For security concerns, follow [SECURITY.md](SECURITY.md) and use the repository's [private vulnerability reporting](https://github.com/sudeeppatgar/fullstack-skills/security/advisories/new) feature. Do not disclose sensitive details in a public issue.
