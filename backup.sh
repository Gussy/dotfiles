#!/bin/bash

HOME_DIR="$HOME"
CONFIG_DIR="$HOME/.config"
REPO_DIR="$(pwd)"
IGNORED_FILES=("." ".." ".git" ".gitignore" ".vscode" "bin" ".xargo" ".zsh_sessions" ".ssh")
CONFIG_FOLDERS=("ohmyposh" "iterm2-settings")

# Function to backup dotfiles
backup_dotfiles() {
    echo "Starting backup of dotfiles..."
    # Loop through the files in the repository directory
    for file in $(ls -A $REPO_DIR); do
        # Check if the file starts with a dot, indicating it's a dotfile
        if [[ $file == .* ]]; then
            # Check if the dotfile exists in the home directory
            if [ -e "$HOME_DIR/$file" ]; then
                # Check if the dotfile is in the ignored files list
                if [[ ! " ${IGNORED_FILES[@]} " =~ " $file " ]]; then
                    echo "Backing up $file..."
                    # Copy the file from the home directory to the repository directory
                    cp "$HOME_DIR/$file" "$REPO_DIR/$file"
                fi
            else
                echo "$file does not exist in the home directory."
            fi
        fi
    done
    echo "Backup complete."
}

# Function to backup config folders
backup_config_folders() {
    echo "Starting backup of config folders..."
    # Loop through the config folders
    for folder in "${CONFIG_FOLDERS[@]}"; do
        # Check if the folder exists in the .config directory
        if [ -d "$CONFIG_DIR/$folder" ]; then
            echo "Backing up $folder..."
            # Copy the folder from the .config directory to the repository directory
            mkdir -p "$REPO_DIR/.config/$folder/"
            cp $CONFIG_DIR/$folder/* $REPO_DIR/.config/$folder/
        else
            echo "$folder does not exist in the .config directory."
        fi
    done
    echo "Backup complete."
}

# Execute the backup functions
backup_dotfiles
backup_config_folders
