set FNM_PATH "/home/stan/.local/share/fnm"
if test -d "$FNM_PATH"
    fish_add_path $FNM_PATH
end

if type -q fnm
    fnm env --shell fish --use-on-cd | source
    fnm completions --shell fish | source
end
