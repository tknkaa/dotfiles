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
| `mimeapps` | `~/.config/mimeapps.list` (default apps: PDF/HTML → Chrome) |

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

## Docs

Tool-specific notes live in [`docs/`](docs/):

- [Claude Code](docs/claude-code.md) — how to insert a newline (`Ctrl+J`)
- [herdr](docs/herdr.md) — keybindings and commands
- [Neovim](docs/neovim.md) — LSP sources
- [fcitx5 + Mozc](docs/fcitx5.md) — Japanese input on GNOME/Wayland
