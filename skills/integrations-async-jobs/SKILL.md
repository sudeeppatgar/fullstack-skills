---
name: integrations-async-jobs
description: Use when building or troubleshooting external-service integrations, webhooks, queues, scheduled tasks, and background job processing.
---

# Integrations and Asynchronous Jobs

## Scope and handoffs

Own reliability behavior at external-service, webhook, queue, scheduler, and background-job boundaries. Inspect and extend the architecture already present; a broker or queue is not a default requirement. Hand HTTP contract choices to [rest-api-design](../rest-api-design/SKILL.md), server implementation details to [node-api](../node-api/SKILL.md) or [nestjs-development](../nestjs-development/SKILL.md), security assessment to [security-review](../security-review/SKILL.md), and architecture tradeoffs to [system-design](../system-design/SKILL.md). Use [testing-quality](../testing-quality/SKILL.md) for the overall test strategy.

## Workflow

1. **Inspect first.** Read repository instructions and worktree state. Find existing clients, webhook routes, queue/scheduler/job patterns, dependencies, configuration names, deployment/runtime constraints, tests, and operational recovery mechanisms. Do not add a dependency or infrastructure component before establishing a concrete need.
2. **Define the boundary.** Document the actual request, response, event, or job contract; authentication/signature boundary; ownership of each secret; timeout and cancellation behavior; expected outcomes; and what callers/users observe on failure. Hand API semantics to `rest-api-design` where needed.
3. **Classify failures.** Distinguish retryable transient failures (only when evidence and contract support retry) from permanent validation, authorization, or business failures. Bound attempts and total elapsed time; use backoff and jitter where appropriate and honor provider rate limits or retry guidance when available. Avoid retrying unsafe side effects without deduplication.
4. **Make repetition safe.** Determine whether duplicate delivery or job execution is possible. Use a stable idempotency key or durable deduplication where the operation requires it; verify the actual storage/atomicity boundary. Define ordering requirements and what happens when events arrive late or out of order. Do not claim exactly-once delivery unless the complete system actually guarantees it.
5. **Validate inbound events.** Where supported by the provider contract, verify webhook signatures over the required raw bytes and reject invalid or stale requests before side effects. Validate payload shape, size, event type, and relevant replay/duplicate handling. A secret token comparison or parsed-body check is not a substitute for the provider's specified signature procedure.
6. **Design job lifecycle.** Where the architecture exposes job state, define meaningful queued/running/succeeded/failed/cancelled states, safe concurrency, lease/lock expiry behavior, cancellation points, and recovery after partial work. Use a dead-letter or failure-recovery path only if supported; make replay deliberate and idempotent. Treat a scheduled task and an external side effect as independently fallible.
7. **Protect data and observe behavior.** Use existing logs/metrics/traces to report safe operation identifiers, attempt number, duration, outcome, and correlation IDs where available. Never log credentials, signatures, or sensitive payloads. Avoid introducing high-cardinality or sensitive labels; coordinate deeper instrumentation with [performance-observability](../performance-observability/SKILL.md).
8. **Test failure behavior.** Use existing test boundaries to cover applicable timeouts, retry classification/limits, duplicate messages, malformed or invalidly signed payloads, rate limiting, partial side effects, cancellation, and downstream failures. Use doubles for controlled failures and real boundaries where actual serialization, signature, or persistence semantics are the claim.
9. **Verify and report.** Run focused and relevant broader checks. Report what delivery/recovery behavior is established by code and tests, what depends on external configuration, and what was not verified.

## Completion checklist

- Existing integration patterns and actual infrastructure informed the design; no queue/broker was added by default.
- Contracts, timeouts, auth boundary, failure outcomes, and retryable/permanent errors are explicit.
- Duplicate delivery, idempotency, ordering, rate limits, concurrency, cancellation, and partial failure were addressed where relevant.
- Secrets and sensitive payloads are excluded from logs; instrumentation reflects supported architecture.
- Meaningful failure cases were tested and actual check results, limitations, and assumptions are reported.

This skill does not install a broker, promise delivery guarantees unsupported by the system, or authorize calls to live external services.
