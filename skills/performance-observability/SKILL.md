---
name: performance-observability
description: Use to diagnose performance with baselines, profiling, system measurements, and safe observability practices, and to verify changes against evidence.
---

# Performance and Observability

## Scope and handoffs

Own measurement-led performance diagnosis, profiling, instrumentation choices, and regression verification. Begin with [fullstack-core](../fullstack-core/SKILL.md) for cross-layer task coordination. Hand UI implementation to [react-typescript](../react-typescript/SKILL.md), database/query implementation to [database-prisma](../database-prisma/SKILL.md), service implementation to [node-api](../node-api/SKILL.md), and architecture tradeoffs to [system-design](../system-design/SKILL.md). Use [debugging-root-cause](../debugging-root-cause/SKILL.md) when the task is primarily fault isolation.

## Measurement workflow

1. **Inspect first.** Read repository instructions and worktree state; identify the affected user journey, runtime, existing telemetry/profilers, performance tests, deployment shape, and relevant dependency boundaries. Use only tools and environments actually available.
2. **Set a target and baseline.** Define a user- or system-relevant measurable target, workload, environment, and time window before optimization. Measure an appropriate baseline, such as latency percentiles, throughput, error rate, CPU/memory/network/database use, and user-visible rendering or interaction delay. Record sample size and conditions; distinguish measurements from estimates.
3. **Profile before editing.** Reproduce the representative workload and use an available profiler, trace, query plan, browser/network inspection, or other appropriate diagnostic to locate the bottleneck. Consider frontend render and network behavior, API execution, database queries, cache behavior, serialization, and downstream dependencies as applicable. Do not optimize by intuition alone.
4. **Instrument carefully.** Prefer existing structured logs, metrics, traces, and correlation/request identifiers. Add only signals needed to answer a concrete diagnostic question. Check metric label cardinality, sensitive data exposure, instrumentation overhead, sampling, and retention implications. Never put credentials, raw sensitive payloads, or high-cardinality user identifiers into metric labels.
5. **Make a focused change.** Address the measured bottleneck with the smallest viable change. Avoid adding monitoring infrastructure, caches, dependencies, or broad refactors absent evidence and need. Check that correctness, resource bounds, and failure behavior remain intact.
6. **Compare fairly.** Repeat the baseline workload under comparable conditions and compare the same metric, percentiles, sample, and time window. Check errors and resource costs as well as latency; report measured results with methodology and limitations. Separate observed outcomes from hypotheses about other workloads.
7. **Guard against regressions.** Add or adapt an existing repeatable benchmark, performance assertion, or operational signal only when it meaningfully detects regression without flaky timing assumptions. Use [testing-quality](../testing-quality/SKILL.md) for test strategy and CI integration.
8. **Report and hand off.** State the measured bottleneck, change, before/after evidence, unavailable checks, and residual uncertainty. If a production symptom remains, coordinate with [cloud-production-ops](../cloud-production-ops/SKILL.md); do not claim an unobserved production improvement.

## Completion checklist

- A target and comparable baseline were established before optimization.
- Profiling or equivalent evidence identified the bottleneck being changed.
- Relevant user-visible, latency, throughput, error, and resource dimensions were considered.
- Instrumentation protects sensitive data and accounts for cardinality, overhead, and retention.
- Improvements and tradeoffs are supported by comparable measurements; estimates and assumptions are labeled.
- Regression verification and exact check outcomes or limitations are reported.

This skill does not install monitoring infrastructure or guarantee performance gains without measurement.
