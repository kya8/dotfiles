if cmd_exists nvim ; then
    alias v=nvim
    alias vv="nvim -R"
    readonly -g _my_vi=nvim
elif cmd_exists vim ; then
    alias v=vim
    alias vv=view
    readonly -g _my_vi=vim
else
    alias v=vi
    readonly -g _my_vi=vi
fi
