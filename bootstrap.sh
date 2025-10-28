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
# Bitwarden Setup                                                            #
###############################################################################

echo ""
echo "🔐 Setting up Bitwarden for dotfiles secrets..."

# Check if bw is installed
if ! command -v bw &> /dev/null; then
    echo "❌ Bitwarden CLI not found. Installing via Homebrew..."
    brew install bitwarden-cli
fi

# Check Bitwarden login status
BW_STATUS=$(bw status | jq -r .status)

if [ "$BW_STATUS" = "unauthenticated" ]; then
    echo "Please login to Bitwarden:"
    bw login
    BW_STATUS=$(bw status | jq -r .status)
fi

# Unlock vault if locked
if [ "$BW_STATUS" = "locked" ]; then
    echo "Unlocking Bitwarden vault..."
    echo "Please enter your Bitwarden master password:"
    export BW_SESSION=$(bw unlock --raw)
else
    # Already unlocked, get session
    export BW_SESSION=$(bw unlock --raw 2>/dev/null || echo "")
fi

# Verify we can access Bitwarden
if bw list items --session "$BW_SESSION" &> /dev/null; then
    echo "✅ Bitwarden connected successfully"

    # Check for Dotfiles Configuration item
    if bw list items --session "$BW_SESSION" | jq -e '.[] | select(.name=="Dotfiles Configuration")' > /dev/null; then
        echo "✅ Found 'Dotfiles Configuration' item in Bitwarden"
    else
        echo "⚠️  WARNING: 'Dotfiles Configuration' item not found in Bitwarden!"
        echo "   Please create this item with the following custom fields:"
        echo "   - git_name: Your full name"
        echo "   - git_email: Your email address"
        echo "   - work_hostname_prefix: Work machine hostname prefix"
        echo ""
        echo "   See BITWARDEN_SETUP.md for detailed instructions."
        echo ""
        read -p "Press Enter to continue anyway, or Ctrl+C to abort..."
    fi
else
    echo "❌ Failed to connect to Bitwarden. Please check your credentials."
    exit 1
fi

# Export session for chezmoi to use
export BW_SESSION

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
# Dock Configuration                                                         #
###############################################################################

echo ""
if [ -f "scripts/setup-dock.sh" ]; then
    bash scripts/setup-dock.sh
else
    echo "⚠️  scripts/setup-dock.sh not found, skipping..."
fi

###############################################################################
# Chezmoi Initialization                                                     #
###############################################################################

echo ""
echo "🏠 Initializing chezmoi with dotfiles..."

# Get the absolute path to this repository
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Initialize chezmoi with this repo as the source
if command -v chezmoi &> /dev/null; then
    echo "Running chezmoi init..."
    chezmoi init --source="$DOTFILES_DIR"

    echo ""
    echo "Applying dotfiles configuration..."
    echo "Note: This will use Bitwarden for sensitive values (name, email, etc.)"

    # Apply the dotfiles with BW_SESSION available
    if chezmoi apply --verbose; then
        echo "✅ Dotfiles applied successfully"
    else
        echo "⚠️  Some dotfiles may not have been applied. Check errors above."
        echo "   You can re-run 'chezmoi apply' after fixing any issues."
    fi
else
    echo "⚠️  chezmoi not found. Install it with: brew install chezmoi"
    echo "   Then run: chezmoi init --source=$DOTFILES_DIR && chezmoi apply"
fi

###############################################################################
# Done!                                                                       #
###############################################################################

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    Setup Complete!                         ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "✅ Your development environment is ready!"
echo ""
echo "Next steps:"
echo "  1. Add your SSH public key to GitHub if you haven't already"
echo "     cat ~/.ssh/id_ed25519.pub | pbcopy"
echo ""
echo "  2. Restart your terminal or run: source ~/.zshrc"
echo ""
echo "  3. (Optional) Restart your computer for all macOS changes to take effect"
echo ""
echo "📚 Useful commands:"
echo "  • chezmoi diff    - Preview changes before applying"
echo "  • chezmoi apply   - Apply dotfile changes"
echo "  • chezmoi edit    - Edit a dotfile"
echo "  • bw unlock       - Unlock Bitwarden vault (sets BW_SESSION)"
echo ""
