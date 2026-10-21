mkcd() {
  if [ $# -eq 0 ]; then
    echo "mkcd: Create all directories, then cd into the last directory."
    echo
    echo "Usage: mkcd <directory ...>"
    return 2
  fi

  while [ $# -gt 0 ]; do
      mkdir -p -- "$1" || return
      if [ $# -eq 1 ] ; then
          cd -- "$1" || return
      fi
      shift
  done
}

