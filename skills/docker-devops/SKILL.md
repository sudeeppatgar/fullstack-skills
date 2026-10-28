---
name: docker-devops
description: Use when building, troubleshooting, securing, or deploying containerized applications with Dockerfiles, Compose, runtime configuration, or persistent data.
---

# Docker and DevOps

## Scope and handoffs

Own image construction, local/container runtime configuration, container operations, persistent storage, and deployment checks. For pipeline triggers, permissions, and job design, hand off to [ci-cd](../ci-cd/SKILL.md). For schema or migration changes that affect container rollout/rollback, coordinate with [database-prisma](../database-prisma/SKILL.md). For application implementation, security review, or architecture decisions, use the relevant [node-api](../node-api/SKILL.md), [nestjs-development](../nestjs-development/SKILL.md), [security-review](../security-review/SKILL.md), or [system-design](../system-design/SKILL.md) skill. Do not assume Docker, Compose, a cloud provider, or an orchestrator is used until repository evidence confirms it.

## Inspect before changing

1. Read repository instructions, working-tree state, Dockerfiles, Compose files, `.dockerignore`, environment examples, scripts, CI workflows, and deployment/runbooks. Check the installed Docker and Compose versions when command behavior matters; follow the repository's invocation and format.
2. Map build stages and contexts, runtime entrypoints, required ports, networks, dependencies, environment configuration, volumes, health checks, identity/permissions, and deployment targets. Distinguish build-time inputs from runtime configuration and identify which values are secret.
3. Determine the requested outcome and constraints first: reproducibility, build time, image size, development convenience, runtime security, availability, or rollback. Separate observed facts from assumptions; avoid unrelated infrastructure changes.

## Build and image workflow

1. Keep the build context narrow. Review `.dockerignore` so local files, credentials, generated artifacts, and unrelated source are not sent to the builder.
2. Preserve reproducibility using the project's lockfiles and existing version policy. Use cache for stable expensive steps when it helps, but make cache keys/invalidation reflect dependency manifests and build inputs. Confirm a clean build can still reproduce the image.
3. Consider multi-stage builds when build tools or development dependencies are not needed at runtime. Copy only required runtime artifacts into the final stage, and verify the final entrypoint and permissions. Do not add stages solely for appearance; compare resulting size and behavior.
4. Keep public build configuration distinct from runtime configuration. Frontend values embedded in compiled assets are public. Do not put secrets in Dockerfile `ARG`/`ENV`, copied files, image layers, build logs, or committed `.env` files. Use the repository's secret mechanism; use a builder secret mount only if the actual builder supports and configures it.
5. Build and inspect using commands supported by the repository's Docker CLI/Compose version. For example, with the Compose plugin:

   ```bash
   SERVICE=app        # Replace with a service from the repository's Compose config.
   IMAGE_TAG=app:dev  # Replace with the image tag being inspected.
   docker compose config
   docker compose build "$SERVICE"       # Build one service for focused diagnosis.
   docker image ls "$IMAGE_TAG"           # Confirm the intended image/tag exists.
   docker image history "$IMAGE_TAG"      # Inspect layers when size/layering is suspect.
   ```

   Check output before sharing it; rendered configuration and build history may expose sensitive values or file paths. If Compose is not installed or the repository uses a different wrapper, use its documented commands instead.

## Compose and runtime behavior

- **Ports and networking:** Distinguish a host-published port from the port a container listens on. Services on the same Compose network commonly reach each other using the configured service name and container port; verify the actual network, bind address, and configuration before changing ports.
- **Dependencies and readiness:** Startup order does not necessarily mean a dependency is ready to serve requests. Use an existing health check/readiness mechanism and ensure applications handle temporary dependency unavailability. Add `depends_on` health conditions only if supported by the Compose version and consistent with the app's own retry behavior.
- **Health checks:** Test the health command inside the image and make sure it checks the service condition needed by consumers, not merely that a process exists. Avoid adding an executable to a minimal image just for a check without considering an existing endpoint or probe mechanism.
- **Volumes and persistence:** Determine whether data lives in a bind mount, named volume, anonymous volume, or external storage. Check ownership/UID assumptions and backup/restore procedures before changing mounts, paths, or permissions. Do not remove or recreate data-bearing volumes to troubleshoot startup.
- **Runtime config:** Pass environment-specific settings through the existing runtime/secret configuration mechanism. Document required variable names without recording secret values. Verify a startup failure identifies missing configuration safely.

## Troubleshooting workflow

Start with read-only inspection and the earliest failing stage; do not prune or delete resources to “clean up” before understanding their contents.

```bash
SERVICE=app # Replace with a service from the repository's Compose config.
docker compose ps
docker compose logs --tail=100 "$SERVICE" # Recent logs for one service.
docker compose config                      # Effective config; inspect before sharing.
docker compose exec "$SERVICE" sh          # Only if the image contains a shell.
```

If the project uses standalone Docker, substitute its documented container/image commands. Common diagnosis path:

| Symptom | Inspect first | Safe next step |
|---|---|---|
| Build fails | Failing build step, context, ignored files, lockfile/install command, base image availability | Re-run the focused build and inspect its actual output; change only the failing input. |
| Container exits at startup | Exit code, entrypoint/command, required runtime config, file permissions | Compare the configured command and runtime environment with the working project setup. Do not print secrets. |
| Container is unhealthy | Health-check command, its dependencies, startup delay, and health logs | Test the actual endpoint/command and distinguish process-up from service-ready. |
| Service cannot reach another | Network membership, DNS/service name, listening interface, container port, protocol | Test from the caller's network context; avoid replacing service names with host-only assumptions. |
| Permission denied | Mounted path ownership, container user, required write locations | Identify the specific path and least-privilege fix; do not broadly `chmod 777` or chown persistent data without understanding impact. |

Use `exec` only for diagnosis; a shell or utility may not exist in a production image. Avoid copying secrets or personal data out of containers into logs or reports.

## Deployment verification and recovery

1. Verify the intended image/tag or digest, runtime configuration, health, dependencies, and published endpoints in the target environment using its documented access and release process.
2. Run the available smoke/health checks and observe logs/metrics for the rollout window. Report only the environments and evidence actually checked.
3. Establish the rollback artifact and procedure before deployment. Confirm whether the previous application version is compatible with any database/schema changes; a container rollback does not undo a migration or restore deleted data.
4. Before any operation that can change or remove persistent data, confirm scope, authorization, backup recency, and a tested recovery path. Prefer targeted inspection and roll-forward/recovery steps over deleting volumes.

Never run volume removal, `down -v`, prune, or destructive cleanup as a generic troubleshooting step. If a user explicitly requests a destructive action, identify the exact resources/data affected, check backups and dependencies, show the proposed operation, and obtain explicit confirmation before executing it.

## Completion checklist

- Docker/Compose versions and repository conventions informed the chosen commands and configuration.
- Image build/runtime configuration, ports, readiness, and storage behavior match the intended environment.
- No secrets were embedded, logged, or committed; privileges and filesystem changes are justified.
- Build, runtime health/smoke, deployment, and recovery checks are reported with their actual evidence and limitations.
- Persistent data was preserved unless an explicitly authorized, safeguarded change required otherwise.

This skill does not install Docker, provision cloud infrastructure, or guarantee deployment success.
