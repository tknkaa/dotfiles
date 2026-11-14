# Git

- GitHub のリポジトリをローカルに clone するときは `git clone` ではなく `ghq get` を使う(例: `ghq get owner/repo`)。そうしないと `~/ghq` 配下の配置規則から外れる。
- 新しいブランチを切るときは必ず worktree を作成する。`git checkout -b` / `git switch -c` / `git branch <name>` は使わない。
- worktree は `~/worktrees/<owner>/<repo>/<branch>` に作る(feat/foo -> feat-foo)。`main` だけは ghq の repo root に置いたままにする。repo の中に置くと親の CLAUDE.md や node_modules を拾い、ghq の配下に置くと `ghq list` に混ざるため。
- 既存ブランチで作業するときも main のワークツリーで checkout せず、そのブランチの worktree を使う(無ければ作る)。

## worktree の手順

worktree の作成と片付けは worktrunk(`wt`)で行う。`git worktree add` を直接使わない。作成時の pre-start フック(`wt-setup-worktree`)が `.env` のコピー、依存のインストール、`wt.setup` の実行を行い、手でやると漏れるため。

```sh
wt switch --create <branch> [--base <start>] --no-cd  # 新しいブランチの worktree を作る
wt switch <branch> --no-cd                            # 既存ブランチの worktree を作る(あればそれを使う)
wt list
wt step prune --dry-run                               # main に取り込み済み(squash も含む)の worktree とブランチの一覧
wt remove <branch>                                    # 1 つ消す。未マージのブランチは消さない
```

- AI は shell が cd しないので `--no-cd` を付け、パスは `wt list` で確認する。作成後は worktree のパスをユーザーに伝え、そのブランチの作業は worktree 内で行う。コピーやインストールで何をしたかも伝える。
- ローカル DB のマイグレーションなどリポジトリ固有の後処理は `git config wt.setup "<command>"` に設定しておく。未設定で必要そうなら、設定してよいかユーザーに聞く。
- ローカル DB などの状態(`.wrangler/` など)はコピーしない。ブランチでスキーマを変えても main のデータを壊さないため。main のデータが要るときだけユーザーに確認してコピーする。
- まとめて消すときは `wt step prune --dry-run` の一覧をユーザーに見せ、了承を得てから `wt step prune -y` を使う。
- close されただけで main に入っていないブランチは prune では消えない。消すには `wt remove <branch> -D` が要り、ユーザーの同意が要る。`--force`(未コミットの変更ごと消す)も同じ。

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
- description は短くする。書くのは、何をなぜ変えるかの概要と、レビュアーやリリース担当が知らないと事故になること(デプロイ順など)だけにする。変更ファイルの列挙、費用試算、確認項目のチェックリストは書かない。そうしないと長すぎて読まれず、重要な点が埋もれる。

# ドキュメント

- 太字を多用しない。本当に強調が必要な箇所だけに絞る。そうしないと強調が埋もれて、どこが重要か読み取れなくなる。

# Terraform

- CI で `terraform plan` する構成のリポジトリでは、まずローカルで実行する必要があるかを考える。CI の plan で足りるならローカルでは実行しない。ローカルで実行すると state のロックを取り、中断やエラーでロックが残ると CI の plan が失敗するため。
- ローカルで実行する必要がある場合(CI では確認できない、すぐ結果が要るなど)は、実行後にロックが残っていないか確認する。残っていたらユーザーに伝え、`terraform force-unlock` はユーザーの同意を得てから行う。

# ツールのインストール

- npm でグローバルにツールを入れるときは `npm install -g` を直接実行せず、dotfiles の `install.sh` の `NPM_GLOBAL_PACKAGES` に追記して dotfiles 経由で入れる。そうしないと環境を再構築したときに再現できない。

# ブラウザ操作

- ブラウザを操作するときは Claude in Chrome(`mcp__claude-in-chrome__*`)ではなく `agent-browser` を使う。
- Chrome のプロファイルのログイン状態を使うときは `agent-browser --profile <name> --args "--password-store=gnome-libsecret" open <url>` で開く。agent-browser は既定で `--password-store=basic` で起動するため、そのままだと Cookie を復号できず Google や Slack のログインが引き継がれない。プロファイル名は `agent-browser profiles` で確認する(例: ZERO COLOR は `Default`)。- bot 判定のあるページ(Shopify アプリなど)は `--user-agent` で通常の Chrome の UA を指定して開く(例: `--user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/<version>.0.0.0 Safari/537.36"`)。headless だと UA に `HeadlessChrome` が入り、弾かれる(Shopify アプリは 410 を返す)。
- Slack のパーマリンクはデスクトップアプリへのリダイレクト画面で止まるので、`https://app.slack.com/client/<team>/<channel>/thread/<channel>-<ts>` の形で開く。

# URL の書き方

- URL は `[タイトル](URL)` のような Markdown リンクにせず、URL をそのまま書く。Web 検索の出典も同じ。そうしないとターミナルで URL をコピーしにくい。
