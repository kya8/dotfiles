hash -d dot=~/.dotfiles
hash -d zsh=${zsh_home}

edit_named_dirs() {
    setopt LOCAL_OPTIONS
    setopt ERR_RETURN

    if [ -z "$_my_vi" ] ; then
        echo "Vi editor is not defined." >&2
        return 1
    fi

    local -r f=${zsh_home}/rc.d.local/named_dirs.zsh

    if ! [ -e "$f" ] ; then
        > "$f" <<EOF
# Add your local named directories here.
# E.g., hash -d name=dir

EOF
    fi

    # Get mtime
    local -r mtime_before=$(zstat -F '%s.%N' +mtime -- "$f")
    "$_my_vi" + -- "$f"
    local -r mtime_after=$(zstat -F '%s.%N' +mtime -- "$f")

    if [ "$mtime_before" != "$mtime_after" ] ; then
        source -- "$f"
        echo "Changes were saved. File has been re-sourced."
    else
        echo "No changes were made."
    fi
}
