---
name: security-review
description: Use when assessing application code or configuration for security risks involving sensitive data, trust boundaries, authentication, authorization, input handling, secrets, or dependencies.
---

# Application Security Review

## Scope and authorization

Review repository code, configuration, dependencies, and tests for concrete security risks. Perform only authorized defensive analysis. Do not probe or exploit third-party systems, access data without permission, or include secret values or unnecessary exploit detail in a report. This skill assesses security; it does not certify that a system is secure. For general correctness and maintainability findings on a diff, hand off to [code-review](../code-review/SKILL.md). For implementation changes, use the relevant [react-typescript](../react-typescript/SKILL.md), [node-api](../node-api/SKILL.md), [nestjs-development](../nestjs-development/SKILL.md), [rest-api-design](../rest-api-design/SKILL.md), or [database-prisma](../database-prisma/SKILL.md) guidance.

## Review workflow

1. **Establish scope.** Read repository instructions, the requested review scope, current diff or affected components, and relevant threat/architecture documentation. Identify what is in scope and what is not; preserve unrelated work.
2. **Map boundaries and data.** Trace sensitive data from source through UI, network, services, persistence, logs, and external dependencies as relevant. Mark trust boundaries, privileged operations, user-controlled inputs, and where authorization decisions are enforced.
3. **Inspect evidence.** Review the code and configuration at those boundaries, applicable dependency manifests/lockfiles, and relevant tests. Separate observed facts, assumptions, potential risks, and confirmed behavior. Do not infer a vulnerability solely from a pattern name or a tool alert.
4. **Check applicable risks.** Use the focused checks below; skip irrelevant areas and explain why an area could not be assessed rather than assuming it is safe.
5. **Validate each candidate.** Trace the complete path and conditions needed for impact. Use existing tests or safe, local, authorized checks to confirm or disprove the concern. Do not access real user data or execute destructive actions to prove a point. If evidence is incomplete, report a question or unverified concern, not a confirmed vulnerability.
6. **Prioritize and recommend.** Order confirmed findings by potential impact, exploitability, affected boundary, and confidence. Suggest proportionate remediation and a way to verify the fix; explain trade-offs or remaining exposure.
7. **Report clearly.** Give location, evidence, prerequisites, impact, confidence/status, remediation, and verification for each finding. If none are confirmed, say what was reviewed and what remains unverified; never claim the repository is secure because a checklist was completed.

## Focused checks

### Authentication and authorization

- Distinguish **authentication** (establishing who or what is making a request) from **authorization** (whether that identity may perform this action on this resource). Verify both where required.
- Trace server-side checks for object/tenant ownership, role or policy changes, background jobs, and alternate routes. Client-side visibility controls do not enforce access.
- Check unauthenticated, authenticated-but-forbidden, cross-user/resource, and privilege-change cases using test identities or fixtures. Avoid using real accounts or data.

### Inputs, data, and outputs

- Identify untrusted inputs at HTTP, message, file, database, and third-party boundaries. Check validation, safe query construction, encoding, file/path handling, size limits, and failure behavior as applicable.
- Trace sensitive fields through responses and UI rendering. Check for over-broad data exposure, unsafe HTML handling, and leakage through URLs or errors.
- For APIs using browser cookies or cross-origin requests, inspect the actual CSRF, CORS, cookie, and origin policy rather than applying a generic setting.

### Secrets and logs

- Check tracked files, configuration paths, build/deploy settings, logs, and client bundles for credentials or tokens. Never repeat a discovered value in output; report only the file/location and secret type.
- Verify that logs and error responses exclude credentials, tokens, raw sensitive payloads, and unnecessary personal data while retaining enough context for diagnosis.
- If an exposed credential appears live, recommend treating it as compromised and follow the repository's incident process for rotation and scope assessment. Do not rotate it or contact a service unless authorized.

### Dependencies and boundaries

- Inspect the actual manifests and lockfiles, dependency versions, update context, and available repository evidence. Distinguish a documented advisory or reproducible issue from a scanner match whose reachability or impact is unknown.
- Check frontend and backend responsibilities separately: frontend code and client-side checks are visible and controllable by users; sensitive authorization and data decisions must be enforced at the trusted server/data boundary.
- Assess third-party service, container, and deployment concerns only when the relevant configuration and evidence are in scope. Do not add scanning tools or claim that an uninspected dependency set is safe.

## Example: review a project-task update

For `PATCH /projects/:projectId/tasks/:taskId`, trace the caller identity to its authentication mechanism, then trace the permission check for that specific project and task to a server-side decision. Follow route parameters and body fields through validation into the update query; confirm the query constrains the target by the authorized project/task rather than trusting a client-supplied owner. Check the response fields and logs for data the caller should not see. Use existing tests with a permitted user, an authenticated user from another project, a missing task, and invalid input. A mocked authorization helper alone does not prove the route applies it; add or inspect a route/service integration test using the project's existing setup. Do not mutate production data to verify access controls.

## Finding format

```text
Severity / priority and confidence:
Status: confirmed / needs more evidence
Location:
Evidence and required conditions:
Impact:
Recommended remediation:
Verification of the fix:
```

Use the project's severity vocabulary if one exists. Otherwise explain the relative priority using impact and exploitability instead of inventing a numeric score. Keep details sufficient for maintainers to reproduce safely and fix the issue; omit secret values, private data, and unnecessary exploit instructions.

## Completion checklist

- Review scope, trust boundaries, sensitive data flows, and evidence sources are stated.
- Authentication and authorization are assessed separately where relevant.
- Potential findings were validated or explicitly marked as unverified, with confidence and impact explained.
- Remediation is proportionate and includes a safe verification path.
- Sensitive values and user data were not disclosed; any unreviewed areas are clearly reported.
- No claim of overall security is based solely on completing these checks.
