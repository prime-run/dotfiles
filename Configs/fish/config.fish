set -g fish_greeting

source ~/.config/fish/conf.d/hyde.fish


starship init fish | source
set -gx STARSHIP_CACHE $XDG_CACHE_HOME/starship
set -gx STARSHIP_CONFIG $XDG_CONFIG_HOME/starship/starship.toml


function fish_user_key_bindings
    bind -M insert \ce '$EDITOR $(fzf --preview="bat --color=always --plain {}")' 
end
set EDITOR nvim




# function df -d "Run duf with last argument if valid, else run duf"
#     if set -q argv[-1] && test -e $argv[-1]
#         duf $argv[-1]
#     else
#         duf
#     end
# end



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
alias bh='bat --color always -l help'
alias cat='bat --plain'
alias rmake='cargo make'
alias v="nvim ."
alias vim=nvim
alias vi=vim

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .... 'cd ../../..'
abbr ic 'kitten icat'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'
abbr hcd 'cd ~/'

fzf --fish | source 
for file in ~/.config/fish/functions/fzf/*.fish
    source $file
end

fish_add_path ~/.bun/bin


set -gx GOPATH $HOME/go
set -gx PATH $PATH $GOPATH/bin



bind_M_n_history

