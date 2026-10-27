---
name: security-review
description: Use when reviewing full-stack code for common security issues, authentication and authorization mistakes, unsafe input handling, secrets exposure, and risky configuration.
---

# Application Security Review

## Review scope

Inspect relevant code, configuration, dependencies, and data flows. Prioritize concrete, exploitable risks over speculative style concerns.

## Check for

- Missing or inconsistent authorization checks.
- Trusting client-side checks for protected actions.
- Injection risks and unsafe query construction.
- XSS risks and unsafe HTML rendering.
- Secret or token exposure in source, logs, responses, and frontend bundles.
- Weak password handling or unsafe session/token storage.
- Unsafe file uploads and path handling.
- Excessive data returned from APIs.
- Misconfigured CORS, cookies, CSRF defenses, or security headers where applicable.
- Missing rate limits on sensitive or abuse-prone endpoints.
- Dependency and container risks when evidence is available.

## Reporting

For each finding, state severity, affected area, evidence, impact, and a practical remediation. Distinguish confirmed issues from questions requiring verification. Do not print discovered secret values; identify the location and recommend rotation when appropriate.

Perform only authorized defensive testing. Do not exploit third-party systems or access data without permission.
