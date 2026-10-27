---
name: node-api
description: Use when implementing or reviewing Node.js services, REST APIs, authentication, validation, error handling, and API integration.
---

# Node.js and REST APIs

## Inspect first

Identify the framework (NestJS, Fastify, Express, or another), module boundaries, validation approach, authentication, error format, API docs, and tests.

## Implementation

- Follow the current framework's idioms and project architecture.
- Separate transport concerns from business logic and persistence where appropriate.
- Validate request parameters, body, and query values at the boundary.
- Use consistent HTTP status codes and error responses.
- Enforce authorization on the server for every protected operation.
- Use established password hashing and token libraries; never store plaintext passwords.
- Avoid leaking stack traces, credentials, tokens, or sensitive user data.
- Set sensible timeout and failure handling for external calls.
- Document request and response contracts, including error cases.
- Consider pagination and filtering for potentially large result sets.

## Verification

Test success paths, invalid input, authorization failures, and dependency failures. Run existing lint, type checks, tests, and builds when available.

This skill does not install Node.js, framework packages, or MCP servers.
