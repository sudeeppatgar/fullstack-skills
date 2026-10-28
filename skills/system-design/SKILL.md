---
name: system-design
description: Use when exploring or evaluating system architecture, component boundaries, data flows, scalability, reliability, and design tradeoffs.
---

# System Design

Use this skill for architecture decisions and tradeoff analysis, not routine repository orientation or step-by-step feature implementation. Inspect the target system and distinguish observed facts from assumptions.

## Design workflow

1. Clarify functional requirements, users, constraints, and quality goals such as availability, latency, consistency, privacy, or cost. Quantify only what the requester or repository supports; mark estimates as assumptions.
2. Inspect existing architecture, interfaces, data ownership, deployment model, and operational constraints before proposing components or technologies.
3. Map the main request/data flows and component responsibilities. Identify state boundaries, synchronous and asynchronous work, external dependencies, and trust boundaries as applicable.
4. Compare a small number of viable designs against the stated goals. Explain tradeoffs, failure modes, scaling limits, consistency choices, security concerns, and operational costs without presenting one option as universally best.
5. Recommend a design with rationale, key risks, open questions, and a staged verification or migration approach. Avoid prescribing new infrastructure until its need and fit are established.

## Completion checklist

- Requirements, constraints, observed facts, and assumptions are separated.
- Components, ownership, and important flows are understandable.
- Tradeoffs and relevant failure/security/operational concerns are explicit.
- Recommendation, risks, open questions, and next verification steps are recorded.

This skill does not install infrastructure or guarantee capacity, reliability, or production readiness.
