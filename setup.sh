#!/bin/sh

set -e

csi='['
# shellcheck disable=SC2034
if [ -t 1 ] ; then
  reset="${csi}0m"
  default="${csi}39m" # reset fg color
  intense="${csi}1m"
  bold=${intense}

  red="${csi}31m"
  redi="${csi}1;31m"
  green="${csi}32m"
  greeni="${csi}1;32m"
  yellow="${csi}33m"
  yellowi="${csi}1;33m"
  blue="${csi}34m"
  bluei="${csi}1;34m"
  magenta="${csi}35m"
  magentai="${csi}1;35m"
  cyan="${csi}36m"
  cyani="${csi}1;36m"

  gray="${csi}38;5;245m"
  grayi="${csi}1;38;5;245m"
  orange="${csi}38;5;202m"
  orangei="${csi}1;38;5;202m"

  underline="${csi}4m"
  ubold="${csi}1;4m"
fi

os_type=$(uname -s)
force=0 # Overwrite existing symlinks
check_sm=1

usage() {
  echo "${ubold}Usage:${reset} ${bold}${0##*/}${reset} [OPTIONS]"
  echo
  echo "${ubold}Options:${reset}"
  echo "  ${bold}-f, --force${reset}            Force overwrite symlinks"
  echo "  ${bold}-h, --help${reset}             Show this help message"
  echo "  ${bold}-s, --skip-submodules${reset}  Skip checking submodules"
}

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

while [ $# -gt 0 ]; do
  case "$1" in
    -f|--force)
      force=1 ;;
    -h|--help)
      usage
      exit 0
      ;;
    -s|--skip-submodules)
      check_sm=0 ;;
    -*)
      echo >&2 "Invalid option: $1"
      exit 2
      ;;
    *)
      echo >&2 "Invalid argument: $1"
      exit 2
      ;;
  esac
  shift
done

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

if has_cmd git ; then
  dotfiles=$(git -C "$(dirname -- "$0")" rev-parse --show-toplevel)
else
  dotfiles=$(dirname -- "$0")
fi

echo "${grayi}---${reset} Using dotfiles repo: ${orangei}${dotfiles}${reset}"

if [ "$check_sm" = 1 ]; then
  if has_cmd git ; then
    echo "${grayi}---${reset} Checking git submodules..."
    git -C "$dotfiles" submodule update --init --recursive
  else
    echo "${grayi}---${reset} Git was not found. Skipping submodule check."
  fi
fi

my_link() {
  # -e returns false for dangling symlinks
  if [ -e "$2" ] && [ "$force" = 0 ]; then
    if [ -L "$2" ]; then
      color="$magentai"
      id_entry="link:"
    elif [ -d "$2" ]; then
      color="$bluei"
      id_entry="dir :"
    else
      color="$intense"
      id_entry="file:"
    fi
    echo "${yellow}Skipping existing ${id_entry}${reset} ${color}$2${reset}"
    return 0
  else
    if [ -d "$1" ]; then
      color="$blue"
    else
      color="$default"
    fi
    if [ -e "$2" ]; then
      echo "${orangei}Overwriting link${reset} ${magentai}$2${default} -> ${color}$1${reset}"
    else
      echo "${green}Linking${reset} ${magentai}$2${default} -> ${color}$1${reset}"
    fi
    ln -sfn "$1" "$2"
    # `-n' is not standard, but supported on GNU and BSD variants of ln
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
          echo "${yellow}Skipping ${grayi}${pkg}${reset}"
          skip=1
        fi
        break;
      fi
    done
    # Skip non-specific entry if os-specific entry is present
    if [ ${has_suffix} = 0 ] && [ -e "${src}.${os_type}" ]; then
      echo "${yellow}Skipping ${grayi}${pkg}${reset}"
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
