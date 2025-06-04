function ffvp
    set initial_query
    set max_depth 5
    if set -q argv[1]
        set initial_query $argv[1]
    end

    set fzf_options '--layout=reverse' \
        '--cycle'

    if set -q initial_query
        set fzf_options $fzf_options "--query=$initial_query"
    end

    set selected_dir (find ~/Projects/ -maxdepth $max_depth \( -name .git -o -name node_modules -o -name .venv -o -name target -o -name .cache -o -name .local -o -name .cargo -o -name google-chrome \) -prune -o -type d -print 2>/dev/null | fzf $fzf_options)
    cd "$selected_dir"; or return 1
    nvim .

end
