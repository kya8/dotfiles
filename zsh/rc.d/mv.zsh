# Wrapper for mv to make it ask before overwriting.
mv() {
    =mv -i "$@"
}
