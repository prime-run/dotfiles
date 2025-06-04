function ffva
    set -l initial_query
    set -l max_depth 5

    if set -q argv[1]
        set initial_query $argv[1]
    end

    set -l fzf_options '--layout=reverse' \
                        '--cycle'

    if set -q initial_query
        set fzf_options $fzf_options "--query=$initial_query"
    end

    set -l selected_dir (find ~/Projects/ -maxdepth $max_depth \
        \( -name .git -o -name node_modules -o -name .venv -o -name target \
        -o -name .cache -o -name .local -o -name .cargo -o -name google-chrome \) \
        -prune -o -type d -print 2>/dev/null | fzf $fzf_options)

    if not set -q selected_dir
        return 1
    end

    set -l session_name (basename "$selected_dir" | tr '. :' '_')

    # Check if a tmux session with this name already exists
    if not tmux has-session -t=$session_name 2>/dev/null
        tmux new-session -s $session_name -c "$selected_dir" -d
        tmux send-keys -t $session_name "nvim ." C-m
    end

    set -l alacritty_inner_command "tmux attach-session -t '$session_name'"

    alacritty -e fish -c "$alacritty_inner_command" & disown
end

