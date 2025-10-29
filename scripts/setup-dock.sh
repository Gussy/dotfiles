#!/usr/bin/env bash

# Dock Configuration Script
# Configures the macOS Dock with specified apps and settings

set -e

echo "====================================="
echo "Configuring macOS Dock"
echo "====================================="
echo ""

# Check if dockutil is installed
if ! command -v dockutil &> /dev/null; then
    echo "❌ Error: dockutil is not installed"
    echo "   Please run: brew install dockutil"
    exit 1
fi

# Remove all existing Dock items (except Finder, which can't be removed)
echo "🗑️  Removing all existing Dock items..."
dockutil --remove all --no-restart

# Determine the config file location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../dock-apps.txt"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: dock-apps.txt not found at $CONFIG_FILE"
    exit 1
fi

# Add specified applications from config file
echo "➕ Adding applications to Dock from config file..."
echo ""

# Track apps that were added to avoid duplicates (bash 3.2 compatible)
ADDED_APPS=()

# Read the config file line by line
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

    # Trim whitespace
    app_path=$(echo "$line" | xargs)

    # Skip if empty after trimming
    [ -z "$app_path" ] && continue

    # Skip if we've already added this app
    if printf '%s\n' "${ADDED_APPS[@]}" | grep -q -F -x "$app_path"; then
        continue
    fi

    # Check if the app exists
    if [ -d "$app_path" ]; then
        app_name=$(basename "$app_path" .app)
        echo "  ✓ Adding: $app_name"
        dockutil --add "$app_path" --no-restart
        ADDED_APPS+=("$app_path")
    else
        app_name=$(basename "$app_path" .app)
        echo "  ⚠️  Skipping: $app_name (not found)"
    fi
done < "$CONFIG_FILE"

echo ""

# Configure Dock settings
echo "⚙️  Configuring Dock preferences..."

# Set Dock icon size
defaults write com.apple.dock tilesize -int 48

# Set Dock magnification
defaults write com.apple.dock magnification -bool false

# Position Dock on the bottom
defaults write com.apple.dock orientation -string "bottom"

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Set auto-hide delay
defaults write com.apple.dock autohide-delay -float 0

# Set auto-hide animation time
defaults write com.apple.dock autohide-time-modifier -float 0.5

# Show recent applications in Dock (on right side with separator)
defaults write com.apple.dock show-recents -bool true

# Minimize windows into their application icon
defaults write com.apple.dock minimize-to-application -bool true

# Restart Dock to apply changes
echo "🔄 Restarting Dock..."
killall Dock

echo ""
echo "✅ Dock configuration complete!"
