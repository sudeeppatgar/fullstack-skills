---
name: fullstack-core
description: Use to orient in a repository, plan and coordinate cross-layer changes, integrate specialized work, and verify completed features.
---

# Full-Stack Core

## Scope

Own cross-layer orchestration: understand the repository, map a request to affected components, coordinate focused skills, integrate changes, and report verification. Delegate detailed domain decisions rather than repeating every specialty checklist. For architecture trade-offs use [system-design](../system-design/SKILL.md); for API contracts use [rest-api-design](../rest-api-design/SKILL.md), and for implementation use the relevant [node-api](../node-api/SKILL.md), [nestjs-development](../nestjs-development/SKILL.md), [database-prisma](../database-prisma/SKILL.md), or [react-typescript](../react-typescript/SKILL.md) guidance.

## Workflow

1. Read repository instructions and inspect the working tree before editing. Identify the app structure, relevant package manifests and versions, configuration, tests, and CI checks. Preserve unrelated user changes.
2. Clarify behavior and constraints. Separate observed facts from assumptions, recommendations, and questions; do not invent architecture, dependencies, or requirements.
3. Map the feature through only the layers that exist in this repository. Identify ownership, boundaries, contracts, data flow, and failure states. Ask a focused question if an uncertainty changes security, data integrity, architecture, or user-visible behavior.
4. Make a concise plan. Split work by responsibility and use a focused skill when its domain applies. Avoid duplicating its detailed rules or making unrelated changes.
5. Implement and integrate the smallest coherent change. Check that contracts and behavior agree across affected components, including error, loading, empty, and recovery paths where applicable.
6. Run the narrowest relevant tests and checks, followed by broader checks when appropriate. Compare observed results with the acceptance criteria; do not claim unrun checks passed.
7. Report changes, checks and outcomes, assumptions, unresolved risks, and next steps.

## Example: saved project filter

For a request to let a user save a filter, first trace the existing filter UI and state. If the app has an API, map the client action to a documented operation and delegate contract details to `rest-api-design`; route implementation to `node-api` or `nestjs-development` as appropriate. If saved filters persist, inspect the actual data layer and use `database-prisma` only if that project uses Prisma. Identify relevant UI, API, persistence, and integration tests from existing test conventions. If the app has no API or database, adapt the plan to its actual storage and boundaries rather than adding those layers by assumption.

| Layer | Question to answer | Evidence to verify |
|---|---|---|
| UI/state | How is the current filter represented, submitted, and restored after failure? | Existing state conventions and behavior tests. |
| API (if present) | What operation and response contract does the client use? | Route/docs and contract or integration tests. |
| Persistence (if present) | Who owns the saved filter and how is it stored? | Existing schema/data-access patterns and relevant tests. |
| Integration | Does a save, reload, and failed save behave coherently end to end? | The narrowest existing cross-layer test or documented manual check. |

## Completion checklist

- Affected layers and their owners are identified; absent layers were not invented.
- Assumptions and decisions that affect behavior are visible.
- Cross-layer contracts, failure behavior, and user-facing states are coherent.
- Relevant checks actually ran, and their results and remaining uncertainty are reported.
- No secrets were exposed and unrelated work was preserved.
