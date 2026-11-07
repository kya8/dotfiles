update_cache() (
  emulate -L zsh
  setopt extendedglob

  local -a _update_cache_all _update_cache_update_only _update_cache_names _update_cache_tokens
  local -A _update_cache_values _update_cache_seen _update_cache_stat
  local _update_cache_file _update_cache_name _update_cache_token _update_cache_value
  local _update_cache_content _update_cache_output _update_cache_prefix _update_cache_temp
  local _update_cache_mode
  local -i _update_cache_changed=0 _update_cache_lock_fd _update_cache_links=0

  zmodload zsh/zutil zsh/system zsh/stat || return 1
  zparseopts -D -F -- a=_update_cache_all u=_update_cache_update_only || return 2

  if (( $# == 0 || (${#_update_cache_all} && $# != 1) || (!${#_update_cache_all} && $# < 2) )); then
    print -u2 -r -- 'Usage: update_cache [-u] cache_file var ... | update_cache -a [-u] cache_file'
    return 2
  fi

  _update_cache_file=${1:A}
  while [[ -L $_update_cache_file ]]; do
    if (( ++_update_cache_links > 40 )); then
      print -u2 -r -- "update_cache: too many symbolic links: $1"
      return 1
    fi
    zstat -L -H _update_cache_stat -- "$_update_cache_file" || return 1
    _update_cache_value=$_update_cache_stat[link]
    if [[ $_update_cache_value != /* ]]; then
      _update_cache_value="${_update_cache_file:h}/$_update_cache_value"
    fi
    _update_cache_file=${_update_cache_value:A}
  done
  shift
  _update_cache_names=( "$@" )

  : >> "$_update_cache_file.lock" || return 1
  zsystem flock -i 0.05 -f _update_cache_lock_fd "$_update_cache_file.lock" || return 1

  if [[ -e $_update_cache_file ]]; then
    if [[ ! -f $_update_cache_file || ! -r $_update_cache_file ]]; then
      print -u2 -r -- "update_cache: not a readable regular file: $_update_cache_file"
      return 1
    fi

    _update_cache_content=$(command cat -- "$_update_cache_file" && print -rn -- .) || return 1
    _update_cache_content=${_update_cache_content%.}
    command zsh -f -n <<< "$_update_cache_content" || return 1
  fi

  _update_cache_tokens=( ${(Z:cn:)_update_cache_content} )
  for _update_cache_token in "${_update_cache_tokens[@]}"; do
    [[ $_update_cache_token == \#* ]] && continue
    _update_cache_name=${_update_cache_token%%=*}
    if [[ $_update_cache_token != *=* || $_update_cache_name != [a-zA-Z_][a-zA-Z0-9_]# ]]; then
      print -u2 -r -- "update_cache: expected an assignment or comment: $_update_cache_token"
      return 1
    fi
    if (( ${#_update_cache_all} )) && [[ -v $_update_cache_name || ${(tP)_update_cache_name} == (array|association)* ]]; then
      _update_cache_names+=( "$_update_cache_name" )
    fi
  done

  for _update_cache_name in "${_update_cache_names[@]}"; do
    if [[ $_update_cache_name != [a-zA-Z_][a-zA-Z0-9_]# ]]; then
      print -u2 -r -- "update_cache: invalid variable name: $_update_cache_name"
      return 2
    fi
    if [[ $_update_cache_name == _update_cache_* ]]; then
      print -u2 -r -- "update_cache: reserved variable name: $_update_cache_name"
      return 2
    fi
    if [[ ${(tP)_update_cache_name} == (array|association)* ]]; then
      print -u2 -r -- "update_cache: arrays are not supported: $_update_cache_name"
      return 2
    fi
    if [[ ! -v $_update_cache_name ]]; then
      print -u2 -r -- "update_cache: variable is not set: $_update_cache_name"
      return 1
    fi
    _update_cache_values[$_update_cache_name]=${(P)_update_cache_name}
  done

  for _update_cache_token in "${_update_cache_tokens[@]}"; do
    _update_cache_prefix=${_update_cache_content%%"$_update_cache_token"*}
    if [[ $_update_cache_prefix != [[:space:]]# ||
          $_update_cache_content != "$_update_cache_prefix$_update_cache_token"* ]]; then
      print -u2 -r -- 'update_cache: unsupported line continuation in cache'
      return 1
    fi
    _update_cache_content=${_update_cache_content#"$_update_cache_prefix$_update_cache_token"}
    _update_cache_output+=$_update_cache_prefix

    if [[ $_update_cache_token != \#* ]]; then
      _update_cache_name=${_update_cache_token%%=*}
      _update_cache_seen[$_update_cache_name]=1
      if (( ${+_update_cache_values[$_update_cache_name]} )); then
        _update_cache_value="$_update_cache_name=${(q+)_update_cache_values[$_update_cache_name]}"
        if [[ $_update_cache_token != "$_update_cache_value" ]]; then
          _update_cache_token=$_update_cache_value
          _update_cache_changed=1
        fi
      fi
    fi
    _update_cache_output+=$_update_cache_token
  done
  _update_cache_output+=$_update_cache_content

  if (( !${#_update_cache_all} && !${#_update_cache_update_only} )); then
    for _update_cache_name in "${_update_cache_names[@]}"; do
      if (( !${+_update_cache_seen[$_update_cache_name]} )); then
        if [[ -n $_update_cache_output && $_update_cache_output != *$'\n' ]]; then
          _update_cache_output+=$'\n'
        fi
        _update_cache_output+="$_update_cache_name=${(q+)_update_cache_values[$_update_cache_name]}"$'\n'
        _update_cache_seen[$_update_cache_name]=1
        _update_cache_changed=1
      fi
    done
  fi

  if (( !_update_cache_changed )) && [[ -e $_update_cache_file ]]; then
    return 0
  fi

  _update_cache_temp=$(command mktemp "$_update_cache_file.tmp.XXXXXXXXXX") || return 1
  trap '[[ -z $_update_cache_temp ]] || command rm -f -- "$_update_cache_temp"' EXIT
  trap 'exit 1' HUP INT TERM

  if [[ -e $_update_cache_file ]]; then
    zstat -H _update_cache_stat -- "$_update_cache_file" || return 1
    printf -v _update_cache_mode '%o' $(( _update_cache_stat[mode] & 8#7777 ))
    command chmod "$_update_cache_mode" "$_update_cache_temp" || return 1
  fi

  print -rn -- "$_update_cache_output" >| "$_update_cache_temp" || return 1
  command mv -f -- "$_update_cache_temp" "$_update_cache_file" || return 1
  _update_cache_temp=''
)
