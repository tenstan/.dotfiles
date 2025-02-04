if not contains "/home/stan/.fzf/bin" $PATH
    fish_add_path "/home/stan/.fzf/bin"
end

if type -q fzf
    fzf --fish | source
end
