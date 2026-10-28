---
name: rest-api-design
description: Use when defining or reviewing HTTP API contracts, resource operations, representations, status and error semantics, pagination, compatibility, or versioning.
---

# REST API Design

## Scope

Own the client-visible HTTP contract: resources, operations, request/response representations, status codes, errors, pagination, compatibility, and versioning choices. This skill is framework-independent and does not prescribe server implementation. For Node.js request handling use [node-api](../node-api/SKILL.md); for NestJS-specific implementation use [nestjs-development](../nestjs-development/SKILL.md).

## Design workflow

1. Inspect existing route and schema documentation, API examples, client behavior, error conventions, versioning strategy, and compatibility requirements. Identify consumers and supported versions. Separate observed behavior, assumptions, recommendations, and unverified claims.
2. Model resources and relationships around the domain. Define each operation's intent and choose HTTP methods whose semantics fit that intent. Use project naming and representation conventions unless there is a concrete reason to change them.
3. Specify path/query/header inputs, body shape, required and optional fields, success representations, status codes, and error shapes. Include authentication and authorization expectations without specifying server framework mechanics.
4. For collections, define filtering, ordering, page size limits, and continuation behavior when relevant. Cursor and offset pagination have different trade-offs: cursors can handle changing collections without relying on fixed positions but require a stable ordering/key; offsets are straightforward but large offsets or concurrent changes may be costly or surprising. Choose based on existing data and client needs, not by default.
5. Review retries, duplicate submissions, concurrent updates, and compatibility. RFC 9110 defines method semantics: for example, PUT and DELETE are idempotent in intended effect, while POST is not generally idempotent; repeated responses can still differ. Do not infer safe application retries from the method alone. Document idempotency support and conditional-update behavior only where the API implements it.
6. Check additive and breaking changes with actual clients. Additive fields are only compatible when consumers tolerate unknown fields; choose versioning or rollout plans according to the repository's existing strategy. Mark unresolved decisions rather than inventing them.
7. If implementation is requested, hand off framework-specific changes and verify implementation/tests against the agreed contract.

## Example contract: project tasks

Illustrative JSON API only; follow the target project's media types, field names, pagination, error format, and auth policy.

| Operation | Semantics and example response |
|---|---|
| `GET /projects/{projectId}/tasks?limit=25&cursor=...` | Read a page: `200 OK`, with `items` and an optional `nextCursor`. Define whether an absent cursor means the first page and cap `limit` according to the service's documented policy. |
| `POST /projects/{projectId}/tasks` with `{"title":"Review release"}` | Create a task: `201 Created`, representation of the task, and `Location` identifying the created resource when that fits the API. Repeated POSTs can create duplicates unless the API explicitly supports an idempotency mechanism. |
| `GET /projects/{projectId}/tasks/{taskId}` | Read one task: `200 OK` with its representation, or the API's documented not-found response. |
| `PATCH /projects/{projectId}/tasks/{taskId}` with `{"title":"Review deployment"}` | Apply a partial change only if the API defines patch semantics and validation. Do not assume PATCH is idempotent; specify conditional updates if concurrent edits need protection. |
| `DELETE /projects/{projectId}/tasks/{taskId}` | Delete according to the documented retention/visibility policy; a successful response may use `204 No Content` when no representation is returned. State how repeated deletion is represented. |

For an invalid create request, define the established validation status and a stable safe error representation. `400 Bad Request` or `422 Unprocessable Content` may be appropriate under different API conventions; do not treat either as universal. If the project chooses RFC 9457 problem details, use `application/problem+json` with a matching HTTP response status and avoid exposing implementation diagnostics. Otherwise, retain the API's existing error format.

## Verification and completion

- Every operation has an explicit method, target, inputs, success result, and relevant failure responses.
- Status codes match the chosen semantics; authn/authz expectations and pagination are documented where applicable.
- Retry, concurrency, and compatibility behavior are explicit for operations where they matter.
- Examples match the target project's actual representation and error conventions or are labeled illustrative as above.
- Review the contract with affected clients, update documentation/tests if implementation is requested, and report unresolved assumptions.

HTTP method and status semantics are defined by [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html). Problem Details is an optional error format defined by [RFC 9457](https://www.rfc-editor.org/rfc/rfc9457.html); neither standard prescribes a complete application API design.
