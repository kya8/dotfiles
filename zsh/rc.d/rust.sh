# Rustup. Activate only if there isn't another active rust installation.
if ! cmd_exists cargo && [ -r "${HOME}/.cargo/env" ]; then
  source "${HOME}/.cargo/env"
fi

if cmd_exists rustup; then
    # Completions
    if ! [ -e "${my_fpath}/_rustup" ]; then
        echo "Generating completions for rustup..."
        rustup completions zsh > "${my_fpath}/_rustup"
    fi
    if ! [ -e "${my_fpath}/_cargo" ]; then
        echo "Generating completions for cargo..."
        rustup completions zsh cargo > "${my_fpath}/_cargo"
    fi
fi
