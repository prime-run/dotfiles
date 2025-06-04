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
