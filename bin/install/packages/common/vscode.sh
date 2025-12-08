#!/bin/bash
if omarchy-pkg-missing "visual-studio-code-bin"; then
    echo "Installing Visual Studio Code editor..."
    omarchy-install-vscode
fi