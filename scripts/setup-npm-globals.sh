#!/usr/bin/env bash

# Install global npm packages

echo "Installing global npm packages..."

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "Error: npm not found. Install Node.js first."
    exit 1
fi

# List of global packages to install
packages=(
    "@anthropic-ai/claude-code"
    "aicommit2"
)

for package in "${packages[@]}"; do
    echo "Installing $package..."
    npm install -g "$package"
done

echo "✅ Global npm packages installed"
