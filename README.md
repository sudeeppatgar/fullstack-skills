# Fullstack Skills

A curated, modular, multi-agent collection of AI skills for full-stack software development.

Use focused, reusable skills to help AI coding agents understand project conventions, implement features, test code, review security, and follow reliable development workflows.

**Status:** Early scaffold. The included skills provide starter guidance and have not all been independently validated in production.

## Goals

- Support multiple AI coding agents through a shared skill collection.
- Maintain one source of truth for each skill.
- Provide focused guidance for common full-stack development tasks.
- Support original skills and carefully reviewed third-party contributions.
- Maintain clear provenance, licensing, validation, and contribution standards.
- Cover React, TypeScript, Node.js, APIs, databases, testing, security, and DevOps.

## Supported AI Agents

This repository uses the Agent Skills format, with installation handled by the `skills` CLI.

The CLI supports multiple coding agents, and the available integrations depend on the installed CLI version.

Examples of agents you may be able to target include:

- OpenCode
- Claude Code
- OpenAI Codex
- Cursor
- Other agents supported by the CLI

**Compatibility is not the same as testing.** Agent-specific installation and skill discovery should be verified before claiming that a particular integration has been tested.

## Installation

### Install all discovered skills

Install globally for all agents supported by your installed CLI:

```bash
npx skills add sudeeppatgar/fullstack-skills \
  --skill '*' \
  --global \
  --agent '*'
```

Review the CLI's confirmation prompts before proceeding.

### Preview available skills

```bash
npx skills add sudeeppatgar/fullstack-skills --list
```

### Install for a specific agent

For example, to target OpenCode:

```bash
npx skills add sudeeppatgar/fullstack-skills \
  --skill '*' \
  --global \
  --agent opencode
```

Other agents can be targeted by substituting an agent identifier supported by your installed CLI.

### Verify installation

```bash
npx skills list --global
```

To filter the list for a specific agent:

```bash
npx skills list --global --agent opencode
```

Check the installed CLI's help if an option or agent identifier is unsupported:

```bash
npx skills add --help
npx skills list --help
```

Installation requirements and skill discovery behavior may differ across agents and CLI versions. Test installation in a disposable environment before relying on the collection in a production workflow.

## Included Skills

| Skill              | Purpose                                                  |
| ------------------ | -------------------------------------------------------- |
| `fullstack-core`   | Repository inspection, planning, and delivery discipline |
| `react-typescript` | React and TypeScript development                         |
| `node-api`         | Node.js and REST API development                         |
| `database-prisma`  | Database and Prisma workflows                            |
| `testing-quality`  | Unit, integration, and browser testing                   |
| `security-review`  | Application security review                              |
| `docker-devops`    | Containerization and delivery workflows                  |

These are starter skills. Their presence does not imply exhaustive coverage or independent production validation.

## Repository Structure

```text
fullstack-skills/
├── skills/
│   ├── fullstack-core/SKILL.md
│   ├── react-typescript/SKILL.md
│   ├── node-api/SKILL.md
│   ├── database-prisma/SKILL.md
│   ├── testing-quality/SKILL.md
│   ├── security-review/SKILL.md
│   └── docker-devops/SKILL.md
├── docs/
│   ├── THIRD_PARTY_SKILLS.md
│   └── RELEASE_CHECKLIST.md
├── scripts/
│   └── validate-skills.sh
├── CONTRIBUTING.md
├── SECURITY.md
├── LICENSE
└── README.md
```

## How Skills Work

Skills are focused instruction sets that an AI coding agent can load when relevant.

A skill may provide:

- Task-specific workflows and checklists.
- Development conventions and implementation guidance.
- Testing and code-review procedures.
- References to supporting documentation and examples.

A skill does not automatically install programming languages, packages, databases, browsers, MCP servers, or other external dependencies.

## Contributing

Contributions are welcome.

When adding or modifying a skill:

1. Follow the repository's skill structure and naming conventions.
2. Write clear metadata and explain when the skill should be used.
3. Include actionable instructions rather than vague advice.
4. Avoid duplicating existing skills.
5. Validate technical recommendations and example commands.
6. Add tests or validation rules when appropriate.
7. Document third-party sources and preserve applicable license notices.
8. Run the validation script before submitting a pull request.

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## Adding Third-Party Skills Safely

Before redistributing third-party skill content:

1. Identify the original repository and exact skill path.
2. Read the relevant source and repository licenses.
3. Check permissions for redistribution, modification, and sublicensing.
4. Preserve required copyright, license, and attribution notices.
5. Record the source URL, author, license, retrieval date, and local modifications in `docs/THIRD_PARTY_SKILLS.md`.
6. Do not assume the repository's MIT license overrides third-party licensing terms.
7. Review the skill for technical correctness, security, and quality.

If redistribution is not permitted or the terms are unclear, link to the original source instead of copying its content.

## Quality and Security Principles

- Prefer small, task-specific skills.
- Keep instructions consistent and avoid unnecessary duplication.
- Never include credentials, tokens, private data, or machine-specific paths.
- Treat external content and generated instructions as untrusted until reviewed.
- Do not claim that a command or workflow has been tested unless it has actually been run.
- Test installation and updates in a disposable environment before releases.
- Keep third-party provenance and licensing information accurate.

Report security concerns according to [SECURITY.md](SECURITY.md).

## Validate Locally

Run the repository's basic validation script:

```bash
bash scripts/validate-skills.sh
```

This checks basic structure. It does not establish technical correctness, security, licensing compliance, or compatibility with every agent.

## Roadmap

Planned areas for future development include:

- NestJS and Fastify development.
- REST API design and validation.
- Git workflows and code review.
- CI/CD and deployment automation.
- System design and architecture.
- More comprehensive skill validation and automated testing.

These are planned additions, not claims about skills currently included.

## License

Original content in this repository is offered under the MIT License; see [LICENSE](LICENSE).

Third-party content remains subject to its applicable licenses and notices.
