#!/usr/bin/env bash
set -euo pipefail

common=$(git rev-parse --path-format=absolute --git-common-dir)
root=$(dirname "$common")
dir=$(pwd)

for src in "$root"/.env "$root"/.env.* "$root"/.dev.vars "$root"/.dev.vars.*; do
  [ -f "$src" ] || continue
  name=$(basename "$src")
  case "$name" in *.example | *.sample) continue ;; esac
  git -C "$root" ls-files --error-unmatch "$name" >/dev/null 2>&1 && continue
  [ -e "$dir/$name" ] && continue
  cp -p "$src" "$dir/$name"
  echo "==> copied $name"
done

if [ -f pnpm-lock.yaml ]; then cmd="pnpm install --frozen-lockfile"
elif [ -f bun.lock ] || [ -f bun.lockb ]; then cmd="bun install --frozen-lockfile"
elif [ -f yarn.lock ]; then cmd="yarn install --frozen-lockfile"
elif [ -f package-lock.json ]; then cmd="npm ci"
elif [ -f uv.lock ]; then cmd="uv sync"
else cmd=""
fi
if [ -n "$cmd" ]; then
  echo "==> $cmd"
  $cmd
fi

if setup=$(git config --get wt.setup); then
  echo "==> wt.setup: $setup"
  sh -c "$setup"
fi
