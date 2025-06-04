function ffvp
    set -l initial_query
    set -l max_depth 5 

    if set -q argv[1]
        set initial_query $argv[1]
    end

    set -l fzf_options '--layout=reverse' \
                        '--cycle' \
                        '--prompt="Select project directory: "'

    if set -q initial_query
        set fzf_options $fzf_options "--query=$initial_query"
    end

    set -l selected_dir (find ~/Projects/ -maxdepth $max_depth \
        \( -name .git -o -name node_modules -o -name .venv -o -name target \
        -o -name .cache -o -name .local -o -name .cargo -o -name google-chrome \) \
        -prune -o -type d -print 2>/dev/null | fzf $fzf_options)

    if not set -q selected_dir
        echo "No directory selected. Aborting."
        return 1
    end

    set -l alacritty_command "cd '$selected_dir' && tmux new -s fzf-nvim nvim ."

    alacritty msg create-window --command fish -c "$alacritty_command"

    echo "Opened '$selected_dir' in a new Alacritty window with tmux and nvim."
end

