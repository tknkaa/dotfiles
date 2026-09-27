# ~/.zshrc — deployed by `stow zsh` from ~/dotfiles

# --- PATH ---
typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$HOME/go/bin"
  "$HOME/.bun/bin"
  "$HOME/.npm-global/bin"
  "$HOME/.tfenv/bin"
  $path
)

# --- History ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt share_history hist_ignore_dups hist_ignore_space hist_expire_dups_first

export EDITOR=nvim
export VISUAL=nvim

# Emacs-style line editing (zsh would switch to vi mode if EDITOR contains "vi")
bindkey -e

# --- Completion ---
autoload -Uz compinit && compinit

# --- Node (nvm) ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# --- Secrets ---
# API keys live outside the repo. Example ~/.config/secrets.env:
#   export GEMINI_API_KEY="..."
[ -f "$HOME/.config/secrets.env" ] && . "$HOME/.config/secrets.env"

# --- Aliases ---
alias cat="bat"
alias grep="rg"
alias ls="eza --icons always --classify always"
alias tree="eza --icons always --classify always --tree"
alias n="nvim"
alias vi="nvim"
alias vim="nvim"
alias c="claude"
alias gst="git status"
alias glg="git log --oneline -5"
alias x="wl-copy"

# Open a git-tracked file in nvim via fzf
ni() {
  local file
  file=$(git ls-files | fzf) && nvim "$file"
}

# --- Tool hooks ---
command -v zoxide   >/dev/null && eval "$(zoxide init zsh --cmd cd)"
command -v direnv   >/dev/null && eval "$(direnv hook zsh)"
command -v starship >/dev/null && eval "$(starship init zsh)"

# --- Plugins (Fedora packages; syntax-highlighting must be sourced last) ---
[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] &&
  . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] &&
  . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
