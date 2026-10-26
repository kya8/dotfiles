popn() {
    local n=${1:-0}
    if ! is_digits "$n" ; then
        echo >&2 "Usage: $0 [NUM]"
        return 2
    fi

    if (( n > 0 )); then
        dirstack=("${(@)dirstack[((n+1)),-1]}")
    fi
    popd
}
