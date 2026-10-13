---
name: worktree
description: Use when creating, listing, or removing git worktrees for the current repository. Worktrees live in `<repo root>/.worktrees/<branch>` and `.worktrees/` is hidden via `.git/info/exclude` (no .gitignore change). Trigger on "worktree", "git worktree", "new worktree", "work on another branch in parallel", "remove worktree", or "clean up worktrees".
---

# worktree

Worktrees go under `.worktrees/` at the root of the **main** worktree. The directory is excluded locally through `.git/info/exclude`, so `.gitignore` and commits stay untouched.

## Resolve paths first

Always resolve from the common git dir, so this works even when run inside a linked worktree (where `.git` is a file):

```sh
common=$(git rev-parse --path-format=absolute --git-common-dir)   # main repo's .git
root=$(dirname "$common")                                         # main worktree root
exclude="$common/info/exclude"
```

## Create

1. Ensure the exclude entry exists (idempotent; `/` anchors it to the root):

   ```sh
   mkdir -p "$common/info"
   grep -qxF '/.worktrees/' "$exclude" 2>/dev/null || echo '/.worktrees/' >> "$exclude"
   ```

2. Derive the directory name from the branch, replacing `/` with `-` (`feat/foo` → `feat-foo`):

   ```sh
   dir="$root/.worktrees/${branch//\//-}"
   ```

3. Add the worktree:

   ```sh
   git worktree add "$dir" "$branch"                  # branch already exists
   git worktree add -b "$branch" "$dir" [<start>]     # new branch (start point defaults to HEAD)
   ```

4. Tell the user the path (`cd "$dir"`). `exclude` is per-clone, so repeat step 1 every time instead of assuming it was done.

## List

```sh
git worktree list
```

## Remove

```sh
git worktree remove "$root/.worktrees/<name>"   # refuses if dirty; use --force only if the user agrees
git worktree prune                              # drop records of worktrees deleted by hand
```

Do not delete the branch unless the user asks. If they do, use `git branch -d` (not `-D`) and report if it refuses because the branch is unmerged.

## Notes

- Never run `git worktree add` for a branch that is already checked out elsewhere; check `git worktree list` first.
- Do not edit `.gitignore` for this; the exclude file is the mechanism.
- Per-worktree setup (dependencies, env files) is not copied automatically; mention it if the project needs it.
