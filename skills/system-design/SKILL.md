---
name: system-design
description: Use to make or review architecture decisions involving requirements, component boundaries, data flows, quality attributes, capacity assumptions, and trade-offs.
---

# System Design

## Scope

Own architecture decisions and their rationale: requirements, constraints, quality attributes, components, data flows, trade-offs, failure modes, and design artifacts. Do not prescribe microservices, queues, caches, or other infrastructure without a requirement and evidence that the project needs them. For repository-level task orchestration, use [fullstack-core](../fullstack-core/SKILL.md); for API contracts use [rest-api-design](../rest-api-design/SKILL.md).

## Workflow

1. Clarify users, use cases, functional requirements, non-goals, and quality attributes (for example availability, latency, consistency, privacy, or cost). Record constraints such as existing platforms, operations capacity, and compatibility needs.
2. Inspect available architecture documents, code boundaries, data ownership, deployment model, and operational evidence. Mark what is observed, what is assumed, and what is recommended. List unknowns that could change the design.
3. Map the important components and data flows. Identify trust boundaries, state ownership, external dependencies, synchronous work, and asynchronous work only where applicable.
4. Compare a small set of viable options against stated goals. Explain costs and benefits, failure behavior, operational burden, security/privacy implications, and migration complexity. Do not present one pattern as universally correct.
5. Estimate capacity only when inputs are available. State the formula, input source, time window, range, and uncertainty; e.g. `estimated average requests/second over the defined peak window = expected requests in that window / its duration in seconds`. Treat the result as an estimate to validate, not a measured peak or capacity claim.
6. Recommend a design, record rejected alternatives and reasons, and identify validation, rollout, rollback, and open-question steps proportionate to the change.

## Lightweight design note

```text
Problem and users:
Goals / non-goals:
Constraints (source):
Observed architecture / evidence:
Assumptions and estimates (inputs, formula, uncertainty):
Options and trade-offs:
Recommended components and data flow:
Failure modes and recovery:
Security / privacy considerations:
Rollout and verification:
Open questions:
```

Keep the note concise. Omit sections that do not apply, and label missing evidence instead of filling gaps with guesses.

## Failure-mode example

Suppose account registration triggers a welcome email. A synchronous send can make registration availability and response time depend on the mail provider. An asynchronous handoff can decouple the response, but introduces eventual delivery, retry, duplicate-delivery, and monitoring concerns. Compare these outcomes against the product's delivery requirement and existing operations before recommending either approach. A queue is only one possible handoff if the repository already has suitable infrastructure; do not add one by default. Define what the user sees if delivery is delayed or permanently fails.

## Completion checklist

- Goals, non-goals, constraints, observed facts, assumptions, and estimates are distinguishable.
- Component ownership, important data flows, and relevant trust boundaries are clear.
- Options are compared against goals, including failure modes and operating costs.
- The recommendation, verification/rollout plan, and unresolved questions are recorded.
- No unsupported capacity claim or unnecessary infrastructure requirement is presented as fact.
