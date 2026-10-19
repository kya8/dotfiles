# Per-user PATH

# Make sure user bin paths are at the very front of PATH.
_prepend_user_bins() {
    local user_path="$HOME/bin:$HOME/.local/bin"
    # [[ "$PATH" == "$user_path":* ]] && return 0 # no check for duplicates
    local remaining_path="${PATH-}" path_entry

    while :; do
        path_entry="${remaining_path%%:*}"
        case "$path_entry" in
            "$HOME/bin"|"$HOME/.local/bin") ;;
            *) user_path="$user_path:$path_entry" ;;
        esac
        case "$remaining_path" in
            *:*) remaining_path="${remaining_path#*:}" ;;
            *) break ;;
        esac
    done

    PATH="$user_path"
}

_prepend_user_bins
unset -f _prepend_user_bins
