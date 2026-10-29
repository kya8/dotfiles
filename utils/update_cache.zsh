update_cache() {
  emulate -L zsh
  setopt extendedglob

  local -a _update_cache_all _update_cache_update_only _update_cache_names _update_cache_lines
  local -A _update_cache_values _update_cache_seen
  local _update_cache_file _update_cache_name _update_cache_line _update_cache_value
  local -i _update_cache_changed=0

  zmodload zsh/zutil || return 1
  zparseopts -D -F -- a=_update_cache_all u=_update_cache_update_only || return 2

  if (( $# == 0 || (${#_update_cache_all} && $# != 1) || (!${#_update_cache_all} && $# < 2) )); then
    print -u2 -r -- 'Usage: update_cache [-u] cache_file var ... | update_cache -a [-u] cache_file'
    return 2
  fi

  _update_cache_file=$1
  shift
  _update_cache_names=( "$@" )

  for _update_cache_name in "${_update_cache_names[@]}"; do
    if [[ $_update_cache_name != [a-zA-Z_][a-zA-Z0-9_]# ]]; then
      print -u2 -r -- "update_cache: invalid variable name: $_update_cache_name"
      return 2
    fi
    if [[ ! -v $_update_cache_name ]]; then
      print -u2 -r -- "update_cache: variable is not set: $_update_cache_name"
      return 1
    fi
    _update_cache_values[$_update_cache_name]=${(P)_update_cache_name}
  done

  if [[ -e $_update_cache_file ]]; then
    if [[ ! -f $_update_cache_file || ! -r $_update_cache_file ]]; then
      print -u2 -r -- "update_cache: not a readable regular file: $_update_cache_file"
      return 1
    fi

    while IFS= read -r _update_cache_line || [[ -n $_update_cache_line ]]; do
      _update_cache_name=${_update_cache_line%%=*}
      if [[ $_update_cache_line == *=* && $_update_cache_name == [a-zA-Z_][a-zA-Z0-9_]# ]]; then
        _update_cache_seen[$_update_cache_name]=1
        if (( ${#_update_cache_all} )) && [[ -v $_update_cache_name ]]; then
          _update_cache_values[$_update_cache_name]=${(P)_update_cache_name}
        fi
        if (( ${+_update_cache_values[$_update_cache_name]} )); then
          _update_cache_value=${_update_cache_line#*=}
          if [[ ${(Q)_update_cache_value} != "$_update_cache_values[$_update_cache_name]" ]]; then
            _update_cache_line="$_update_cache_name=${(qqqq)_update_cache_values[$_update_cache_name]}"
            _update_cache_changed=1
          fi
        fi
      fi
      _update_cache_lines+=( "$_update_cache_line" )
    done < "$_update_cache_file" || return 1
  fi

  if (( !${#_update_cache_all} && !${#_update_cache_update_only} )); then
    for _update_cache_name in "${_update_cache_names[@]}"; do
      if (( !${+_update_cache_seen[$_update_cache_name]} )); then
        _update_cache_lines+=( "$_update_cache_name=${(qqqq)_update_cache_values[$_update_cache_name]}" )
        _update_cache_seen[$_update_cache_name]=1
        _update_cache_changed=1
      fi
    done
  fi

  if (( !_update_cache_changed )) && [[ -e $_update_cache_file ]]; then
    return 0
  fi

  {
    if (( ${#_update_cache_lines} )); then
      print -rl -- "${_update_cache_lines[@]}"
    fi
  } >| "$_update_cache_file"
}
