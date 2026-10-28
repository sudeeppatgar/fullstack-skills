---
name: rest-api-design
description: Use when defining or reviewing REST resource models, HTTP operations, request and response contracts, errors, pagination, and API compatibility.
---

# REST API Design

Focus on the API contract and its client-facing behavior, independent of a particular server framework. For implementing a Node.js endpoint, use node-api as well; for NestJS-specific structure, use nestjs-development.

## Design workflow

1. Inspect existing API documentation, routes, naming, versioning, error conventions, clients, and compatibility requirements. Ask about missing consumers or requirements that materially affect the contract.
2. Model resources and relationships around domain concepts. Choose HTTP methods and status codes that express the operation and its result; keep request and response shapes consistent with existing conventions.
3. Specify required fields, validation failures, authorization expectations, error responses, pagination/filtering for potentially large collections, and idempotency or concurrency behavior when relevant.
4. Consider compatibility for existing clients, including additive versus breaking changes and rollout order. Document concrete examples and edge cases; label unresolved decisions rather than inventing requirements.
5. Review the proposed contract with affected clients and implementation constraints. If code changes are requested, verify that implementation and tests match the documented contract.

## Completion checklist

- Resources, methods, inputs, outputs, and errors are explicit and consistent.
- Validation, access expectations, and collection behavior are addressed where relevant.
- Compatibility risks and unresolved assumptions are recorded.
- Examples and verification correspond to the target project's conventions.

This skill does not prescribe a server framework or install API tooling.
