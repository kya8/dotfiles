edit_local_cache() {
  local -r f=$_local_cache_file
  if [[ -z $f ]]; then
    echo >&2 "Local cache file path is not defined."
    return 1
  fi

  if ! [[ -e $f ]] ; then
    > "$f" <<EOF
# vim: ft=zsh
# Local cache variables that are ignored by version control.
# e.g., os_id=fedora

EOF
  fi

  local -r mtime_before=$(zstat -F '%s.%N' +mtime -- "$f")
  "${_my_vi:?}" + -- "$f"
  local -r mtime_after=$(zstat -F '%s.%N' +mtime -- "$f")

  if [ "$mtime_before" != "$mtime_after" ] ; then
    source -- "$f"
    echo "Changes were saved. ${f} has been re-sourced."
  else
    echo "No changes were made."
  fi
}
