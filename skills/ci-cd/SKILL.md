---
name: ci-cd
description: Use when designing, changing, or troubleshooting continuous integration and delivery pipelines, including triggers, jobs, artifacts, permissions, and deployment gates.
---

# CI/CD Pipelines

Focus on pipeline workflow and automation. For container image and runtime configuration work, use the Docker and DevOps guidance; for application test strategy, use the testing-quality guidance.

## Workflow

1. Inspect the repository's CI/CD files, project scripts, branch/release conventions, and deployment documentation. Identify the platform and syntax from existing configuration; do not assume a provider or add a new one without need.
2. Trace triggers, jobs, dependencies, permissions, secrets, artifacts, caches, environments, and approval gates related to the requested change.
3. Make the smallest change that meets the stated delivery requirement. Keep credentials in the existing secret mechanism, grant jobs only the permissions they need, and avoid exposing secret values in logs.
4. Check workflow syntax and configuration using tools already available in the repository. Run relevant local scripts where practical; do not claim a remote pipeline or deployment passed unless its result is available.

## Completion checklist

- Triggers, job ordering, and affected branches or environments match the request.
- Permissions and secret handling are scoped and do not expose credentials.
- Artifacts, caches, and deployment gates are intentional and reproducible.
- Applicable local checks were run and their results or limitations are reported.

This skill does not install CI providers, credentials, runners, or deployment infrastructure.
