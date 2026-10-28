---
name: ci-cd
description: Use when designing, changing, or troubleshooting CI/CD workflows, required checks, build artifacts, permissions, or deployment gates.
---

# CI/CD Pipelines

## Scope and handoffs

Own workflow orchestration: triggers, jobs, required checks, caches, artifacts, permissions, deployment gates, and pipeline failure diagnosis. For container build/runtime configuration use [docker-devops](../docker-devops/SKILL.md); for test selection and test quality use [testing-quality](../testing-quality/SKILL.md). Do not assume a CI provider or deployment target until repository configuration establishes it.

## Inspect before editing

1. Read repository instructions, the working tree, all relevant workflow files, project scripts, lockfiles, branch/release policy, and deployment documentation. Identify the provider, syntax/version, runner environment, required checks, and currently available secrets from configuration names only; never reveal secret values.
2. Trace the affected event from trigger through jobs, dependencies, artifacts, environments, and deployment. Identify which code, artifacts, and credentials each event can access, including fork and other untrusted contributions.
3. Capture the actual failing job, step, command, exit status, and relevant log context before changing configuration. Distinguish observed failure from a suspected cause; try the same existing command locally only when the environment is comparable.

## Design workflow

1. Keep verification and release responsibilities separate where the repository needs it. Useful stages may include formatting/lint, type checks, unit/component tests, integration/contract/e2e tests, build, applicable security checks, artifact publication, and deployment. Use existing scripts and order checks to fail early without skipping required gates.
2. Install dependencies reproducibly with the project's package manager and lockfile in immutable/frozen mode where supported. Cache downloaded dependencies or build intermediates only when safe; key/invalidate caches from relevant manifests, lockfiles, toolchain, and build inputs. A cache is an optimization, never the source of truth or a substitute for installation.
3. Give each job only the permissions it requires. Avoid making untrusted pull-request code run with write tokens, deployment credentials, or other privileged secrets. Separate trusted deployment jobs from untrusted test execution.
4. Treat artifacts from untrusted or less-trusted jobs as untrusted input. Validate expected name, type, paths, size, and provenance before a privileged job consumes them; do not execute scripts or workflows extracted from an untrusted artifact with secrets. Where integrity matters, pin and verify artifact identity/digest or supported provenance attestations rather than trusting a mutable tag or filename alone.
5. Protect production/staging deployments with the repository's existing environment protection, approval, branch, and credential controls. Promote the artifact that passed checks rather than rebuilding different source for release when the pipeline supports that model.
6. Make deployment verification and recovery explicit: health/smoke checks, rollout observation, failure stop criteria, prior artifact/reference, and rollback steps. Coordinate with [docker-devops](../docker-devops/SKILL.md) for container runtime checks and [database-prisma](../database-prisma/SKILL.md) when Prisma migrations affect rollout or recovery. Application rollback may not reverse database changes; confirm schema compatibility and recovery with the relevant implementation owner.

## Provider-specific security example

In GitHub Actions, `pull_request_target` runs in the base repository context and can receive access to privileged repository resources. Do not check out and execute a fork's untrusted head code in such a privileged workflow. If this event exists, inspect the entire workflow and artifact handoff; prefer an unprivileged pull-request workflow for executing contributor code and a separately gated trusted workflow for privileged actions. For other providers, apply the equivalent event/token model documented for that provider rather than copying GitHub syntax.

## Troubleshooting example

If a test job fails after a dependency update, first identify the exact job step and lockfile used. Compare runner runtime/package-manager versions and the install command with repository configuration. Check whether the cache key includes the changed lockfile and whether a clean, cache-free install reproduces the failure. Then run the same project test script locally if possible. Fix the dependency, workflow environment, or cache key indicated by evidence; do not suppress the test or add retries to hide a deterministic failure.

## Practical inspection and verification

Use the provider's UI/CLI to inspect the exact run, event, job, step, logs, permissions, and artifact metadata. Locally, run the repository scripts that the pipeline invokes; do not invent provider-neutral commands for provider-specific syntax. Verify that:

- the intended triggers and protected branches/environments run the expected checks;
- clean dependency installation and cache misses both work;
- failures are visible and block the intended downstream publish/deploy jobs;
- jobs with untrusted input do not receive privileged secrets or write permissions;
- artifacts are traceable to the checked source and are consumed without unsafe trust assumptions;
- deployment health and rollback steps are actionable and compatible with data changes.

## Completion checklist

- Workflow changes match actual provider syntax, repository scripts, and release policy.
- Required checks, permissions, secret exposure, untrusted events, and artifact handoffs were reviewed.
- Cache, artifact, and deployment decisions are reproducible and justified by the existing pipeline.
- Local checks and remote run evidence are reported separately; do not claim a remote pipeline or deployment passed without observing it.
- No new provider, dependency, secret, or deployment path was introduced without need and authorization.

This skill does not install CI providers, credentials, runners, or deployment infrastructure.
