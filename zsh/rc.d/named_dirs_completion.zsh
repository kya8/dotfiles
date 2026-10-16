# Adds partial named directory completion,
# e.g., ~n/t/dir -> ~name/to/dir

autoload -Uz +X _path_files
functions[_orig_path_files]=$functions[_path_files]

_path_files() {
  if [[ $PREFIX == \~?*/* ]]; then
    local name=${${PREFIX#\~}%%/*}
    local -a matches=( ${(k)nameddirs[(I)${name}*]} )

    if (( ${#matches} )); then
      local orig_prefix=$PREFIX
      local k ret=1
      for k in $matches; do
        PREFIX="~${k}/${orig_prefix#\~*/}"
        _orig_path_files "$@" && ret=0
      done
      PREFIX=$orig_prefix
      return $ret
    fi
  fi

  _orig_path_files "$@"
}
