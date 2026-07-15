WezTerm + Neovim + Nix
```sh
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier']"
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
```

## herdr

[herdr](https://herdr.dev/) is a tmux-like, agent-aware terminal multiplexer
that runs *inside* WezTerm. Pane and tab control is delegated to herdr, so the
matching keybindings were removed from `wezterm.lua` and live in
`home-manager/herdr/config.toml` (deployed to `~/.config/herdr/config.toml`).

The bindings are direct chords (no tmux prefix) and match what WezTerm used
before:

| Action              | Key            |
| ------------------- | -------------- |
| New tab             | `Ctrl+Shift+t` |
| Close tab           | `Ctrl+Shift+w` |
| Next tab            | `Ctrl+Tab`     |
| Previous tab        | `Ctrl+Shift+Tab` |
| Split right         | `Alt+v`        |
| Split down          | `Alt+s`        |
| Focus pane left     | `Alt+h`        |
| Focus pane down     | `Alt+j`        |
| Focus pane up       | `Alt+k`        |
| Focus pane right    | `Alt+l`        |
| Close pane          | `Alt+x`        |

Everything else stays on herdr's default `Ctrl+b` prefix (e.g. `Ctrl+b q` to
detach, `Ctrl+b ?` for help).

### Usage

```sh
herdr                       # start / attach a session
herdr --default-config      # print the full default config (all options)
herdr server reload-config  # reload config.toml without restarting
```

After editing the herdr config, apply the dotfiles (`home-manager switch`) and
run `herdr server reload-config` to pick up the changes.
