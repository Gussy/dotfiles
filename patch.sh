#!/bin/bash

# if running on darwin, run the patch command
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Patching gitconfig..."
    sed -i '' 's|signingkey =.*|signingkey = '"$HOME"'/.ssh/id_ed25519.pub|' $HOME/.gitconfig || true
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo "Patching gitconfig..."
    sed -i 's|signingkey =.*|signingkey = '"$HOME"'/.ssh/id_ed25519.pub|' $HOME/.gitconfig || true
else
    echo "Patch command not supported on this OS."
fi