#!/bin/bash

# Bootstrap script for setting up a new macOS machine
# This script automates the installation and configuration of dotfiles and development tools

set -e

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         macOS Development Environment Bootstrap            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

###############################################################################
# Xcode Command Line Tools                                                   #
###############################################################################

echo "🔧 Checking for Xcode Command Line Tools..."
if ! xcode-select -p &> /dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "⚠️  Please complete the Xcode Command Line Tools installation"
    echo "   and then re-run this script."
    exit 1
else
    echo "✅ Xcode Command Line Tools already installed"
fi

###############################################################################
# Homebrew                                                                    #
###############################################################################

echo ""
echo "🍺 Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "✅ Homebrew installed"
else
    echo "✅ Homebrew already installed"
fi

###############################################################################
# Brewfile Installation                                                      #
###############################################################################

echo ""
echo "📦 Installing packages from Brewfile..."
if [ -f "Brewfile" ]; then
    brew bundle install --file=Brewfile
    echo "✅ Brewfile packages installed"
else
    echo "⚠️  Brewfile not found, skipping..."
fi

###############################################################################
# SSH Key Setup                                                              #
###############################################################################

echo ""
if [ -f "scripts/ssh-setup.sh" ]; then
    bash scripts/ssh-setup.sh
else
    echo "⚠️  scripts/ssh-setup.sh not found, skipping SSH setup..."
fi

###############################################################################
# Install nvm (Node Version Manager)                                         #
###############################################################################

echo ""
echo "📦 Installing nvm..."

if [ ! -d "$HOME/.nvm" ]; then
    # Install nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

    # Load nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Install latest LTS version of Node
    nvm install --lts
    nvm use --lts

    echo "✅ nvm installed with Node $(node --version)"
else
    echo "✅ nvm already installed"
fi

###############################################################################
# Install global npm packages                                                #
###############################################################################

echo ""
if [ -f "scripts/setup-npm-globals.sh" ]; then
    source scripts/setup-npm-globals.sh
else
    echo "⚠️  scripts/setup-npm-globals.sh not found, skipping npm globals..."
fi

###############################################################################
# macOS System Preferences                                                   #
###############################################################################

echo ""
if [ -f "scripts/setup-macos.sh" ]; then
    bash scripts/setup-macos.sh
else
    echo "⚠️  scripts/setup-macos.sh not found, skipping..."
fi

###############################################################################
# VS Code Setup                                                              #
###############################################################################

echo ""
if [ -f "scripts/setup-vscode.sh" ]; then
    bash scripts/setup-vscode.sh
else
    echo "⚠️  scripts/setup-vscode.sh not found, skipping..."
fi

###############################################################################
# iTerm2 Setup                                                               #
###############################################################################

echo ""
if [ -f "scripts/setup-iterm2.sh" ]; then
    bash scripts/setup-iterm2.sh
else
    echo "⚠️  scripts/setup-iterm2.sh not found, skipping..."
fi

###############################################################################
# Dock Configuration                                                         #
###############################################################################

echo ""
if [ -f "scripts/setup-dock.sh" ]; then
    bash scripts/setup-dock.sh
else
    echo "⚠️  scripts/setup-dock.sh not found, skipping..."
fi

###############################################################################
# Done!                                                                       #
###############################################################################

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    Setup Complete!                         ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  1. Restart your computer for all macOS changes to take effect"
echo "  2. Add your SSH public key to GitHub/GitLab if you haven't already"
echo "  3. Run 'chezmoi init' if you haven't already initialized chezmoi"
echo "  4. Run 'chezmoi apply' to apply your dotfiles"
echo ""
