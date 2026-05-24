vscode_bin="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
if [ -x "${vscode_bin}" ]; then
    alias code="'${vscode_bin}'"
fi
unset vscode_bin
