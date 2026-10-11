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

# Open files in nvim via fzf (tracked + untracked, respects .gitignore)
fe() {
  local files
  files=("${(@f)$(git ls-files -co --exclude-standard | fzf -m --preview 'bat --color=always --line-range=:200 {}')}") || return
  [ -n "$files" ] && nvim "${files[@]}"
}

# Jump to a ghq repository via fzf
g() {
  local dir
  dir=$(ghq list -p | fzf --preview 'eza -T -L1 --color=always {}; echo; git -C {} log --oneline -5 --color=always') || return
  cd "$dir"
}

# Ctrl-G: pick a ghq repository and cd, even mid-command
ghq-fzf() {
  local dir
  dir=$(ghq list -p | fzf --height 40% --reverse --query "$LBUFFER") || { zle reset-prompt; return }
  BUFFER="cd ${(q)dir}"
  zle accept-line
}
zle -N ghq-fzf
bindkey '^g' ghq-fzf

# Switch branch via fzf (local + remote-only, newest first)
gb() {
  local b
  b=$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads refs/remotes |
    grep -v 'HEAD$' | sed 's#^origin/##' | awk '!s[$0]++' |
    fzf --preview 'git log --oneline -10 --color=always {}') || return
  git switch "$b"
}

# cd to a worktree of the current repository via fzf
gw() {
  local dir
  dir=$(git worktree list | fzf --preview 'git -C {1} status -sb' | awk '{print $1}') || return
  cd "$dir"
}

# --- Tool hooks ---
command -v direnv   >/dev/null && eval "$(direnv hook zsh)"
command -v starship >/dev/null && eval "$(starship init zsh)"

# --- Plugins (Fedora packages; syntax-highlighting must be sourced last) ---
[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] &&
  . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] &&
  . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- zoxide (must be initialized last) ---
command -v zoxide   >/dev/null && eval "$(zoxide init zsh --cmd cd)"
