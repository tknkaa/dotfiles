# Claude Code

## 改行

**Shift+Enter では改行できない。`Ctrl+J` を使う。**

Ptyxis (VTE) は Shift+Enter を Enter と同じ `\r` として送り、Kitty keyboard
protocol / modifyOtherKeys にも非対応。herdr や Claude Code の設定では区別できない。

| 方法          | 操作                         |
| ------------- | ---------------------------- |
| `Ctrl+J`      | そのまま改行                 |
| `\` + Enter   | 行末に `\` を打って Enter   |

Shift+Enter を使いたい場合は Kitty protocol 対応の端末 (Ghostty, kitty, WezTerm, foot など) に替える。
