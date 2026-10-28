---
name: react-typescript
description: Use when building, debugging, refactoring, or testing React and TypeScript user interfaces, including forms, state, data loading, accessibility, and rendering behavior.
---

# React and TypeScript

## Scope and handoffs

Own React/TypeScript UI behavior: component responsibilities, composition, client-side state, forms, rendering, accessibility, and UI tests. Use [testing-quality](../testing-quality/SKILL.md) for broader test strategy and [security-review](../security-review/SKILL.md) for a dedicated security assessment. For API contracts or server behavior, coordinate with [rest-api-design](../rest-api-design/SKILL.md), [node-api](../node-api/SKILL.md), or [nestjs-development](../nestjs-development/SKILL.md); do not treat frontend checks as authorization or server validation.

## Inspect before changing

1. Read repository instructions, package manifests and lockfiles, React/TypeScript versions, router, styling/design system, UI components, state and data-fetching libraries, form/validation utilities, and test/build scripts.
2. Trace the existing user flow, data ownership, loading/error states, and component boundaries. Check the applicable accessibility and interaction conventions.
3. Separate observed behavior from assumptions. Reuse installed tools and patterns; do not add Redux, a query cache, form library, component system, or testing dependency without a concrete need.

## Design and implementation workflow

1. Define the component's responsibility and public props. Keep components cohesive; compose smaller components when responsibilities or reuse justify it. Place state at its narrowest useful owner: local state for one component, lifted state for coordinated siblings, and shared context/store only for state genuinely shared across a wider tree. Derive values rather than copying props or duplicating state when possible.
2. Decide where data belongs. Treat remote/server data as owned by the existing request/cache layer when one exists; avoid a second unsynchronized copy in component state. For every async state, account for loading, success, empty, error, and retry or recovery states that the product supports.
3. Implement user input with the project's established form approach. Controlled inputs are useful when UI behavior must respond to each edit; an existing form library or uncontrolled pattern may be more appropriate for larger forms or established conventions. Validate for useful early feedback, but treat server-side validation as authoritative. Prevent accidental duplicate submission while pending when appropriate; display server errors without discarding valid user input.
4. Keep interaction semantic and accessible. Prefer native controls and labels; ensure keyboard operation, visible focus, clear field-level errors, and a useful error summary for longer forms. Associate errors with fields (for example with the project's existing `aria-describedby` pattern), set invalid state where appropriate, and move focus only when it helps users recover.
5. Add behavior-oriented tests using the existing test framework and utilities. Exercise what a user can observe, not incidental component internals. See the example below.

## Decision table: state and async behavior

| Situation | Starting point | Verify |
|---|---|---|
| A value is used only within one component | Local state or a derived value | Re-rendering and reset behavior match the interaction. |
| Sibling components must stay coordinated | Lift state to their nearest meaningful owner | Updates propagate without stale duplicated copies. |
| Multiple routes/components share client state | Existing context/store convention, if present | Updates and resets occur at the intended scope. |
| Data is fetched and cached by the app | Existing query/cache layer | Loading, empty, error, invalidation, and refetch behavior match its conventions. |
| A one-off request uses a local effect | Use the project's request utilities; cancel on cleanup or ignore stale results where supported | A slower earlier response cannot overwrite newer state after inputs/route change or unmount. |

Do not add memoization or another state layer merely because a component re-renders. First measure or reproduce a user-visible performance problem, identify expensive work or broad updates, and change the source of the cost.

## Example: profile form with server validation

Suppose a profile form edits a display name. Inspect whether the app already uses a form helper and data cache. Keep the input value and local validation with the form; submit through the existing API client; show pending state while saving; preserve the user's edit if the server rejects it; associate a field error with the input and provide a summary for form-level errors. On success, update or invalidate the existing profile data source rather than maintaining a separate stale copy. If navigation or a newer submission supersedes a request, follow the existing cancellation/stale-response strategy.

Test the user's path: enter an invalid value and receive a useful error; submit a valid value using the keyboard; verify pending and success feedback; simulate a server validation error and confirm the input remains; simulate a failed request and confirm retry/recovery behavior. Use the project's component-test tools; use a browser test only if that is already part of its stack and the journey warrants it.

## Common failure cases

- **Stale response overwrites current state:** Tie the result to the active input/route or use the existing cancellation/query mechanism. Verify with two responses completing out of order.
- **Loading or empty result appears broken:** Distinguish “not requested,” “loading,” “loaded with no results,” and “failed” where the interaction requires it.
- **Client and server validation disagree:** Preserve input and show the server's safe, field-relevant message; do not claim client validation protects the API.
- **Focus or errors are inaccessible:** Test with keyboard navigation and confirm focus remains visible and errors can be found and understood without color alone.
- **Performance optimization adds complexity without benefit:** Reproduce and measure first; retain a change only if it addresses the measured cause without changing behavior.

## Verification and completion

- Run the existing type check, lint, focused UI tests, and build scripts that apply; report exact outcomes and anything unavailable.
- Verify keyboard behavior, labels/names, focus, validation feedback, and responsive states relevant to the change.
- Test success, pending, empty, error, boundary input, and stale/cancelled request cases that apply.
- Confirm state ownership is clear, server errors are handled, and no unrequested dependency or duplicate source of truth was introduced.
- Report what was actually tested and any remaining assumptions.

This skill does not install React, dependencies, browsers, or test tools.
