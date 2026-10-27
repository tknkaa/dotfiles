# Git

- GitHub のリポジトリをローカルに clone するときは `git clone` ではなく `ghq get` を使う(例: `ghq get owner/repo`)。そうしないと `~/ghq` 配下の配置規則から外れる。
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

# 一時ファイル

- repo root 直下の `tmp` は使わない。代わりに repo root 直下に `./.tmp` を作って使う。
- `.tmp` は `.git/info/exclude` で除外する(`.gitignore` は触らない)。clone ごとなので毎回冪等に追記する:

```sh
common=$(git rev-parse --path-format=absolute --git-common-dir)
root=$(dirname "$common")
mkdir -p "$common/info" "$root/.tmp"
grep -qxF '/.tmp/' "$common/info/exclude" 2>/dev/null || echo '/.tmp/' >> "$common/info/exclude"
```

# コードコメント

- コメントは日本語で書く。英語では書かない。
- 理由、その帰結の順に書く(例: `// 外部APIは稀に重複通知を送るため、IDで重複排除する。そうしないと二重課金になる`)。
- 何をしているかの説明ではなく、なぜそうするのかを書く。

# Pull Request

- `gh pr create` / `gh stack submit` など PR の作成は、ユーザーが明示的に指示したときだけ行う。

# ドキュメント

- 太字を多用しない。本当に強調が必要な箇所だけに絞る。そうしないと強調が埋もれて、どこが重要か読み取れなくなる。

# Terraform

- CI で `terraform plan` する構成のリポジトリでは、まずローカルで実行する必要があるかを考える。CI の plan で足りるならローカルでは実行しない。ローカルで実行すると state のロックを取り、中断やエラーでロックが残ると CI の plan が失敗するため。
- ローカルで実行する必要がある場合(CI では確認できない、すぐ結果が要るなど)は、実行後にロックが残っていないか確認する。残っていたらユーザーに伝え、`terraform force-unlock` はユーザーの同意を得てから行う。
