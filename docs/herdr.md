# herdr

[herdr](https://herdr.dev/) is a tmux-like, agent-aware terminal multiplexer
that runs *inside* the terminal (Ptyxis). It owns **both tab and pane control**,
so everything is driven through herdr's prefix key. The config lives in `herdr/.config/herdr/config.toml`.

The **prefix is `Ctrl+a`** — press it, release, then the action key:

| Action        | Key           |     | Action           | Key           |
| ------------- | ------------- | --- | ---------------- | ------------- |
| New tab       | `Ctrl+a` `b`  |     | Split right      | `Ctrl+a` `v`  |
| Close tab     | `Ctrl+a` `x`  |     | Split down       | `Ctrl+a` `s`  |
| Previous tab  | `Ctrl+a` `u`  |     | Focus pane ←     | `Ctrl+a` `h`  |
| Next tab      | `Ctrl+a` `i`  |     | Focus pane ↓     | `Ctrl+a` `j`  |
| Zoom (全画面) | `Ctrl+a` `n`  |     | Focus pane ↑     | `Ctrl+a` `k`  |
|               |               |     | Focus pane →     | `Ctrl+a` `l`  |
|               |               |     | Close pane       | `Ctrl+a` `d`  |

Other herdr defaults still apply on the same prefix (e.g. `Ctrl+a` `q` to
detach, `Ctrl+a` `?` for help). Run `herdr --default-config` for the full list.

```sh
herdr                       # start / attach a session
herdr --default-config      # print the full default config (all options)
herdr server reload-config  # reload config.toml without restarting
herdr update                # update the herdr binary
```

herdr reads the symlinked config, so after editing just run
`herdr server reload-config`.
