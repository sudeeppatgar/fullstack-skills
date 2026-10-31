---
name: debugging-root-cause
description: Use to reproduce failures, gather evidence, test hypotheses, isolate faults across system boundaries, and identify evidence-supported root causes.
---

# Debugging and Root-Cause Analysis

## Scope and handoffs

Own diagnosis: establish behavior, gather evidence, test competing explanations, trace fault propagation, distinguish causes from symptoms, and propose a proportionate fix. Start with [fullstack-core](../fullstack-core/SKILL.md) when a failure is part of a broader feature task. Hand implementation to the applicable specialist, such as [react-typescript](../react-typescript/SKILL.md), [node-api](../node-api/SKILL.md), [database-prisma](../database-prisma/SKILL.md), [integrations-async-jobs](../integrations-async-jobs/SKILL.md), or [cloud-production-ops](../cloud-production-ops/SKILL.md). Use [testing-quality](../testing-quality/SKILL.md) for broader regression-test strategy.

## Diagnostic workflow

1. **Inspect first.** Read repository instructions, working-tree state, affected code/configuration, recent relevant changes, test setup, and available logs or runbooks. Preserve unrelated work. Confirm environment, versions, deployment/build identity, and reproduction conditions from available evidence; do not assume production matches local development.
2. **Define the failure.** Reproduce it when safe and possible. Record expected versus actual behavior, trigger, frequency, scope, impact, and the narrowest reliable reproduction. If it cannot be reproduced, capture when and where it was observed and what evidence is missing.
3. **Collect evidence safely.** Gather the earliest useful error, sanitized logs, traces, timestamps, correlation/request IDs, relevant metrics, recent changes, inputs, and environment details. Do not expose credentials, private payloads, or unnecessary personal data. Separate collected facts from recollection and assumptions.
4. **Map the path.** Trace the failing operation through the components and boundaries that actually exist: UI/network, API, persistence, external dependency, runtime, or deployment. Identify where expected behavior first diverges. For asynchronous paths, correlate message/job state and delivery attempts when available.
5. **Form hypotheses.** State a small set of plausible explanations and the observation each predicts. Choose safe, discriminating checks; change one variable at a time where practical. Update or reject hypotheses when evidence disagrees instead of guessing or making several speculative fixes.
6. **Classify cause.** Explain the underlying condition that produced the failure, contributing conditions that made it possible or worse, and the user-visible symptom. If evidence only narrows the cause, report it as unresolved rather than certain.
7. **Fix and regress.** Prefer the smallest evidence-supported correction. Add a focused regression test or another repeatable check that exercises the failure condition at the boundary that exposed it. Domain-specific implementation belongs to the relevant specialist skill.
8. **Verify and report.** Re-run the reproduction and relevant focused checks, then broader checks when warranted. Compare outcomes with the original expected behavior. State what was verified, what was skipped or unavailable, and any remaining uncertainty.

## Completion checklist

- Expected and actual behavior, impact, environment, and reproduction conditions are recorded.
- Evidence is sanitized and its source is clear; hypotheses were tested rather than treated as facts.
- The fault path crosses only evidenced components, and cause, contributors, and symptoms are distinguished.
- A proportionate fix and meaningful regression check address the demonstrated condition.
- Verification results, unavailable checks, and remaining uncertainty are reported honestly.

This skill does not install diagnostic tooling, authorize access to production data, or guarantee a root cause when evidence is incomplete.
