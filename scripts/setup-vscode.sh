#!/bin/bash

# VS Code Setup Script
# Installs the VS Code CLI command "code" in PATH

set -e

echo "====================================="
echo "Configuring VS Code"
echo "====================================="
echo ""

# Check if VS Code is installed
if [ ! -d "/Applications/Visual Studio Code.app" ]; then
    echo "❌ Visual Studio Code is not installed"
    echo "   Please install it via: brew install --cask visual-studio-code"
    exit 1
fi

# Check if 'code' command already exists in PATH
if command -v code &> /dev/null; then
    echo "✅ VS Code CLI 'code' command already available"
    code --version
    exit 0
fi

# Install the CLI command by creating a symlink
echo "Installing VS Code CLI command 'code'..."

# Create symlink in /usr/local/bin
sudo ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code

# Verify installation
if command -v code &> /dev/null; then
    echo "✅ VS Code CLI installed successfully"
    echo ""
    code --version
else
    echo "❌ Failed to install VS Code CLI"
    exit 1
fi

echo ""
echo "✅ VS Code setup complete!"
echo "   You can now use 'code' from the command line:"
echo "   - code .              (open current directory)"
echo "   - code file.txt       (open a file)"
echo "   - code -n .           (open in new window)"
