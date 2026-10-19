# Per-user PATH

if ! [[ "$PATH" =~ "$HOME/bin:$HOME/.local/bin:" ]]; then
    PATH="$HOME/bin:$HOME/.local/bin:$PATH"
fi
