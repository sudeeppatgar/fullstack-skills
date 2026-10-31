---
name: cloud-production-ops
description: Use when planning or diagnosing production configuration, releases, deployment verification, incidents, rollback, or recovery.
---

# Cloud and Production Operations

## Scope, authorization, and handoffs

Own safe operational planning and verification for deployment, production configuration, incidents, rollback, and recovery. Begin with [fullstack-core](../fullstack-core/SKILL.md) for overall task coordination. Hand pipeline design to [ci-cd](../ci-cd/SKILL.md), container build/runtime procedures to [docker-devops](../docker-devops/SKILL.md), database migration implementation to [database-prisma](../database-prisma/SKILL.md), and architecture/recovery tradeoffs to [system-design](../system-design/SKILL.md).

Production-impacting or destructive operations require explicit authorization for the specific action and target. Never expose secrets, disable safeguards, or run destructive commands without approval. Read-only inspection must still follow access policy and avoid disclosure of sensitive values.

## Operational workflow

1. **Inspect first.** Read repository instructions, worktree state, hosting/runtime and infrastructure configuration, deployment strategy, CI/release policy, environment examples, health checks, runbooks, and recovery documentation. Establish target, artifact/version, access path, and which commands are actually supported; do not infer a cloud provider or deployment design.
2. **Check readiness.** Verify required configuration names and validation behavior without printing values; confirm secrets come from the intended secret mechanism. Check health/readiness semantics, dependency availability, capacity/limits relevant to the release, and compatibility with currently running versions. Keep least privilege and blast radius in view.
3. **Plan release and stop conditions.** Identify the artifact or revision, rollout stages, release verification signals, acceptable error/latency/health thresholds if defined, observation window, and criteria to stop or roll back. Confirm the prior artifact and rollback procedure are available. Hand pipeline mechanics to `ci-cd` and container-specific checks to `docker-devops`.
4. **Review data implications.** For database changes, establish migration compatibility with old and new application versions, backup status, restore implications, locks/backfills, and recovery strategy with `database-prisma`. A code rollback does not reverse a schema change or restore deleted data. Do not run migrations or alter persistent data without the required authorization and safeguards.
5. **Respond to incidents.** Assess user impact, scope, timeline, and confidence from available evidence. Stabilize or mitigate using the least risky authorized action; preserve diagnostic evidence and avoid speculative changes. Communicate status, impact, known facts, and next update through the established channel. Verify recovery with user-facing and system signals, then record follow-up owners and actions. Use [debugging-root-cause](../debugging-root-cause/SKILL.md) for evidence-led cause analysis and [performance-observability](../performance-observability/SKILL.md) for measurement.
6. **Execute only with authority.** Before production-impacting changes, verify the exact target, scope, user authorization, safeguards, and rollback/recovery path. If any are unclear, stop and request clarification. Never bypass approvals, disable health checks or access controls, expose credentials, or issue destructive commands without explicit approval.
7. **Verify the actual result.** Observe the deployed version, health/readiness, relevant smoke checks, error/performance signals, and dependencies using approved procedures. Distinguish local/staging evidence from production evidence. Report exact checks completed, failed, skipped, or unavailable and any residual risk.

## Completion checklist

- Hosting, configuration, deployment, and recovery conventions were verified from the repository/environment evidence.
- Secrets and access followed approved boundaries; readiness, dependencies, and least privilege were considered.
- Release verification, rollback criteria, and migration/backup implications are explicit where applicable.
- Production-impacting steps had specific authorization and an appropriate recovery plan.
- Incident impact, mitigation, communication, recovery verification, and follow-up are documented as applicable.
- Deployed behavior and exact checks are reported honestly, with unavailable evidence and assumptions identified.

This skill does not grant production access, authorize destructive operations, or guarantee availability or recovery.
