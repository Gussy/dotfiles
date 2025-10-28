#!/bin/bash

# iTerm2 Setup Script
# Configures iTerm2 to load preferences from custom folder

set -e

echo "====================================="
echo "Configuring iTerm2"
echo "====================================="
echo ""

# Check if iTerm2 is installed
if [ ! -d "/Applications/iTerm.app" ]; then
    echo "❌ iTerm2 is not installed"
    echo "   Please install it via: brew install --cask iterm2"
    exit 1
fi

# Define the custom preferences folder
PREFS_FOLDER="$HOME/.config/iterm2-settings"

# Check if the preferences file exists
if [ ! -f "$PREFS_FOLDER/com.googlecode.iterm2.plist" ]; then
    echo "⚠️  Warning: iTerm2 preferences file not found at $PREFS_FOLDER"
    echo "   Make sure chezmoi has applied the dotfiles: chezmoi apply"
fi

# Configure iTerm2 to use the custom preferences folder
echo "Setting iTerm2 to load preferences from: $PREFS_FOLDER"

defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$PREFS_FOLDER"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

echo ""
echo "✅ iTerm2 configured successfully!"
echo ""
echo "Note: You need to restart iTerm2 for changes to take effect:"
echo "  1. Quit iTerm2 completely (Cmd+Q)"
echo "  2. Reopen iTerm2"
echo ""
echo "After restarting, your settings from $PREFS_FOLDER will be loaded."
