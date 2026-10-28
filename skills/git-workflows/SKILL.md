---
name: git-workflows
description: Use when handling Git branches, commits, synchronization, merges, rebases, cherry-picks, conflict resolution, or repository recovery.
---

# Git Workflows

## Safety first

Do not commit, push, rewrite shared history, or discard work unless the user explicitly authorized that operation. Preserve existing changes. Before any history-changing or destructive action, explain its effect, inspect the affected state, and establish a recovery point. For task planning beyond Git operations, use [fullstack-core](../fullstack-core/SKILL.md); for reviewing the resulting code diff, use [code-review](../code-review/SKILL.md).

## Inspect before acting

Start with read-only inspection:

```bash
git status --short --branch  # Current branch and worktree/index state.
git diff                    # Unstaged tracked changes.
git diff --cached           # Staged changes.
git log --oneline --decorate -n 10
git branch -vv              # Local branches and tracking relationships.
```

Identify untracked files too (`git status --short`), the intended base/target branch, remote tracking state, and whether work is shared. Do not assume `main`, a remote name, or a clean worktree. If the requested operation could overwrite uncommitted work, pause and agree on a preservation plan first.

## Normal feature workflow

1. Confirm the repository's contribution instructions, intended base branch, and user authorization for branch, commit, remote, merge, or rebase operations.
2. Create a feature branch when requested and appropriate, from the agreed base. Example: `git switch -c feature/short-name` creates and switches to a new branch; check that the name is unused and preserve any current work first.
3. To synchronize, fetch the agreed remote (for example `git fetch origin`). Fetch updates remote-tracking refs but does not move the current branch or change worktree files. Replace `origin/main` below with the actual target and inspect divergence before integrating:

   ```bash
   git log --oneline --left-right HEAD...origin/main
   ```

   Choose one integration method according to project policy and the user's authorization. Merge option:

   ```bash
   git merge origin/main
   ```

   Rebase option (replays local commits and rewrites their IDs):

   ```bash
   git rebase origin/main
   ```

   Avoid rebasing a branch others may use unless coordinated; do not run both methods for the same synchronization.
4. Before staging, inspect `git status`, `git diff`, and relevant untracked files. Stage only intended paths, e.g. `git add -- path/to/file`; then inspect `git diff --cached` and run `git diff --cached --check` before a commit. Never stage secrets, generated artifacts, or unrelated user work.
5. Run relevant tests and checks before any authorized commit or push. Commit only when requested, for example `git commit -m "short change summary"`. Afterward inspect `git status`, the final diff, and resulting history. Report exact operations and checks performed.

## Conflict and interrupted-operation recovery

When Git reports conflicts, identify the operation and inspect the affected paths before editing:

```bash
git status
git diff --name-only --diff-filter=U  # Unmerged paths.
git diff -- path/to/conflicted-file   # Inspect conflict context.
```

Resolve each file based on intended behavior, not by choosing “ours” or “theirs” wholesale. Review the complete result, stage only resolved files, run relevant tests and `git diff --check`, then continue the operation that is actually in progress:

```bash
git merge --continue
git rebase --continue
git cherry-pick --continue
git revert --continue
```

Use only the matching continuation command. To stop an operation, its corresponding `--abort` command (such as `git merge --abort`, `git rebase --abort`, `git cherry-pick --abort`, or `git revert --abort`) attempts to restore the state from before it began; first inspect and preserve pre-existing work because abort may not reconstruct a dirty starting tree exactly. Do not delete lock/state files or reset paths to “fix” an interrupted operation. Recheck `git status` before deciding whether to continue or abort.

For a revert, inspect the target commit and its effects first. `git revert` creates a new inverse commit rather than erasing history, but the inverse may conflict or be unsafe if later work depends on the change. Review the resulting diff and tests before continuing, and perform it only when authorized.

## Recovery after lost or rewritten work

The reflog can help locate commits and previous branch tips; it does not record arbitrary uncommitted file contents. Do not promise reflog recovery for uncommitted edits when no saved copy exists.

1. Stop issuing write/history commands. Inspect `git status`, `git reflog --date=local -n 20`, and relevant `git log` entries.
2. Inspect a candidate commit before restoring anything. Set `CANDIDATE_REF` to the ref found in the reflog, then review it:

   ```bash
   CANDIDATE_REF=replace-with-reviewed-ref
   git show --stat "$CANDIDATE_REF"
   git show "$CANDIDATE_REF" -- path/to/file
   ```

3. Preserve a promising commit with a new recovery branch before further changes, for example `git branch rescue/recovered-work "$CANDIDATE_REF"`. This adds a reference without moving the current branch; choose an unused branch name.
4. Compare the recovery point with the current branch and recover only the required commits or paths. Verify worktree, index, branch, and tests afterward. If the reflog does not show the work, avoid claiming recovery is possible; check other clones/backups with the owner.

## Commands that can discard or rewrite work

Explain and inspect before using any of these; they are not generic cleanup steps:

- `git restore --staged` with a specific path unstages it while retaining its worktree content. `git restore --worktree` with a specific path replaces its unstaged content from the index and discards those edits.
- `git reset --soft` to a selected commit moves the branch but leaves the index/worktree; `git reset --mixed` also resets the index; `git reset --hard` resets tracked index/worktree content and can discard changes. Inspect the target and diffs first.
- `git clean -nfd` is a preview; `git clean -fd` deletes untracked files/directories, and adding `-x` includes ignored files. Review the preview and protect needed data before any deletion.
- `git rebase` changes commit identities. A force push can replace remote history; `--force-with-lease` checks the remote has not advanced unexpectedly but still rewrites it. Coordinate and obtain explicit authorization before either.

Prefer narrow, reversible steps. If a destructive operation is explicitly requested, state exactly what it will remove or rewrite, verify backups/recovery options, and get confirmation before proceeding.

## Completion checklist

- Initial branch, staged/unstaged/untracked state, and target were understood; user changes were preserved.
- Conflicts or recovery steps were based on intent and the final diff/history were inspected.
- Any destructive or history-rewriting command was explained and explicitly authorized.
- Resulting branch/worktree state and relevant check outcomes were verified and reported.
