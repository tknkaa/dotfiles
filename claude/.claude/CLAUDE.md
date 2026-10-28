# Git

- GitHub のリポジトリをローカルに clone するときは `git clone` ではなく `ghq get` を使う(例: `ghq get owner/repo`)。そうしないと `~/ghq` 配下の配置規則から外れる。
- 新しいブランチを切るときは必ず worktree を作成する。`git checkout -b` / `git switch -c` / `git branch <name>` は使わない。
- worktree は main の root 直下の `.worktree/<branch>` に作る。`main` だけは repo root に置いたままにする。
- 既存ブランチで作業するときも main のワークツリーで checkout せず、そのブランチの worktree を使う(無ければ作る)。

## worktree の手順

worktree の作成と片付けは `wt`(github.com/tknkaa/wt)で行う。`git worktree add` を直接使わない。`.git/info/exclude` への追記、`.env` のコピー、依存のインストールを手でやると漏れるため。

```sh
wt new <branch> [<start>]   # .worktree/<branch> に作る(feat/foo -> feat-foo)。既存ブランチならそれを使う
wt list
wt clean                    # マージ済みの worktree とブランチを一覧にし、確認してから消す
```

- 作成後は出力の最後の行(worktree のパス)をユーザーに伝え、そのブランチの作業は worktree 内で行う。コピーやインストールで何をしたかも伝える。
- ローカル DB のマイグレーションなどリポジトリ固有の後処理は `git config wt.setup "<command>"` に設定しておく。未設定で必要そうなら、設定してよいかユーザーに聞く。
- ローカル DB などの状態(`.wrangler/` など)はコピーしない。ブランチでスキーマを変えても main のデータを壊さないため。main のデータが要るときだけユーザーに確認してコピーする。
- `wt clean` は確認を挟むので、AI が実行するときは対象の一覧をユーザーに見せてから、了承を得て `wt clean -y` を使う。
- 1 つだけ消す: `git worktree remove "<path>"`(dirty なら拒否される。`--force` はユーザーの同意が要る)。ブランチ削除はユーザーが求めたときだけ `git branch -d`(`-D` はユーザーの同意が要る)。

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

# ツールのインストール

- npm でグローバルにツールを入れるときは `npm install -g` を直接実行せず、dotfiles の `install.sh` の `NPM_GLOBAL_PACKAGES` に追記して dotfiles 経由で入れる。そうしないと環境を再構築したときに再現できない。

# ブラウザ操作

- ブラウザを操作するときは Claude in Chrome(`mcp__claude-in-chrome__*`)ではなく `agent-browser` を使う。
