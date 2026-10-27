---
name: testing-quality
description: Use when adding tests, investigating regressions, validating features, or reviewing test coverage in frontend and backend applications.
---

# Testing and Quality

## Choose tests from the existing stack

Inspect package scripts, test configuration, fixtures, mocks, and conventions before choosing a tool. Prefer the project's installed framework.

## Test strategy

- Unit-test isolated logic and important edge cases.
- Integration-test API and persistence boundaries when feasible.
- Test user-visible UI behavior rather than implementation details.
- Use browser end-to-end tests for critical cross-layer journeys when browser tooling is available.
- Cover invalid input, loading/error states, permissions, and failure handling.
- Keep tests deterministic; avoid dependence on live third-party systems unless explicitly intended.
- Do not weaken or delete a test simply to make a change pass.

## Reporting

Run the narrowest relevant checks first, then broader tests as practical. Report exact commands and results. If a test cannot run because dependencies or services are unavailable, say so.

This skill does not install test runners, browser binaries, or MCP servers.
