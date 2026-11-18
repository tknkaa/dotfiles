#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

COPR_REPOS=(
  atim/starship
  atim/bottom
)

DNF_PACKAGES=(
  ptyxis zsh zsh-autosuggestions zsh-syntax-highlighting starship
  neovim tree-sitter-cli
  stow bat eza fzf zoxide git-delta gh ripgrep bottom httpie just
  wl-clipboard xclip unzip bind-utils direnv libnotify
  gcc make openssl-devel golang rustup uv
  awscli2 azure-cli google-cloud-cli libxcrypt-compat
  postgresql sqlite
  google-chrome-stable
  clang-tools-extra gopls
  podman podman-docker podman-compose
  fcitx5 fcitx5-mozc fcitx5-autostart fcitx5-configtool
  syncthing
)

NPM_GLOBAL_PACKAGES=(bun pnpm hunkdiff @openai/codex opencode-ai @shopify/cli cf difit @marp-team/marp-cli agent-browser)

STOW_PACKAGES=(zsh git starship herdr nvim claude opencode fcitx5 mimeapps bin worktrunk)

NPM_ALLOW_SCRIPTS=(bun pnpm opencode-ai agent-browser @anthropic-ai/claude-code esbuild @parcel/watcher workerd)

NVM_VERSION=v0.40.8
NODE_VERSION=v26.13.0
ELAN_VERSION=v4.2.4
GHQ_VERSION=v1.11.2
COOLIFY_VERSION=v1.11.0
WORKTRUNK_VERSION=0.81.0
K6_VERSION=v2.3.0
XK6_VERSION=v1.4.15
K6_MQTT_K6_VERSION=v1.8.2
XK6_MQTT_VERSION=v0.40.3
NERD_FONTS=(JetBrainsMono FiraCode)

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

install_dnf() {
  log "Enabling COPR repositories"
  sudo dnf install -y dnf5-plugins
  for repo in "${COPR_REPOS[@]}"; do
    sudo dnf copr enable -y "$repo"
  done

  sudo dnf install -y fedora-workstation-repositories
  sudo dnf config-manager setopt google-chrome.enabled=1

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

  if [ ! -x "$HOME/.cargo/bin/typst" ]; then
    log "Installing typst (cargo)"
    "$HOME/.cargo/bin/cargo" install --locked typst-cli
  fi

  if [ ! -x "$HOME/.cargo/bin/wt" ]; then
    log "Installing worktrunk (cargo)"
    "$HOME/.cargo/bin/cargo" install --locked worktrunk@"$WORKTRUNK_VERSION"
  fi

  if [ ! -x "$HOME/.elan/bin/elan" ]; then
    log "Installing elan (cargo)"
    OPENSSL_NO_VENDOR=1 "$HOME/.cargo/bin/cargo" install --locked --git https://github.com/leanprover/elan --tag "$ELAN_VERSION" elan
    "$HOME/.cargo/bin/elan-init" -y --no-modify-path --default-toolchain none
    "$HOME/.cargo/bin/cargo" uninstall elan
  fi

  if [ ! -x "$HOME/.local/bin/k6" ]; then
    log "Installing k6 $K6_VERSION"
    curl -fsSL "https://github.com/grafana/k6/releases/download/$K6_VERSION/k6-$K6_VERSION-linux-amd64.tar.gz" |
      tar -xz -C "$HOME/.local/bin" --strip-components=1 "k6-$K6_VERSION-linux-amd64/k6"
  fi

  if [ ! -x "$HOME/.local/bin/k6-mqtt" ]; then
    log "Building k6-mqtt (xk6)"
    GOBIN="$HOME/.local/bin" go install go.k6.io/xk6/cmd/xk6@"$XK6_VERSION"
    "$HOME/.local/bin/xk6" build "$K6_MQTT_K6_VERSION" \
      --with github.com/pmalhaire/xk6-mqtt@"$XK6_MQTT_VERSION" \
      --output "$HOME/.local/bin/k6-mqtt"
  fi

  export NVM_DIR="$HOME/.nvm"
  if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    log "Installing nvm"
    curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | PROFILE=/dev/null bash
  fi
  set +u
  . "$NVM_DIR/nvm.sh"
  if ! nvm ls --no-colors "$NODE_VERSION" >/dev/null 2>&1; then
    log "Installing Node.js $NODE_VERSION"
    nvm install "$NODE_VERSION"
  fi
  nvm alias default "$NODE_VERSION" >/dev/null
  nvm use "$NODE_VERSION" >/dev/null
  local pkg missing=()
  for pkg in "${NPM_GLOBAL_PACKAGES[@]}"; do
    npm ls -g --depth=0 "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
  done
  if [ "${#missing[@]}" -gt 0 ]; then
    log "Installing npm packages: ${missing[*]}"
    npm install -g --allow-scripts="$(IFS=,; echo "${NPM_ALLOW_SCRIPTS[*]}")" "${missing[@]}"
  fi
  set -u

  if [ ! -x "$HOME/go/bin/ghq" ]; then
    log "Installing ghq"
    go install github.com/x-motemen/ghq@"$GHQ_VERSION"
  fi

  if [ ! -x "$HOME/go/bin/coolify" ]; then
    log "Installing coolify-cli"
    go install github.com/coollabsio/coolify-cli/coolify@"$COOLIFY_VERSION"
  fi

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
  stow --no-folding -d "$DOTFILES" -t "$HOME" --restow "${STOW_PACKAGES[@]}"
}

enable_user_services() {
  log "Enabling user services"
  systemctl --user enable --now syncthing.service
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
    enable_user_services
    set_login_shell
    log "Done. Log out and back in to start using zsh."
    ;;
  stow) link_configs ;;
  *)
    echo "usage: $0 [all|stow]" >&2
    exit 1
    ;;
esac
