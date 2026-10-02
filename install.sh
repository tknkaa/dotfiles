#!/usr/bin/env bash
# Set up this Fedora machine from the dotfiles repo.
# Safe to re-run: every step skips work that is already done.
#
#   ./install.sh            # everything
#   ./install.sh stow       # only (re)link configs
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

COPR_REPOS=(
  wezfurlong/wezterm-nightly
  atim/starship
  atim/bottom
)

DNF_PACKAGES=(
  # Terminal, shell, prompt
  wezterm zsh zsh-autosuggestions zsh-syntax-highlighting starship
  # Editors
  neovim tree-sitter-cli
  # CLI utilities
  stow bat eza fzf zoxide git-delta gh ripgrep bottom httpie
  wl-clipboard xclip unzip bind-utils direnv libnotify
  # Languages & build tools
  gcc make openssl-devel golang rustup uv
  # Cloud CLIs (google-cloud-cli comes from Google's repo, added below)
  awscli2 azure-cli google-cloud-cli libxcrypt-compat
  # Database clients
  postgresql
  # Apps
  google-chrome-stable
  # Language servers not installed by mason.nvim
  clang-tools-extra gopls
  # Containers (docker CLI shim + compose)
  podman podman-docker podman-compose
  # Japanese input
  ibus-mozc
)

NPM_GLOBAL_PACKAGES=(bun pnpm hunkdiff @openai/codex opencode-ai @shopify/cli)

STOW_PACKAGES=(zsh git starship wezterm herdr nvim claude opencode)

NVM_VERSION=v0.40.8
NERD_FONTS=(JetBrainsMono FiraCode)

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

install_dnf() {
  log "Enabling COPR repositories"
  sudo dnf install -y dnf5-plugins
  for repo in "${COPR_REPOS[@]}"; do
    sudo dnf copr enable -y "$repo"
  done

  # Google Chrome repo ships with Fedora Workstation but is disabled by default
  sudo dnf install -y fedora-workstation-repositories
  sudo dnf config-manager setopt google-chrome.enabled=1

  # el10 packages are signed with the v10 key; the older key is kept too.
  log "Configuring Google Cloud CLI repository"
  sudo tee /etc/yum.repos.d/google-cloud-sdk.repo >/dev/null <<'REPO'
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el10-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key-v10.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
REPO

  log "Installing dnf packages"
  sudo dnf install -y "${DNF_PACKAGES[@]}"
}

install_user_tools() {
  mkdir -p "$HOME/.local/bin"

  if ! command -v herdr >/dev/null && [ ! -x "$HOME/.local/bin/herdr" ]; then
    log "Installing herdr"
    curl -fsSL https://herdr.dev/install.sh | sh
  fi

  if [ ! -x "$HOME/.cargo/bin/rustup" ]; then
    log "Installing Rust toolchain (rustup)"
    rustup-init -y --no-modify-path --component rust-analyzer,rust-src
  fi

  # PROFILE=/dev/null keeps the nvm installer from editing the stowed .zshrc
  export NVM_DIR="$HOME/.nvm"
  if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    log "Installing nvm"
    curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | PROFILE=/dev/null bash
  fi
  # nvm is not compatible with `set -u`
  set +u
  # shellcheck disable=SC1091
  . "$NVM_DIR/nvm.sh"
  if ! nvm ls --no-colors default >/dev/null 2>&1; then
    log "Installing Node.js LTS"
    nvm install --lts
  fi
  local pkg missing=()
  for pkg in "${NPM_GLOBAL_PACKAGES[@]}"; do
    npm ls -g --depth=0 "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
  done
  if [ "${#missing[@]}" -gt 0 ]; then
    log "Installing npm packages: ${missing[*]}"
    npm install -g "${missing[@]}"
  fi
  set -u

  if [ ! -d "$HOME/.tfenv" ]; then
    log "Installing tfenv"
    git clone --depth=1 https://github.com/tfutils/tfenv.git "$HOME/.tfenv"
  fi
}

install_fonts() {
  local dir="$HOME/.local/share/fonts"
  local font installed=0
  for font in "${NERD_FONTS[@]}"; do
    [ -d "$dir/$font" ] && continue
    log "Installing $font Nerd Font"
    mkdir -p "$dir/$font"
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.tar.xz" |
      tar -xJ -C "$dir/$font"
    installed=1
  done
  if [ "$installed" = 1 ]; then fc-cache -f "$dir"; fi
}

link_configs() {
  log "Linking configs with stow"
  # --no-folding: link individual files, so tools can still write their own
  # files next to ours (e.g. ~/.claude/skills, ~/.config/git/config.local).
  stow --no-folding -d "$DOTFILES" -t "$HOME" --restow "${STOW_PACKAGES[@]}"
}

set_login_shell() {
  local zsh_path
  zsh_path="$(command -v zsh)"
  if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]; then
    log "Changing login shell to zsh (takes effect after re-login)"
    sudo usermod -s "$zsh_path" "$USER"
  fi
}

case "${1:-all}" in
  all)
    install_dnf
    install_user_tools
    install_fonts
    link_configs
    set_login_shell
    log "Done. Log out and back in to start using zsh."
    ;;
  stow) link_configs ;;
  *)
    echo "usage: $0 [all|stow]" >&2
    exit 1
    ;;
esac
