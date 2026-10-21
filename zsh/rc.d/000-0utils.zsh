# Common functions, definitions that might be used by subsequent scripts

has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

zmodload -F zsh/stat b:zstat
