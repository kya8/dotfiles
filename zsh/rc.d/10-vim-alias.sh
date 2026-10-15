if cmd_exists nvim ; then
    alias v=nvim
    alias vv="nvim -R"
elif cmd_exists vim; then
    alias v=vim
    alias vv=view
fi
