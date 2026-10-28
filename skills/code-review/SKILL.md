---
name: code-review
description: Use when reviewing a proposed change for correctness, regressions, security implications, data integrity, compatibility, or missing verification.
---

# Code Review

## Scope

Review a proposed change and its relevant context; do not implement or rewrite it unless asked. Prioritize concrete defects and risks introduced by the change. For a focused application-security assessment, hand off to [security-review](../security-review/SKILL.md); use the relevant domain skill for implementation context, such as [rest-api-design](../rest-api-design/SKILL.md), [database-prisma](../database-prisma/SKILL.md), or [testing-quality](../testing-quality/SKILL.md).

## Review workflow

1. **Understand intent and scope.** Read repository instructions, the requested behavior, acceptance criteria, and any relevant issue/design notes. If intent is unclear and affects correctness, identify the question rather than inventing requirements.
2. **Inspect the complete change.** For Git changes, check `git status --short`, `git diff`, and `git diff --cached`; inspect relevant untracked files and compare to the correct base. Read surrounding code, not just changed lines. Preserve unrelated work.
3. **Trace behavior.** Follow changed data/control flow through callers, consumers, boundaries, and error paths. Check affected API contracts, persistence/data integrity, auth decisions, async ordering/cancellation/retries, cleanup/resource lifecycle, and backward compatibility where relevant.
4. **Evaluate verification.** Identify which tests were added or changed, what behavior they actually assert, and which important cases remain uncovered. Run focused existing checks when useful and available; report results only after observing them.
5. **Validate candidate findings.** Confirm the conditions and impact from code, tests, or safe local reproduction. Distinguish observed facts from assumptions and possible risks. Do not report speculative style preferences, unsupported security claims, or issues unrelated to the diff as defects.
6. **Report findings first.** Order actionable findings by impact and exploitability, using the repository's severity scale if one exists. If none are confirmed, say so and list relevant review limits or unresolved questions.

## Priorities to examine

- Correctness, regressions, boundary and negative cases, and unintended behavior changes.
- Data integrity, transaction boundaries, migration compatibility, and destructive operations.
- Security boundaries: authentication versus authorization, untrusted input, secrets, and sensitive data exposure. Use security-review for a dedicated security sweep.
- Public API/client compatibility, error semantics, and assumptions shared across callers.
- Async failures, timeouts, cancellation, retries, races, and cleanup of resources/listeners/temporary state.
- Whether tests exercise the changed behavior and meaningful failure cases rather than only implementation details.

Not every category applies to every diff. Explain relevant omissions instead of expanding the review into unrelated system audits.

## Finding format

Use a concise finding with:

```text
[Severity] Short issue title — path/to/file.ext:line
Scenario: the conditions that trigger the behavior.
Impact: the concrete user, data, security, or compatibility consequence.
Evidence: the relevant code path or test gap.
Suggested direction: a proportionate fix or verification step.
```

Point to the narrowest useful line or range in the changed code. Separate a confirmed bug from a risk that needs evidence. Use optional suggestions for maintainability improvements that are not defects, and do not mix them into blocking findings.

### Finding quality examples

**Strong, actionable:** “The retry path repeats the charge — `src/orders/submit.ts:84`. If the database write fails after the payment provider accepts the request, this retry sends a second charge because the provider call has no stable idempotency key. Reuse a request-level idempotency key and test the provider-success/database-failure path.” This states scenario, impact, evidence, and a fix direction.

**Weak, not actionable:** “Payment handling seems wrong; please improve error handling.” It names no path, condition, evidence, or impact. Investigate further or report it as an open question rather than a finding.

These examples illustrate report structure only; they are not claims about this repository.

## Completion checklist

- The intended behavior, base, complete diff, and relevant context were inspected.
- Findings are tied to changed code, have concrete scenarios and impacts, and are ranked using project conventions where available.
- Confirmed defects, unverified risks, questions, and optional improvements are clearly distinguished.
- Tests/checks and remaining verification gaps are reported accurately.
- No unnecessary rewrite, unrelated refactor, or unsupported claim was introduced.
