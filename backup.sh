#!/bin/bash

HOME_DIR="$HOME"
REPO_DIR="$(pwd)"

# Function to backup dotfiles
backup_dotfiles() {
    echo "Starting backup of dotfiles..."
    # Loop through the files in the repository directory
    for file in $(ls -A $REPO_DIR); do
        # Check if the file starts with a dot, indicating it's a dotfile
        if [[ $file == .* ]]; then
            # Check if the dotfile exists in the home directory
            if [ -e "$HOME_DIR/$file" ]; then
                echo "Backing up $file..."
                # Copy the file from the home directory to the repository directory
                cp "$HOME_DIR/$file" "$REPO_DIR/$file"
            else
                echo "$file does not exist in the home directory."
            fi
        fi
    done
    echo "Backup complete."
}

# Execute the backup function
backup_dotfiles
