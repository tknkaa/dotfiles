#!/usr/bin/env bash
# worktrunk の pre-start フックから、作ったばかりの worktree の中で呼ぶ。
# worktrunk の copy-ignored は gitignore されたものを丸ごとコピーし、ローカル DB(.wrangler/ など)まで持ち込むため、
# 秘密情報のファイルだけを自前でコピーする。そうしないとブランチでスキーマを変えたときに main のデータを壊す
set -euo pipefail

common=$(git rev-parse --path-format=absolute --git-common-dir)
root=$(dirname "$common")
dir=$(pwd)

# 秘密情報はどの worktree でも同じでよく、無いと起動できないため root からコピーする。
# 既にあるものは上書きしない。worktree 側で書き換えた値を消さないため
for src in "$root"/.env "$root"/.env.* "$root"/.dev.vars "$root"/.dev.vars.*; do
  [ -f "$src" ] || continue
  name=$(basename "$src")
  case "$name" in *.example | *.sample) continue ;; esac
  # git で管理されているものは checkout で既に入っているので対象外
  git -C "$root" ls-files --error-unmatch "$name" >/dev/null 2>&1 && continue
  [ -e "$dir/$name" ] && continue
  cp -p "$src" "$dir/$name"
  echo "==> copied $name"
done

# 依存はコピーせずインストールし直す。ブランチで依存が変わったときにずれないようにするため
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

# リポジトリ固有の後処理(ローカル DB のマイグレーションなど)は clone ごとに git config に置く。
# リポジトリに .config/wt.toml をコミットせずに済み、チームに worktrunk を強いないため
if setup=$(git config --get wt.setup); then
  echo "==> wt.setup: $setup"
  sh -c "$setup"
fi
