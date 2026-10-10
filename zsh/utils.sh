# Common functions, definitions used in sourced scriptlets

cmd_exists() {
    command -v "$1" >/dev/null 2>&1
}
