---
name: database-prisma
description: Use when changing Prisma schemas or generated clients, database queries, relations, migrations, or data-integrity and performance behavior.
---

# Database and Prisma

## Scope

Own the Prisma-to-database boundary: schema modeling, generated client use, query behavior, migration planning, and provider-specific data integrity and performance. The Prisma schema describes models and mappings; queries use the generated client or project-approved database boundary; migrations change persistent database state. Treat the actual database provider, relation mode, Prisma CLI/client versions, and deployment process as authoritative. For broader architecture choices, use [system-design](../system-design/SKILL.md); for application test selection, use [testing-quality](../testing-quality/SKILL.md); for API contract implications, use [rest-api-design](../rest-api-design/SKILL.md).

## Inspect first

1. Read repository instructions, working-tree state, package manifest and lockfile. Identify the installed Prisma CLI and client/generator versions, datasource provider, schema/generator configuration, relation mode, scripts, and generated-client location. Do not assume commands or APIs from a different Prisma release.
2. Inspect the relevant models, existing migration history, data-access functions, query call sites, tests, and deployment workflow. Establish what is observed and what remains assumed; do not print database URLs, credentials, or production records.
3. Identify affected data, expected cardinality/access patterns, compatibility constraints, and operational recovery options. If provider, migration state, backup status, or production impact is unknown, stop before a destructive or production operation and request evidence or authorization.

## Schema-to-deployment workflow

1. **Model the change.** Define fields, identifiers, nullability, defaults, uniqueness, indexes, relations, and referential behavior from domain requirements. Check that the actual provider and relation mode support the chosen features. Review whether cascades, `SetNull`, or restrictive behavior could delete or orphan data; never rely on implicit defaults for consequential deletion behavior without checking them.
2. **Update client usage.** Find affected reads and writes. Use the generated client API and generator output for the installed version; regenerate it with the repository's script or version-matched CLI after schema/generator changes. Update callers and types, avoid unnecessary returned columns, and preserve existing transaction and error conventions.
3. **Plan the migration.** Use the repository's migration workflow and version-matched commands. Inspect generated SQL or migration operations before applying them. Assess locks, table size, backfill cost, constraints, defaults, nullability, provider limitations, and compatibility with currently deployed application versions.
4. **Test data behavior.** Add or update tests using the existing test database/provider where available. Verify valid and invalid writes, uniqueness and foreign-key behavior, optional relations, referential actions, query results, and transaction rollback or conflicts relevant to the change. Do not treat a mocked client test as evidence that database constraints or provider behavior work.
5. **Deploy in compatible steps.** Prefer an expand/backfill/contract sequence when old and new application versions may overlap: add a compatible shape, deploy code that tolerates old and new rows, backfill with a bounded and observable process where needed, verify invariants, then tighten constraints or remove obsolete fields in a later reviewed change. Confirm the actual provider's migration behavior; do not assume DDL is online or transactional.
6. **Recover deliberately.** Before staging or production migrations, establish that a recent backup exists and that the recovery procedure is usable. Review migration status and database state before choosing rollback, roll-forward, or restore. After a partial failure, determine which operations applied for this provider before retrying; do not reset, edit an applied migration, or mark it resolved blindly.

## Example: adding an optional display name

Suppose a profile screen needs an optional display name on an existing account model. Add an optional scalar field only if its type and mapping fit the installed schema conventions and provider; retain existing identifiers and relations. Trace the profile query and update it to select/use `displayName` through the generated client pattern already used by this Prisma version. Regenerate the client using the repository's configured workflow. Add tests for an account with a value and one with `null`, including API/UI behavior if those layers expose it. Generate the migration with the project's version-matched workflow, inspect the actual provider-specific operation, and verify whether adding the nullable field requires any backfill under the target provider and deployment setup. Apply it to a disposable or development database, then a representative staging database before production. If a later requirement makes the field mandatory, backfill and verify all existing rows first, then plan a separately reviewed constraint change compatible with the deployment sequence.

## Transactions, constraints, and concurrency

- Use a transaction when multiple database writes must commit or roll back as one logical operation. Keep external side effects such as email or remote API calls outside the transaction unless an established outbox or equivalent design coordinates them. Avoid long-running transactions.
- Pass the transaction-scoped client through helpers that participate in the transaction; do not accidentally query through a separate client/connection. Check the installed Prisma version and provider for supported isolation, timeout, and transaction options.
- Enforce invariants in database constraints where supported, not only with a prior application read. A “check then insert” can race; use a unique constraint and handle its conflict according to the API contract.
- For concurrent updates, inspect the provider's isolation and locking behavior and the actual write pattern. Use conditional/atomic writes or a version/optimistic-concurrency check when requirements demand it. Retry only recognized transient conflicts and only when the whole operation is safe to repeat; do not blindly retry side effects.
- Verify referential actions against the provider and relation mode. Cascades and `SetNull` can have materially different or unsupported behavior across providers and schema configurations.

## Investigate slow queries with evidence

1. Reproduce the slow user operation and identify its actual Prisma call(s), query count, latency distribution, result size, and relevant parameters without logging secrets or sensitive values.
2. Inspect generated SQL or approved query telemetry for over-fetching, repeated/N+1 queries, unbounded reads, and filters/sorts that do not match the observed access pattern.
3. Use the target provider's safe query-plan tooling on representative data. Check predicates, join order, estimated versus actual rows where available, scans, and index use. Understand whether an “analyze” option executes the query before using it; avoid heavy or mutating diagnostics on production without an approved plan.
4. Propose an index only when query plans and workload evidence support it. Consider selectivity, composite column order, write/storage cost, and provider-specific index features. Re-run the same query and compare plans and measurements; do not claim an improvement from schema inspection alone.

## Verification and completion

- The schema validates with the installed Prisma version and matches the actual provider and relation mode.
- The generated client is current, affected callers compile, and relevant integration tests exercise the real database boundary where available.
- Migration operations were reviewed for data loss, locks, backfills, compatibility, and provider-specific behavior.
- Constraints, relation actions, transaction rollback/conflicts, and query performance were verified where relevant.
- Backup/recovery readiness and production authorization are established before high-impact migration work; secret values and private records were not exposed.
- Exact commands/checks, observed outcomes, assumptions, and unresolved risks are reported. Do not claim production safety because a migration applied locally.

This skill does not install Prisma, provision a database, or grant permission to modify production data.
