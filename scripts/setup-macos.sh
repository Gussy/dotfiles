#!/bin/bash

# macOS System Preferences Configuration
# This script applies sensible defaults for a better macOS experience

set -e

echo "====================================="
echo "Configuring macOS System Preferences"
echo "====================================="
echo ""
echo "Note: Some changes may require logout/restart to take effect"
echo ""

# Close System Preferences to prevent conflicts
osascript -e 'tell application "System Preferences" to quit'

###############################################################################
# Trackpad & Mouse
###############################################################################

echo "⚙️  Configuring trackpad and mouse..."

# Disable natural scroll direction
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

###############################################################################
# Keyboard
###############################################################################

echo "⚙️  Configuring keyboard..."

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Set faster key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# Set shorter delay until key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15

###############################################################################
# Finder
###############################################################################

echo "⚙️  Configuring Finder..."

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Disable warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show the ~/Library folder
chflags nohidden ~/Library

###############################################################################
# Screenshots
###############################################################################

echo "⚙️  Configuring screenshots..."

# Save screenshots to ~/Desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Dialogs & Warnings
###############################################################################

echo "⚙️  Configuring dialogs and warnings..."

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

###############################################################################
# Done
###############################################################################

echo ""
echo "✅ macOS configuration complete!"
echo ""
echo "Note: You should restart your computer for all changes to take effect."
echo "      Some changes (like Finder settings) may require restarting Finder:"
echo "      killall Finder"
