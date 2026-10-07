# dotfiles

Fedora (GNOME / Wayland) setup: Ptyxis + herdr + Neovim + zsh.
Configs are symlinked into `$HOME` with [GNU Stow](https://www.gnu.org/software/stow/);
packages are installed by `install.sh`.

The previous NixOS / home-manager setup is kept in git history (tag `nix`).

## Setup

```sh
git clone git@github.com:tknkaa/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh   # dnf/COPR packages, cloud CLIs, herdr, rustup, nvm + Node, npm CLIs, tfenv, Nerd Fonts, stow, login shell
./gnome.sh     # Caps→Ctrl, cursor theme, keyboard layout (Mozc runs via fcitx5), Ptyxis font + VS Code palette
```

Then log out and back in (login shell becomes zsh).

## Layout

Each top-level directory is a stow package whose contents mirror `$HOME`:

| Package    | Links to                                |
| ---------- | --------------------------------------- |
| `zsh`      | `~/.zshrc`                              |
| `git`      | `~/.config/git/config`                  |
| `starship` | `~/.config/starship.toml`               |
| `herdr`    | `~/.config/herdr/config.toml`           |
| `nvim`     | `~/.config/nvim/init.lua`               |
| `claude`   | `~/.claude/skills/herdr/SKILL.md`       |
| `opencode` | `~/.config/opencode/opencode.jsonc`     |
| `fcitx5`   | `~/.config/fcitx5/`, `~/.config/environment.d/fcitx5.conf` |

Because these are symlinks, editing `~/.config/...` edits the repo directly.

To add a new config: create `<pkg>/<path relative to $HOME>`, add `<pkg>` to
`STOW_PACKAGES` in `install.sh`, and run `./install.sh stow`.

## Files kept out of the repo

- `~/.config/secrets.env` — API keys, sourced by `.zshrc`:
  ```sh
  export GEMINI_API_KEY="..."
  export GOOGLE_GENERATIVE_AI_API_KEY="$GEMINI_API_KEY"
  export KAGGLE_API_TOKEN="..."
  export CLOUDFLARE_ACCOUNT_ID="..."
  ```
- `~/.config/git/config.local` — git identity:
  ```ini
  [user]
  	name = ...
  	email = ...
  ```

## Japanese input (fcitx5 + Mozc)

IBus was replaced by fcitx5 (`fcitx5-mozc`). On GNOME/Wayland, fcitx5's own
candidate window (Classic UI) appears slightly off the cursor, because Wayland
apps cannot report absolute screen positions and GNOME lacks `input-method-v2`.
The fix is to let GNOME Shell draw the candidates via **kimpanel**:

- fcitx5 side (in the repo): `fcitx5/.config/fcitx5/config` sets
  `DisabledAddons=classicui`; the kimpanel addon ships with the `fcitx5` package.
- GNOME side (**manual**, not scripted): install the
  [Input Method Panel](https://extensions.gnome.org/extension/261/kimpanel/) extension (`kimpanel@kde.org`)
  from extensions.gnome.org and enable it. If it is missing, candidates will not
  show at all — delete `~/.config/fcitx5/config` and run `fcitx5 -r` to revert.
- `~/.config/environment.d/fcitx5.conf` sets `XMODIFIERS` / `QT_IM_MODULE`, so log
  out and back in after the first install. IBus must not be in the GNOME input
  sources (`gnome.sh` sets only `xkb jp`).

Note: `fcitx5-configtool` rewrites the symlinked `profile` with extra comments;
discard that diff rather than committing it.

## Neovim LSPs

Language servers come from three places:

- **mason.nvim** (auto-installed on first launch): lua_ls, pyright, ts_ls,
  svelte, vue_ls, tinymist, terraformls
- **dnf**: clangd (`clang-tools-extra`), gopls
- **rustup**: rust-analyzer

## herdr

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
