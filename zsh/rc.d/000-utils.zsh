showpath() {
    printf '%s\n' "$PATH" | tr ':' '\n'
}

pathmunge() {
    setopt LOCAL_OPTIONS ERR_RETURN

    local append=0
    local check=1
    # local no_dup=0 # Avoid adding duplicate entry
    local -a paths
    local -r usage=\
"$0: Add directories to PATH.

Usage: $0 [OPTIONS] <DIR ...>

Options:
  -h: Display this help message.
  -a: Append to the end of PATH, instead of prepending.
  -n: Do not check if DIR(s) are valid. Add them as is."
  # Check for duplicates

    if [ $# -eq 0 ] ; then
        echo >&2 $usage
        return 2
    fi

    while (( $# )) ; do
        case "$1" in
            --)  shift; paths+=("${@[@]}"); break ;;
            -h)  echo $usage && return ;;
            -a)  append=1 ;;
            -n)  check=0 ;;
            -*)  echo >&2 "Bad option: '$1'. Pass '-h' for help." ; return 2 ;;
            *)   paths+="$1" ;;
        esac
        shift
    done

    local x
    if [[ $check = 1 ]] ; then
        #for ((i = 1; i <= ${#paths[@]}; i++)); do
        paths=("${paths[@]:a}") # expand all paths to absolute path
        for x in "${paths[@]}" ; do
            if [[ ! -d "$x" ]]; then
                echo >&2 "Invalid path: $x"
                return 1
            fi
        done
    fi

    local joined_paths=${(j-:-)paths}
    if [[ $append = 0 ]] ; then
        [[ -n $PATH ]] && joined_paths="${joined_paths}:"
        PATH="${joined_paths}${PATH}"
    else
        [[ -n $PATH ]] && joined_paths=":${joined_paths}"
        PATH="${PATH}${joined_paths}"
    fi
}

print_vars() {
    local var
    for var in "$@" ; do
        if is_exported "$var" ; then
            print -P "%B%F{green}${var}%f%b=${(P)var}"
        elif [ $? -eq 1 ] ; then
            print -P "%F{cyan}${var}%f=${(P)var}"
        else
            print -P "%B%F{red}${var}%f%b is not set"
        fi
    done
}

# join strings with separator
# equiv. to ${(j:separator:)@}
my_join() {
    if [ $# -lt 2 ]; then
        echo "Usage: $0 <SEP> <STR ...>"
        return 2
    fi

    local -r sep="$1"; shift
    local str arg
    str="$1"; shift
    for arg in "$@" ; do
        str="${str}${sep}${arg}"
    done
    echo $str
}
