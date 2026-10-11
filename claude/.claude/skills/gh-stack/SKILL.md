---
name: gh-stack
description: Use when working with stacked PRs via the `gh stack` GitHub CLI extension (github/gh-stack). Covers creating a stack of dependent branches, adding layers, pushing/submitting PRs, syncing and rebasing after trunk or lower-layer changes, navigating the stack, restructuring it, and merging. Trigger on "gh stack", "stacked PR", "stack of PRs", "split this into multiple PRs", "add a branch on top", "rebase the stack", or "submit the stack".
---

# gh stack

`gh stack` manages a chain of branches where each builds on the previous one, and maps them to a stack of PRs on GitHub. Bottom of the stack is closest to trunk.

## Workflow

```sh
gh stack init my-feature            # start a stack (base: default branch, or --base <branch>)
gh stack init a b c                 # create/adopt several layers at once, bottom to top
# ...edit, then commit and add the next layer in one step:
gh stack add -Am "Add API routes" api-routes   # -A stage all, -u tracked only; name optional (derived from -m)
gh stack submit --auto              # push all branches, create/update PRs (drafts unless --open)
gh stack view --short               # status; --json for machine-readable
```

## Keeping in sync

- `gh stack sync`: fetch, fast-forward trunk, cascade-rebase, atomic push, refresh PR state. Run this first when trunk or a lower PR changed.
- `gh stack rebase`: cascade rebase only; use when sync reports conflicts. Resolve, `git add`, then `gh stack rebase --continue` (or `--abort`). Flags: `--upstack`, `--downstack`, `--no-trunk`.
- `gh stack push`: push active branches only (`--force-with-lease`, non-atomic; merged branches skipped).

## Navigation

`gh stack up|down [n]`, `top`, `bottom`, `trunk`, `switch` (interactive), `checkout <stack#|PR#|PR URL|branch>`.

## Restructuring and finishing

- `gh stack modify`: interactive TUI to drop/fold/insert/reorder/rename. Run `gh stack submit` afterwards.
- `gh stack merge [PR#] [--yes]`: atomic merge of the stack up to the chosen PR.
- `gh stack unstack`: remove the stack locally and on GitHub.
- `gh stack link`: link existing PRs into a stack without local tracking.

## Tips

- Commit changes to the layer they belong to: `gh stack down`/`switch` to it first, then commit and `gh stack rebase --upstack`.
- Without `--auto`, `submit` opens an interactive editor. In agent sessions always pass `--auto` (and `--yes` for merge) to avoid hanging on TUIs; avoid `modify` and bare `checkout`.
- Check `gh stack <command> --help` for flags not listed here.
