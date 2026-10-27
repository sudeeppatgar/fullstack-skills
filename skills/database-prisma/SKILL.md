---
name: database-prisma
description: Use when designing or changing database schemas, Prisma models, migrations, queries, indexes, and transactional workflows.
---

# Database and Prisma

## Inspect first

Read the current schema, migration history, database provider, existing data-access patterns, and relevant API contracts before making changes.

## Design and implementation

- Model entities, relationships, uniqueness, and nullability intentionally.
- Use constraints and indexes that match actual query patterns.
- Consider query count, N+1 access, pagination, and transaction boundaries.
- Use transactions when a multi-step operation must be atomic.
- Treat migrations as reviewed changes to persistent data; do not casually rewrite migrations already applied in shared environments.
- Consider backward compatibility and deployment order for schema changes.
- Avoid destructive changes or data deletion without explicit authorization.
- Never log credentials or sensitive records.

## Verification

Run the repository's schema validation, migration checks, relevant tests, and type checks. Do not claim a migration is safe for production solely because it applies locally.

This skill does not install a database server or Prisma dependencies.
