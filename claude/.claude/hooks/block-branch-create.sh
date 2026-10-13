#!/bin/sh
# PreToolUse(Bash): block branch creation outside `git worktree add`.
cmd=$(jq -r '.tool_input.command // empty')
if printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+(checkout[[:space:]]+(-b|-B)|switch[[:space:]]+(-c|-C|--create|--force-create)|branch[[:space:]]+[^-[:space:]])'; then
  echo "ブランチは直接作らず、CLAUDE.md の「worktree の手順」に従い、git worktree add -b <branch> <main root>/.worktree/<branch> で作成してください。" >&2
  exit 2
fi
