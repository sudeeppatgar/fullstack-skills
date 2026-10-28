---
name: nestjs-development
description: Use when implementing, debugging, or reviewing applications built with the NestJS framework and its modules, providers, controllers, guards, pipes, or interceptors.
---

# NestJS Development

This skill covers NestJS-specific structure and framework behavior. For general Node.js API guidance that is not specific to NestJS, use the node-api skill.

## Workflow

1. Inspect the installed NestJS version, package scripts, module boundaries, dependency-injection patterns, transport adapters, validation setup, and existing tests. Follow the project rather than assuming a particular NestJS version or optional package.
2. Trace the request or event through the relevant controller, provider, guard, pipe, interceptor, filter, and persistence boundary. Change only the layers needed.
3. Keep responsibilities explicit: controllers handle transport concerns, providers encapsulate application behavior, and modules declare dependency boundaries. Reuse established guards, DTO validation, exception handling, and configuration patterns.
4. Add or update focused tests using the repository's existing tools. Verify success, validation, authorization, and failure paths relevant to the change; run available type checks, lint, and tests.

## Completion checklist

- The implementation follows the installed NestJS version and local module conventions.
- Dependency injection and request lifecycle behavior are correct for the affected path.
- Validation and authorization use established project mechanisms.
- Relevant tests and checks ran, with unavailable checks identified.

This skill does not install NestJS, adapters, modules, or other dependencies.
