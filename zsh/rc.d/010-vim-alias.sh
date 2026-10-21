if has_cmd nvim ; then
    alias v=nvim
    alias vv="nvim -R"
    readonly -g _my_vi=nvim
elif has_cmd vim ; then
    alias v=vim
    alias vv=view
    readonly -g _my_vi=vim
else
    alias v=vi
    readonly -g _my_vi=vi
fi
