---
name: code-review
description: Use when reviewing a change set for correctness, regressions, maintainability, and missing verification before it is merged.
---

# Code Review

Review the proposed change and its relevant context; do not rewrite it unless asked. Focus on concrete issues introduced by the change. For a dedicated application-security assessment, use the security-review skill.

## Review workflow

1. Inspect the diff, surrounding code, repository guidance, and relevant tests. Establish the intended behavior from the change and available context.
2. Trace changed behavior through affected callers, data, error paths, and interfaces. Check edge cases, compatibility, failure handling, and unintended scope changes.
3. Run focused existing checks when useful and available. Do not assume tests passed or that an issue is confirmed without evidence.
4. Report actionable findings first. For each finding, give severity, file and line, the failure scenario or impact, and a concise rationale. Separate verified findings from questions; state clearly when no actionable findings were found.

## Completion checklist

- Findings are specific, reproducible or clearly qualified, and tied to changed code.
- Each finding explains impact and location without speculative style preferences.
- Relevant checks and any unverified areas are reported.
- No code was changed as part of review unless implementation was requested.

This skill does not replace specialized security, performance, or domain reviews.
