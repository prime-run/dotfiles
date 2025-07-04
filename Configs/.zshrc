[ -s "/home/prime/.bun/_bun" ] && source "/home/prime/.bun/_bun"
alias ic="kitten icat"

alias ls='lsd --icon=never'
alias l=lsd
alias lt='lsd --tree'
alias ld='lsd --group-directories-first'

#custom
alias s='sudo'
alias y=yazi

#bat
alias bh='bat --color always -l help'
alias cat='bat --style=plain'

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

export PATH="$HOME/.cargo/bin:$PATH"

# eval "$(uv generate-shell-completion zsh)"
# eval "$(uvx --generate-shell-completion zsh)"
eval "$(fzf --zsh)"


_insert_history_n_ago() {
  local command

  command=$(fc -ln "-$1" "-$1" 2>/dev/null)
  command=${command##[[:space:]]}

  if [[ -n "$command" ]]; then
    LBUFFER=$command
    zle redisplay
  else
    zle push-input
    echo "No history found for number: $1" >&2
    zle reset-prompt
  fi
}

for i in {1..9}; do
  eval "
    _insert-history-${i}-ago() {
      _insert_history_n_ago $i
    }
  "
  zle -N "_insert-history-${i}-ago"
  bindkey -M emacs "^[${i}" "_insert-history-${i}-ago"
done

