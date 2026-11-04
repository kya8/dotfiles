if [ -r "${HOME}/.cargo/env" ] && [[ ! "${PATH}" =~ "$HOME/.cargo/bin" ]] ; then
  source "${HOME}/.cargo/env"
fi

if has_cmd rustup && [ -n "${my_fpath_local}" ]; then
  # Completions
  if ! (( ${+_comps[rustup]} )); then
    echo "Generating completions for rustup..."
    rustup completions zsh rustup > "${my_fpath_local}/_rustup"
  fi
  if ! (( ${+_comps[cargo]} )); then
    echo "Generating completions for cargo..."
    rustup completions zsh cargo > "${my_fpath_local}/_cargo"
  fi

  regenerate_rust_completions() {
    echo "Generating completions for rustup..."
    rustup completions zsh rustup > "${my_fpath_local}/_rustup"
    echo "Generating completions for cargo..."
    rustup completions zsh cargo > "${my_fpath_local}/_cargo"
  }

fi
