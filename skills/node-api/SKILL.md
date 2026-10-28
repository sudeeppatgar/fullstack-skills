---
name: node-api
description: Use when implementing or reviewing framework-neutral Node.js services and request handling, including validation, authorization integration, errors, resource limits, and observability.
---

# Node.js Service and API Implementation

## Scope

Own framework-neutral Node.js service implementation: request processing, integration of authentication and authorization, validation, error handling, dependency timeouts, resource limits, logging, and observability. Delegate HTTP contract choices to [rest-api-design](../rest-api-design/SKILL.md), and NestJS-specific modules and request lifecycle to [nestjs-development](../nestjs-development/SKILL.md). For a dedicated security assessment, use [security-review](../security-review/SKILL.md).

## Inspect first

1. Read repository instructions, the current working-tree state, package manifests, and lockfiles. Identify the Node.js version, framework and version, server adapter, middleware/plugins, test tooling, and deployment boundary from evidence.
2. Trace the target request through parsing, middleware, route/controller, application/service logic, data or external dependencies, and error mapping. Find existing conventions for validation, authentication, authorization, limits, logs, and responses.
3. Confirm the endpoint's contract with its docs or owner. Separate observed facts, assumptions, recommendations, and unverified behavior. If a gap affects security or behavior, ask or mark it unresolved; do not add a framework, auth scheme, or library by default.

## Request-processing workflow

For a protected operation, keep identity and permission checks distinct. A typical path is:

1. Enforce parser constraints already supported by the framework or server boundary (for example accepted content type and body size) before expensive work. Bound request duration, dependency time, and concurrency at the layer that can actually enforce them. Do not assume that framework defaults meet the application's needs.
2. Parse and validate parameters, headers, and body using the project's existing validation approach. Reject invalid input before side effects; avoid logging raw bodies.
3. Authenticate when the route requires it: establish the caller's identity from the configured credential/session mechanism. Authentication does not prove permission to perform the requested action.
4. Authorize that identity for the action and specific resource, using server-side checks. Apply the project's policy for missing, denied, or deliberately concealed resources.
5. Run business logic with explicit dependency boundaries. Bound external calls with project-supported timeouts, handle cancellation where available, and set request, concurrency, rate, or payload limits according to product and deployment evidence.
6. Map expected validation, authentication, authorization, conflict, and dependency failures to the documented public contract. For unexpected failures, return the established generic error response; do not expose stack traces or internal details.
7. Emit useful structured operational events using existing logging/telemetry facilities: route template, outcome, duration, safe error category, and a request/correlation ID if available. Exclude credentials, tokens, raw request bodies, and unnecessary personal data. Verify that logs make failure diagnosis possible without disclosing protected data.

## Example: `POST /reports`

When the project has a JSON endpoint at this route, trace a request in order: parser enforces its configured size limit; schema validation checks required fields; authentication identifies the caller; authorization checks access to the selected organization; service logic requests the report; dependency failure is mapped to the API's documented safe error; logs record the route, outcome, duration, and correlation ID without the submitted body or credentials. Adapt this sequence to actual middleware order and contract. If report creation has side effects, inspect idempotency and retry behavior before retrying failures automatically.

| Failure | Handling to verify |
|---|---|
| Invalid shape or oversized body | Rejected at the appropriate boundary; no service side effect. |
| No valid identity | Protected operation stops before business logic. |
| Identity lacks permission | Resource/action authorization denies it; do not treat authentication as authorization. |
| Dependency timeout or overload | Bounded failure, safe response, useful sanitized telemetry, and no unsafe automatic retry. |
| Unexpected exception | Generic public response; internal details remain in appropriately protected diagnostics. |

Status codes and response shapes are contract decisions; coordinate them with `rest-api-design` and existing API conventions rather than duplicating that design here.

## Verification and completion

- Test valid requests, malformed and boundary input, unauthenticated callers, authenticated-but-forbidden callers, and relevant dependency failures.
- Verify limits and timeouts at the layer that actually enforces them; do not infer behavior from configuration names alone.
- Check that public responses do not leak internals and logs contain diagnostic context without secrets or unnecessary personal data.
- Run existing focused tests, type checks, lint, and builds where available. Report exact results and checks not run.
- Confirm the implementation matches the agreed contract and introduces no unrequested dependencies or side effects.

This skill does not install Node.js, frameworks, authentication systems, logging tools, or MCP servers.
