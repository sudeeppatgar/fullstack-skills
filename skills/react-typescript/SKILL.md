---
name: react-typescript
description: Use when building, debugging, refactoring, or testing React and TypeScript user interfaces.
---

# React and TypeScript

## Inspect first

Check the framework, routing, state management, styling system, component library, TypeScript configuration, and existing tests. Follow the repository's conventions.

## Implementation

- Prefer well-typed component props and explicit domain types.
- Keep components focused and extract reusable behavior when it improves clarity.
- Avoid redundant state and effects; derive values when practical.
- Handle loading, error, empty, success, and disabled states where relevant.
- Use semantic HTML, accessible names, keyboard behavior, and visible focus.
- Ensure responsive layouts and avoid unnecessary layout shifts.
- Reuse the existing design system rather than adding another UI library without reason.
- Avoid unsafe HTML injection and validate untrusted content.

## Verification

Use the test framework already configured. Prefer behavior-oriented tests with the project's existing utilities. Run type checks, linting, relevant tests, and a production build when available.

This skill provides instructions; it does not install React, dependencies, browsers, or test tools.
