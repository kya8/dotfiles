# Rustup. Activate only if there isn't another active rust installation.
if ! cmd_exists cargo && [ -r "${HOME}/.cargo/env" ]; then
  source "${HOME}/.cargo/env"
fi

if cmd_exists rustup && [ -n "${my_fpath}" ]; then
    # Completions
    if ! (( ${+_comps[rustup]} )); then
        echo "Generating completions for rustup..."
        rustup completions zsh rustup > "${my_fpath}/_rustup"
    fi
    if ! (( ${+_comps[cargo]} )); then
        echo "Generating completions for cargo..."
        rustup completions zsh cargo > "${my_fpath}/_cargo"
    fi

    regenerate_rust_completions() {
        echo "Generating completions for rustup..."
        rustup completions zsh rustup > "${my_fpath}/_rustup"
        echo "Generating completions for cargo..."
        rustup completions zsh cargo > "${my_fpath}/_cargo"
    }

fi
