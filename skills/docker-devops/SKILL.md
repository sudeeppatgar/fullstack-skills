---
name: docker-devops
description: Use when working with Dockerfiles, Compose, CI pipelines, environment configuration, container health, or deployment reliability.
---

# Docker and DevOps

## Inspect first

Read existing Dockerfiles, Compose files, CI workflows, environment variable names, health checks, and deployment docs. Preserve established service names and ports unless change is needed.

## Practices

- Prefer reproducible builds and pinned versions where appropriate.
- Keep secrets out of images, committed files, and build logs.
- Use health checks and distinguish process start from service readiness.
- Consider non-root execution, minimal images, and least privilege.
- Check persistence and backup assumptions before changing volumes.
- Never delete persistent volumes or production data without explicit authorization.
- Avoid printing environment variables that may contain secrets.
- Make configuration differences between development, test, and production explicit.

## Verification

Run relevant configuration validation, image builds, tests, and health checks when available. Explain unavailable services or environment-specific assumptions. Never claim deployment success unless it was verified.

This skill does not install Docker or provision cloud infrastructure.
