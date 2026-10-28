---
name: nestjs-development
description: Use when implementing, debugging, or reviewing NestJS applications, modules, providers, dependency injection, or NestJS request handling.
---

# NestJS Development

## Scope and handoffs

Own NestJS-specific structure and runtime integration: modules, providers, dependency injection, the configured request lifecycle, validation, exception handling, configuration, and framework-level tests. For framework-neutral Node.js request and service concerns, use [node-api](../node-api/SKILL.md). For client-visible HTTP contract decisions, use [rest-api-design](../rest-api-design/SKILL.md). Keep those contracts and general service rules out of this skill unless NestJS behavior changes their implementation.

## Inspect before changing

1. Read repository instructions, working-tree state, package manifest and lockfile. Identify installed `@nestjs/*` versions, Node.js and TypeScript versions, HTTP adapter or other transport, bootstrap setup, test commands, and any relevant modules. Do not infer versions from examples found online.
2. Trace the target route or message through its module and provider graph. Inspect where middleware, guards, interceptors, pipes, filters, and configuration are actually registered. A component may be absent, bound at a different scope, or replaced by project-specific code.
3. Separate observed behavior from assumptions and recommendations. Check project-specific conventions and the official NestJS documentation matching the installed version before using version-sensitive APIs or lifecycle details.

## Trace a request

For a configured HTTP application, NestJS documents a common flow through applicable middleware, guards, interceptors, pipes, the route handler and its providers, and the interceptor response path. If an exception remains uncaught, normal processing stops and the applicable exception filter may handle it; a locally caught exception does not reach a filter. This is a tracing aid, not a promise that every request runs every component or that every adapter, transport, binding, or custom configuration behaves identically.

For the affected operation:

1. Find route selection and any middleware that transforms or rejects the request.
2. Identify guards that authenticate or authorize it. Check their actual binding scope and whether a guard short-circuits the handler.
3. Identify interceptors that wrap execution or transform results/errors, and pipes that validate or transform the specific bound parameters.
4. Follow the controller to injected providers and downstream boundaries. Do not assume a service or database exists for every route.
5. Identify exception filters that can catch uncaught failures at the relevant scope, and the application's public error contract.
6. Compare the traced path with the relevant unit, integration, or end-to-end tests.

When ordering matters, check the version-appropriate NestJS request-lifecycle documentation and the actual adapter/transport configuration. WebSocket, RPC, hybrid, and custom-adapter paths may have different context and error mapping.

## Framework implementation workflow

- **Modules and DI:** Keep providers registered in the modules that own them; trace `imports`, `providers`, and `exports` when resolving a dependency. Reuse established provider tokens and scopes. Investigate a missing provider or circular dependency before adding another module or constructing providers manually.
- **Validation:** Find the configured global, controller, route, and parameter pipes and the DTO/schema conventions already used. Ensure the chosen validation mechanism actually runs for this parameter and rejects or transforms input as intended. Do not add a validation package or global behavior without a project requirement.
- **Exceptions:** Preserve the existing exception/filter mapping and response format. Distinguish expected domain failures from unexpected errors; do not expose stack traces, secrets, or internal database messages to clients.
- **Configuration:** Trace how values are loaded, validated, and injected in each environment. Use existing configuration modules or factories; fail clearly on missing required settings. Never print or commit credential values.
- **Tests:** Use the repository's existing test setup. Exercise the provider/service behavior at unit level where useful, and the configured application adapter for route-level behavior. Include relevant validation, denial, not-found, dependency-failure, and exception-mapping cases without replacing real boundary coverage with mocks alone.

## Example: updating a project task

For `PATCH /projects/:projectId/tasks/:taskId`, first inspect how this app registers the route and its validation/auth components. Trace the project/task identifiers and update body through the actual bound pipes; verify where caller identity is established and which configured guard/provider enforces permission for this specific project. The controller should follow local conventions and delegate the update to its injected provider. That provider applies domain rules and calls the existing data boundary; if it uses Prisma, hand schema/query/migration decisions to [database-prisma](../database-prisma/SKILL.md). Existing interceptors may wrap timing or response mapping, and a filter may shape an uncaught failure. Do not assume these components exist: confirm each one in the module/bootstrap configuration.

Verify a successful update and response against the established contract, invalid input at the actual pipe boundary, denied access for an authenticated but unauthorized caller, missing task behavior, and the relevant provider failure. Use the test adapter configured by the project; do not assume Express or Fastify.

## Debugging and recovery

- **Route not reached:** Verify route registration, module imports, adapter/transport, and startup logs before changing controller code.
- **Dependency resolution fails:** Check the provider token, owning module registration, exports/imports, scopes, and any circular dependency; preserve the original error details in protected diagnostics.
- **Request rejected unexpectedly:** Identify the guard or pipe that stopped the request and inspect its bound scope, metadata, input transformation, and configured error response.
- **Failure response differs:** Trace whether the error is caught in application code, an interceptor, or a filter, and check the filter binding scope and transport.
- **Configuration fails at startup:** Inspect variable names and validation rules without printing values; verify environment-specific configuration and required-setting behavior.
- **Test disagrees with runtime:** Confirm the test creates the same module graph and adapter configuration relevant to the behavior. Report remaining differences rather than assuming the test proves production behavior.

## Completion checklist

- The recommendation matches the installed NestJS/Node versions and configured adapter or transport.
- Module ownership, DI, lifecycle components, and response/error behavior are verified for the affected path.
- Validation, authorization, configuration, and failure cases use existing project conventions.
- Relevant tests and checks ran; outcomes and unverified behavior are reported.
- No credentials were exposed and no unnecessary dependencies or unrelated changes were introduced.
