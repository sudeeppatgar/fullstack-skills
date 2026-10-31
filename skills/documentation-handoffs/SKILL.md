---
name: documentation-handoffs
description: Use when documenting changed behavior, setup, contracts, operational knowledge, decisions, or implementation and ownership handoffs.
---

# Documentation and Handoffs

## Scope and handoffs

Own useful, maintainable documentation that transfers verified implementation and operational knowledge. Begin with [fullstack-core](../fullstack-core/SKILL.md) for repository-level change coordination. Hand API semantics to [rest-api-design](../rest-api-design/SKILL.md), architecture decision records to [system-design](../system-design/SKILL.md), and release/incident procedures to [cloud-production-ops](../cloud-production-ops/SKILL.md). Update documentation with the behavior or contract change it explains; avoid writing docs for trivial changes that need no durable explanation.

## Workflow

1. **Inspect first.** Read repository instructions and worktree state, then locate existing README files, docs, runbooks, API specs, configuration examples, decision records, ownership conventions, and link style. Prefer the existing authoritative location and format.
2. **Identify the reader and need.** Decide who needs the information and what they must accomplish: set up, configure, invoke, troubleshoot, operate, or take ownership. Keep the scope focused and link to authoritative internal material instead of duplicating large overlapping sections.
3. **Gather verified facts.** Inspect actual manifests, scripts, configuration loading, routes/contracts, code behavior, tests, and operational procedures. Document only supported commands, paths, variables, endpoints, failure modes, and guarantees. Use placeholders for secret values; never include real credentials. Mark assumptions, environment-specific differences, and unresolved questions explicitly.
4. **Write for safe use.** Include prerequisites and setup steps where relevant; list configuration variable names and whether required/optional only when verified; explain expected behavior, errors, limitations, recovery, or escalation where useful. Call out authorization and data-impact boundaries for operational instructions. Do not invent defaults or imply that an illustrative example is verified.
5. **Capture durable decisions and handoffs.** Record significant architectural choices with context and consequences using the repository's decision-record convention, if present. For procedures or implementation handoffs, include relevant ownership, current state, safe next action, and evidence needed; omit unnecessary process for a small change.
6. **Verify the document.** Check changed paths, local Markdown links, names, examples, and commands against the repository where feasible. Run documented commands only when safe and appropriate; do not execute a destructive or production-impacting example to prove it. Clearly label instructions that could not be verified.
7. **Keep it aligned.** Review related docs for contradictions or stale instructions, update the narrowest authoritative source, and report changed docs and remaining gaps alongside code checks.

## Completion checklist

- Existing documentation conventions and authoritative locations were followed.
- Behavior/configuration/contracts match inspected code; unknowns and assumptions are labeled.
- Examples use verified paths and commands where feasible, and secrets are placeholders only.
- Relevant docs were updated with behavior changes without unnecessary duplication or files.
- Links, examples, and commands were checked where feasible; unverified items are disclosed.
- Handoff or decision context is durable and proportionate to its maintenance value.

This skill does not guarantee documentation is current in environments or repositories that could not be inspected.
