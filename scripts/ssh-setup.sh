#!/bin/bash

set -e

# Configuration file location
CONFIG_DIR="$HOME/.config/dotfiles"
CONFIG_FILE="$CONFIG_DIR/user.conf"

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Function to prompt for user information
prompt_user_info() {
    echo "====================================="
    echo "SSH Key Setup"
    echo "====================================="
    echo ""

    # Check if we already have saved values
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        echo "Found existing configuration:"
        echo "  Name: $GIT_USER_NAME"
        echo "  Email: $GIT_USER_EMAIL"
        echo ""
        read -p "Use these values? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            return
        fi
    fi

    # Prompt for new values
    read -p "Enter your full name (for git): " GIT_USER_NAME
    read -p "Enter your email address (for git and SSH): " GIT_USER_EMAIL

    # Save to config file
    cat > "$CONFIG_FILE" << EOF
# User configuration for dotfiles
GIT_USER_NAME="$GIT_USER_NAME"
GIT_USER_EMAIL="$GIT_USER_EMAIL"
EOF

    echo ""
    echo "Configuration saved to $CONFIG_FILE"
}

# Prompt for user info if needed
if [ ! -f ~/.ssh/id_ed25519 ]; then
    prompt_user_info
else
    # SSH key exists, load config if available
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    else
        echo "SSH key already exists at ~/.ssh/id_ed25519"
        echo "Skipping SSH key generation."
        exit 0
    fi
fi

# Generate SSH key if it doesn't exist
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo ""
    echo "Generating SSH key..."
    ssh-keygen -t ed25519 -C "$GIT_USER_EMAIL" -f ~/.ssh/id_ed25519 -N ""
    echo ""
    echo "✅ SSH key generated successfully"
    echo ""
    echo "📋 Copy this public key to GitHub/GitLab:"
    echo "======================================"
    cat ~/.ssh/id_ed25519.pub
    echo "======================================"
    echo ""
fi

# Start ssh-agent and add key
echo "Starting ssh-agent and adding key..."
eval "$(ssh-agent -s)" > /dev/null
ssh-add ~/.ssh/id_ed25519 2>/dev/null || true

# Configure git if name and email are set
if [ -n "$GIT_USER_NAME" ] && [ -n "$GIT_USER_EMAIL" ]; then
    echo "Configuring git..."
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
    echo "✅ Git configured with name: $GIT_USER_NAME, email: $GIT_USER_EMAIL"
fi

echo ""
echo "✅ SSH setup complete!"
