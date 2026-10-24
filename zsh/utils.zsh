# Common functions, definitions that might be used by subsequent scripts

zmodload -F zsh/stat b:zstat

has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

has_cmds() {
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <cmd ...>"
        return 2
    fi

    local arg
    for arg in "$@" ; do
        command -v "$arg" >/dev/null 2>&1 || return 1
    done
}

is_true() {
    case "$1" in
        [Yy]|Yes|yes|YES|True|"true"|TRUE|1) return 0 ;;
    esac
    return 1
}

is_false() {
    case "$1" in
        [Nn]|No|no|NO|False|"false"|FALSE|0) return 0 ;;
        "") return 0 ;;
    esac
    return 1
}

# is in a interactive prompt (Top level and INteractive)
is_tin() {
    [[ -o interactive ]] && (( $zsh_eval_context[(Ie)toplevel] ))
}

is_exported() {
    [ -z "${(P)1+x}" ] && return 2 # Not set
    [[ "${(tP)1}" == *export* ]] && return 0 || return 1
}

debug_print() {
    [ -z "$enable_debug" ] && return 0
    print "$@"
}

debug_printf() {
    [ -z "$enable_debug" ] && return 0
    printf "$@"
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

# Source all files from arguments, in lexical order of their basenames.
# A directory argument adds all regular files under that directory (non-recursively).
merge_source() {
    if [ $# -eq 0 ] ; then
        echo >&2 "Usage: $0 <DIR|FILE ...>"
        return 2
    fi

    local -a files
    while (( $# )); do
        if [[ -d $1 ]]; then
            files+=( "$1"/*(N) )
        elif [[ -f $1 ]]; then
            files+="$1"
        else
            echo >&2 "Invalid file/directory: $1"
            return 1
        fi
        shift
    done
    # Sort by basename in lexical order, using a DSU (Schwartzian transform).
    local -r nul=$'\0'
    setopt localoptions extendedglob # Required by (#m)* pattern
    # Prepend basename+nul, sort, then remove prefix.
    files=( "${(@)${(@o)${(@)files/(#m)*/${MATCH:t}$nul$MATCH}}#*$nul}" )
    debug_print -l "Files to source (in order):" "${files[@]}"

    local f
    for f in "${files[@]}" ; do
        source "$f"
    done
}


