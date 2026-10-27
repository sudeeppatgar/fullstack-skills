---
name: fullstack-core
description: Use for full-stack feature planning, repository orientation, cross-layer changes, debugging, and implementation completion.
---

# Full-Stack Core

## Workflow

1. Inspect repository instructions, project structure, package manifests, Git status, and relevant tests before changing files.
2. Identify frontend, backend, persistence, external services, test tooling, and deployment assumptions.
3. Trace the feature across layers before proposing an implementation.
4. State a concise plan for substantial changes.
5. Follow existing patterns unless there is a concrete reason to change them.
6. Make the smallest coherent set of changes.
7. Run relevant tests, type checks, linting, and builds when available.
8. Report what changed, what checks ran, what failed, and what remains uncertain.

## Engineering principles

- Prefer simple, maintainable solutions over unnecessary abstraction.
- Keep API contracts and data ownership explicit.
- Validate untrusted input at boundaries.
- Avoid unrelated refactors.
- Never invent test results or claim unrun commands passed.
- Do not install dependencies or skills without a clear need.
- Do not expose secrets or copy private data into logs.

## When requirements are unclear

Ask a focused question if a missing requirement materially changes the architecture, security, or user-visible behavior. Otherwise, state a reasonable assumption and proceed.
