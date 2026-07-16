WezTerm + Neovim + Nix
```sh
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier']"
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
```

## herdr

[herdr](https://herdr.dev/) is a tmux-like, agent-aware terminal multiplexer
that runs *inside* WezTerm. It owns **both tab and pane control**, so WezTerm
keeps only its fullscreen toggle (`Shift+Ctrl+n`) and everything else is driven
through herdr's prefix key. The config lives in `home-manager/herdr/config.toml`
(deployed to `~/.config/herdr/config.toml`).

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

### Usage

```sh
herdr                       # start / attach a session
herdr --default-config      # print the full default config (all options)
herdr server reload-config  # reload config.toml without restarting
```

After editing the herdr config, apply the dotfiles (`home-manager switch`) and
run `herdr server reload-config` to pick up the changes.
