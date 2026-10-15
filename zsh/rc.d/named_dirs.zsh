hash -d dot=~/.dotfiles
hash -d zsh=${zsh_home}

# readonly -g _my_local_named_dirs=${zsh_home}/rc.d.local/named_dirs.zsh

edit_named_dirs() {
    v -- "${zsh_home}/rc.d.local/named_dirs.zsh"
}
