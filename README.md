# dotfiles

Fedora (GNOME / Wayland) setup: WezTerm + herdr + Neovim + zsh.
Configs are symlinked into `$HOME` with [GNU Stow](https://www.gnu.org/software/stow/);
packages are installed by `install.sh`.

The previous NixOS / home-manager setup is kept in git history (tag `nix`).

## Setup

```sh
git clone git@github.com:tknkaa/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh   # dnf/COPR packages, cloud CLIs, herdr, rustup, nvm + Node, npm CLIs, tfenv, Nerd Fonts, stow, login shell
./gnome.sh     # Caps→Ctrl, cursor theme, Mozc input source
```

Then log out and back in (login shell becomes zsh).

## Layout

Each top-level directory is a stow package whose contents mirror `$HOME`:

| Package    | Links to                                |
| ---------- | --------------------------------------- |
| `zsh`      | `~/.zshrc`                              |
| `git`      | `~/.config/git/config`                  |
| `starship` | `~/.config/starship.toml`               |
| `wezterm`  | `~/.config/wezterm/wezterm.lua`         |
| `herdr`    | `~/.config/herdr/config.toml`           |
| `nvim`     | `~/.config/nvim/init.lua`               |
| `helix`    | `~/.config/helix/*.toml`                |
| `vscode`   | `~/.config/Code/User/settings.json`     |
| `claude`   | `~/.claude/skills/herdr/SKILL.md`       |

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

## Neovim LSPs

Language servers come from three places:

- **mason.nvim** (auto-installed on first launch): lua_ls, pyright, ts_ls,
  svelte, vue_ls, tinymist, zls, terraformls
- **dnf**: clangd (`clang-tools-extra`), gopls
- **rustup**: rust-analyzer

## herdr

[herdr](https://herdr.dev/) is a tmux-like, agent-aware terminal multiplexer
that runs *inside* WezTerm. It owns **both tab and pane control**, so WezTerm
keeps only its fullscreen toggle (`Shift+Ctrl+n`) and everything else is driven
through herdr's prefix key. The config lives in `herdr/.config/herdr/config.toml`.

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
