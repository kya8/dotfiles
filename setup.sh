#!/bin/sh

set -eu

[ -t 1 ] && t=1
# shellcheck disable=SC2034
{
csi='['
reset="${t+${csi}0m}"
default="${t+${csi}39m}" # reset fg color
intense="${t+${csi}1m}"

red="${t+${csi}31m}"
redi="${t+${csi}1;31m}"
green="${t+${csi}32m}"
greeni="${t+${csi}1;32m}"
yellow="${t+${csi}33m}"
yellowi="${t+${csi}1;33m}"
blue="${t+${csi}34m}"
bluei="${t+${csi}1;34m}"
magenta="${t+${csi}35m}"
magentai="${t+${csi}1;35m}"
cyan="${t+${csi}36m}"
cyani="${t+${csi}1;36m}"

gray="${t+${csi}38;5;245m}"
grayi="${t+${csi}1;38;5;245m}"
orange="${t+${csi}38;5;202m}"
orangei="${t+${csi}1;38;5;202m}"
}

os_type=$(uname -s)

case "${os_type}" in
    Linux*)
        os_type=linux
        ;;
    Darwin*)
        os_type=macos
        ;;
    FreeBSD)
        os_type=freebsd
        ;;
#     CYGWIN_NT*)
#         os_type=cygwin
#         ;;
#     MINGW*)
#         os_type=mingw
#         ;;
    *)
        echo "Unknown OS"
        exit 1
        ;;
esac

echo "${grayi}---${reset} OS type: ${cyani}${os_type}${reset}"

dotfiles=$(git -C "$(dirname -- "$0")" rev-parse --show-toplevel)
echo "${grayi}---${reset} Using dotfiles repo: ${orangei}${dotfiles}${reset}"

my_link() {
    if [ -e "$2" ]; then
        if [ -d "$2" ]; then
            color="$bluei"
        else
            color="$intense"
        fi
        echo "${yellow}Skipping existing entry:${reset} ${color}$2${reset}"
        return 0
    else
        if [ -d "$1" ]; then
            color="$blue"
        else
            color="$default"
        fi
        echo "${green}Linking${reset} ${cyani}$2${default} -> ${color}$1${reset}"
        ln -sf "$1" "$2" # -e returns false for dangling symlinks, overwrite them with -f
    fi
}

supported_os="linux macos freebsd"

link_dir() {
    for src in "$1"/*; do
        [ -e "$src" ] || continue # Prevent unexpanded *
        pkg="${src##*/}"
        skip=0
        has_suffix=0
        for os in ${supported_os}; do
            pkg_name="${pkg%."${os}"}"
            if [ "$pkg_name" != "$pkg" ] ; then
                has_suffix=1
                if [ "$os" != "$os_type" ]; then
                    echo "${yellow}Skipping ${magentai}${pkg}${reset}"
                    skip=1
                fi
                break;
            fi
        done
        # Skip non-specific entry if os-specific entry is present
        if [ ${has_suffix} = 0 ] && [ -e "${src}.${os_type}" ]; then
            echo "${yellow}Skipping ${magentai}${pkg}${reset}"
            skip=1
        fi
        [ ${skip} = 1 ] && continue
        my_link "$src" "$2/$pkg_name"
    done
}

#my_link "${dotfiles}/zsh" "${HOME}/.zsh"
my_link "${dotfiles}/zsh/zshrc" "${HOME}/.zshrc"
my_link "${dotfiles}/vimrc" "${HOME}/.vimrc"

config_dir=${XDG_CONFIG_HOME:-${HOME}/.config}
mkdir -p "$config_dir"
config_src=${dotfiles}/config
[ -d "${config_src}" ] && link_dir "$config_src" "$config_dir"


echo "${grayi}--- ${default}Setup done!${reset}"
