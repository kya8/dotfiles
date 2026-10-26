ud() {
    local n=${1:-1}
    if ! is_digits "$n" || (( n < 1 )) || (( n > 256 )); then
        echo >&2 "Usage: $0 [NUM]"
        return 2
    fi

    local arg=
    while (( n-- > 0 )); do
        [ -z "$arg" ] && arg=.. || arg="${arg}/.."
    done

    cd -- "$arg"
}
