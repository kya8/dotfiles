#!/bin/sh

set -eu

check_cmd() {
  [ $# -ne 1 ] && return 2
  if ! command -v "$1" > /dev/null 2>&1 ; then
    printf "'%s' not found!\n" "$1" >&2
    exit 1
  fi
}

check_cmd shellcheck
check_cmd git
check_cmd xargs

CDPATH='' cd -- "$(dirname -- "$0")"

# shellcheck disable=SC2016
git ls-files -z -- '*.sh' |
  xargs -0 sh -c '
for f do
  shift
  [ -f "$f" ] || continue

  line=
  IFS= read -r line < "$f" || :
  case "$line" in
    "#!"*) echo "$f is being checked"; set -- "$@" "./$f" ;;
  esac
done

[ "$#" -eq 0 ] || exec shellcheck -e SC1071 "$@"
' sh
