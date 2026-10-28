---
name: git-workflows
description: Use when handling repository collaboration tasks such as branches, commits, merges, rebases, conflict resolution, or change handoff.
---

# Git Workflows

Follow the target repository's contribution guidance and the user's requested scope. Do not commit, push, rebase, reset, or discard changes unless explicitly authorized.

## Workflow

1. Inspect `git status`, the current branch, relevant recent history, and repository-specific instructions before proposing Git operations. Identify uncommitted user changes and preserve them.
2. For branch or integration work, confirm the intended base and target, review divergence, and choose the least disruptive operation consistent with project policy.
3. Before staging or committing, inspect the full diff and stage only files belonging to the requested change. Do not include generated files, secrets, or unrelated work.
4. Resolve conflicts by understanding both sides and the intended behavior. Review the resolved diff and run relevant checks before continuing.
5. Report the operations performed, resulting branch/state, checks, and any remaining conflicts or blockers. Ask before irreversible or remote operations when authorization is not explicit.

## Completion checklist

- Existing user changes remain intact and unrelated files are excluded.
- The selected base/target and resulting history match the request.
- Conflicts, staged changes, and the final diff have been reviewed.
- No unrequested destructive or remote operation was performed.
