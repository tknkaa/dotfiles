---
name: check-wt
description: worktree を herdr の新しいタブで開く。ブランチ名または worktree パスを受け取り、無ければ `wt switch` で作ってから、その worktree を cwd にしたタブを作る。「worktree を別タブで開いて」「このブランチを新しいタブで」「check-wt」などで使う。
---

worktree を herdr の別タブで開く。

## 手順

1. 対象を決める。args にブランチ名かパスがあればそれを使う。無ければユーザーに聞く。
2. worktree のパスを得る。
   - `wt list` で既存の worktree を探す。
   - 無ければ `wt switch <branch> --no-cd`(新しいブランチなら `--create` も付ける)で作り、`wt list` でパスを確認する(CLAUDE.md の worktree ルールに従う)。コピーやインストールで何をしたかもユーザーに伝える。
3. タブを作る。ラベルはブランチ名にする(タブ一覧で見分けるため)。

   ```sh
   herdr tab create --cwd "<path>" --label "<branch>" --focus
   ```

   ユーザーが「フォーカスは移さないで」と言ったら `--no-focus` にする。
4. ユーザーが Claude などのコマンドを起動したいと言ったときだけ、作ったタブのペインで実行する。ペイン ID は `herdr pane list` で cwd が一致するものを探す。

   ```sh
   herdr pane run <pane_id> "claude"
   ```

5. worktree のパスと作ったタブの ID をユーザーに伝える。

## 注意

- `git worktree add` は直接使わない。必ず `wt` を使う。
- herdr の外で動いているとき(`herdr status` が失敗するとき)はタブを作れないので、パスだけ伝える。
