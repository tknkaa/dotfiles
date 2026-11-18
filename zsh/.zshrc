
typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$HOME/.elan/bin"
  "$HOME/go/bin"
  "$HOME/.bun/bin"
  "$HOME/.npm-global/bin"
  "$HOME/.tfenv/bin"
  $path
)

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt share_history hist_ignore_dups hist_ignore_space hist_expire_dups_first

export EDITOR=nvim
export VISUAL=nvim

bindkey -e

autoload -Uz compinit && compinit

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

[ -f "$HOME/.config/secrets.env" ] && . "$HOME/.config/secrets.env"

alias cat="bat"
alias grep="rg"
alias ls="eza --icons always --classify always"
alias tree="eza --icons always --classify always --tree"
n() { nvim "${@:-.}" }
alias vi="nvim"
alias vim="nvim"
alias c="claude"
alias h="herdr"
alias gst="git status"
alias glg="git log --oneline -5"
alias x="wl-copy"

fe() {
  local files
  files=("${(@f)$(git ls-files -co --exclude-standard | fzf -m --preview 'bat --color=always --line-range=:200 {}')}") || return
  [ -n "$files" ] && nvim "${files[@]}"
}

g() {
  local dir
  dir=$(ghq list -p | fzf --preview 'eza -T -L1 --color=always {}; echo; git -C {} log --oneline -5 --color=always') || return
  cd "$dir"
}

ghq-fzf() {
  local dir
  dir=$(ghq list -p | fzf --height 40% --reverse --query "$LBUFFER") || { zle reset-prompt; return }
  BUFFER="cd ${(q)dir}"
  zle accept-line
}
zle -N ghq-fzf
bindkey '^g' ghq-fzf

gb() {
  local b
  b=$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads refs/remotes |
    grep -v 'HEAD$' | sed 's#^origin/##' | awk '!s[$0]++' |
    fzf --preview 'git log --oneline -10 --color=always {}') || return
  git switch "$b"
}

gw() {
  local dir
  dir=$(git worktree list | fzf --preview 'git -C {1} status -sb' | awk '{print $1}') || return
  cd "$dir"
}

command -v direnv   >/dev/null && eval "$(direnv hook zsh)"
command -v starship >/dev/null && eval "$(starship init zsh)"
command -v wt       >/dev/null && eval "$(command wt config shell init zsh)"

[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] &&
  . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] &&
  . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

command -v zoxide   >/dev/null && eval "$(zoxide init zsh --cmd cd)"

export PATH="/home/tknkaa/.local/bin:$PATH"
