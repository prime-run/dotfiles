set -g fish_greeting

source ~/.config/fish/conf.d/hyde.fish


starship init fish | source
set -gx STARSHIP_CACHE $XDG_CACHE_HOME/starship
set -gx STARSHIP_CONFIG $XDG_CONFIG_HOME/starship/starship.toml



function fish_user_key_bindings
    bind -M insert \ce '$EDITOR $(fzf --preview="bat --color=always --plain {}")' 
end
set EDITOR nvim
set TAPLO_CONFIG "~/.config/.taplo.toml"


function clipcopy
    cat $argv[1] | wl-copy
end


# fish_vi_key_bindings
set -g fish_key_bindings fish_vi_key_bindings
set -g fish_autosuggestion_enabled 0
set fish_pager_color_prefix cyan
set fish_color_autosuggestion brblack



alias ls='lsd --icon=never'
alias l=lsd
alias lt='lsd --tree'
alias ld='lsd --group-directories-first'

alias s='sudo'
alias cdp='cd ~/Projects'
alias cdc='cd ~/.config'

alias y=yazi

#bat
alias bh='bat --style=grid,numbers -l help --theme=Dracula'
alias bathelp='bat --plain --language=help'

abbr --position anywhere -- --help '--help | bh'
# abbr --position anywhere -- -h '-h | bh' # just manuall pipe here!

alias cat='bat --plain'
alias btail='bat --paging=never -l log'
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

alias v="nvim ."
# alias vim=nvim
alias vi=vim

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .... 'cd ../../..'
# abbr ic 'kitten icat'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'
abbr hcd 'cd ~/'

# git stuff
abbr -a gsnp 'git status --porcelain | awk \'{print $2}\''

function batdiff
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
end


fzf --fish | source 
for file in ~/.config/fish/functions/fzf/*.fish
    source $file
end

fish_add_path ~/.bun/bin


set -gx GOPATH $HOME/go
set -gx PATH $PATH $GOPATH/bin



bind_M_n_history

bind -M default \ev ffva
bind -M insert \ev ffva



