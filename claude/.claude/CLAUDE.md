# Git

- 新しいブランチを切るときは必ず worktree を作成する。`git checkout -b` / `git switch -c` / `git branch <name>` は使わない。
- worktree は main の root 直下の `.worktree/<branch>` に作る。`main` だけは repo root に置いたままにする。
- 既存ブランチで作業するときも main のワークツリーで checkout せず、そのブランチの worktree を使う(無ければ作る)。

## worktree の手順

linked worktree 内から実行しても動くよう、common git dir から root を求める:

```sh
common=$(git rev-parse --path-format=absolute --git-common-dir)
root=$(dirname "$common")
mkdir -p "$common/info"
grep -qxF '/.worktree/' "$common/info/exclude" 2>/dev/null || echo '/.worktree/' >> "$common/info/exclude"
dir="$root/.worktree/${branch//\//-}"   # feat/foo -> feat-foo
git worktree add -b "$branch" "$dir" [<start>]   # 新規ブランチ(start 省略時は main を基点にする)
git worktree add "$dir" "$branch"                # 既存ブランチ
```

- `.gitignore` は触らない。除外は `.git/info/exclude` のみ(clone ごとなので毎回上の冪等な追記を行う)。
- 既に別の場所で checkout 済みのブランチには作らない(先に `git worktree list`)。
- 作成後はそのパスをユーザーに伝え、そのブランチの作業は worktree 内で行う。
- 削除: `git worktree remove "$root/.worktree/<name>"`(dirty なら拒否される。`--force` はユーザーの同意が要る)、手で消されたものは `git worktree prune`。
- ブランチ削除はユーザーが求めたときだけ。`git branch -d`(`-D` は使わない)。
- 依存関係や env ファイルは worktree にコピーされない。必要ならユーザーに伝える。

# Pull Request

- `gh pr create` / `gh stack submit` など PR の作成は、ユーザーが明示的に指示したときだけ行う。
- 変更は先に difit でユーザーがローカル確認する。確認前に PR を作らない。
