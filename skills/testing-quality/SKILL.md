---
name: testing-quality
description: Use when selecting, writing, debugging, or reviewing tests and quality gates for application changes or regressions.
---

# Testing and Quality

## Scope

Own test strategy and verification across layers: choose the smallest test that provides trustworthy evidence, add broader coverage when a boundary or critical user journey requires it, diagnose unreliable tests, and connect checks to the repository's CI workflow. Domain implementation remains with the relevant skill, such as [react-typescript](../react-typescript/SKILL.md), [node-api](../node-api/SKILL.md), [nestjs-development](../nestjs-development/SKILL.md), or [database-prisma](../database-prisma/SKILL.md). For API contract decisions that shape contract tests, use [rest-api-design](../rest-api-design/SKILL.md); for review findings on a proposed diff, use [code-review](../code-review/SKILL.md).

## Inspect the existing test system

1. Read repository instructions, package manifests/lockfiles, test and build configuration, CI workflow, fixtures, existing test names, and scripts. Identify versions, available services, environment setup, and commands from evidence.
2. Trace the changed behavior and its boundaries. Separate what a unit test can prove from what requires a real database, HTTP adapter, browser, or external contract.
3. Select tools already present. Do not install a new runner, browser, mocking library, database, or coverage gate without a concrete gap and project approval.

## Choose test scope

| Test type | Use when | Evidence it provides | Limit |
|---|---|---|---|
| Unit | Pure logic or one class/function can be isolated cheaply | Branch behavior, boundaries, and local failure handling | Does not prove framework wiring or real dependency behavior. |
| Component | A UI component's user-visible interactions and states matter | Input, keyboard, accessibility state, rendering, and callbacks | Does not prove a real backend or browser integration. |
| Integration | Two or more real project components or a real persistence/transport boundary interact | Configuration, serialization, constraints, and boundary behavior | Can be slower and still not prove the full user journey or production environment. |
| Contract | Independently deployed clients/services must agree on a request/response or message format | Compatibility against the agreed contract | Does not prove every implementation path or deployment. |
| End-to-end | A critical cross-layer journey or routing/auth/browser behavior needs evidence | The configured system works along the tested path | Keep focused; it is usually slower and failures may be less localized. |
| Regression | A known defect or fragile edge case must stay fixed | The previously failing behavior remains covered | Choose the narrowest level that reproduces the original cause. |

Use multiple levels when each proves a different risk, not to duplicate the same assertion. A changed public contract may need both focused implementation tests and contract/client verification; a database constraint needs a database-backed test if the constraint itself is in scope.

## Doubles and real boundaries

- **Stub:** provide a controlled response or value when an indirect input needs controlling.
- **Mock/spy:** assert an interaction only when that interaction is part of the behavior contract (for example, a notification is requested after a successful commit), not to mirror private implementation steps.
- **Fake:** use a simpler in-memory substitute when it models the relevant behavior and its limitations are understood.
- **Real boundary:** use the actual configured database, HTTP adapter, or other dependency when behavior depends on its semantics, constraints, serialization, or integration.

Mocks cannot establish real integration behavior. In particular, a mocked Prisma client cannot prove database constraints, transaction semantics, migrations, or provider behavior. Use a real test database or an appropriate integration environment for those claims when available. Keep external production services out of routine tests unless the test is intentionally designed and authorized for them.

## Determinism and isolation

- Create the minimum test data needed and make ownership explicit. Use unique values or isolated schemas/databases so tests do not depend on execution order.
- Reset state between tests using existing fixtures/transactions/cleanup conventions. Ensure cleanup runs after failures as well as success.
- Control clocks, randomness, generated IDs, and asynchronous events only where relevant; assert observable outcomes rather than exact timing.
- Avoid sleeps, shared mutable fixtures, test-order assumptions, live network calls, and reliance on a developer's local data.
- Cover negative and boundary behavior: invalid/missing input, empty/large values, unauthorized access, dependency errors, cancellation, duplicate operations, and recovery where relevant.

## Example: profile update

For a profile-edit change, test a valid form submission at the component level using realistic typing and keyboard submission; verify pending feedback and a visible result. Add a service/API integration test for server validation and authenticated-but-forbidden access. If persistence changes, use the project's test database to verify the stored value and relevant constraints. If a client/server contract changes, validate the documented shape against its consumer. Add a browser end-to-end test only if routing, focus behavior, or the complete journey introduces risk that the lower-level tests cannot cover.

Each layer answers a different question: did the interaction behave, did the server enforce its boundary, did the database persist valid state, and did clients agree on the contract? Avoid adding all layers when one existing focused test already provides the needed evidence.

## Diagnose a failing or flaky test

1. Re-run the narrow failing test with the repository's documented command and capture the first assertion/error plus relevant logs. Do not immediately retry it repeatedly or increase timeouts.
2. Determine whether failure is deterministic. Compare isolated versus suite execution and, where configured, serial versus parallel execution; record the exact conditions.
3. Check for timing assumptions, sleeps, unresolved promises, unobserved async work, race conditions, and tests waiting on implementation details instead of a user-visible or domain outcome. Wait on a meaningful observable condition using existing test utilities.
4. Check leaked/shared state: database rows, filesystem/temp files, fake timers, mocks, event listeners, environment variables, ports, and module singletons. Confirm cleanup runs after failures and test data is isolated.
5. Check external dependencies and environment differences (service readiness, network, clock, timezone, locale, resource contention). Replace nondeterministic live dependencies with an appropriate test boundary when the external system is not the subject of the test.
6. Fix the underlying race, isolation, or assertion problem. Use retries only when transient behavior is part of the system contract and the retry policy itself is being tested; retries must not hide an unstable test.
7. Re-run the focused test, the surrounding suite, and relevant CI commands. Report any remaining nondeterminism with evidence.

## CI quality gates

Inspect the actual pipeline in [ci-cd](../ci-cd/SKILL.md) and the project's scripts before proposing gates. Prefer the existing required checks; order fast deterministic checks before service-dependent integration/e2e checks when the workflow supports it. Ensure required services and setup are explicit, failures are visible, and any changed test selection cannot silently omit relevant checks. Do not add a new coverage threshold or provider-specific gate without a reason and ownership.

## Completion checklist

- The selected tests cover the risk at the appropriate layer without only duplicating implementation details.
- Doubles are fit for purpose; real boundaries are tested where their behavior is the claim.
- Test data and async state are isolated and cleanup is reliable.
- Relevant negative, boundary, permission, failure, and recovery cases are addressed.
- Exact local/CI commands and outcomes are reported; unrun or unavailable checks are identified.
- No flaky retries, weakened assertions, or new dependencies were added merely to make checks pass.

This skill does not install test runners, browser binaries, databases, or MCP servers.
