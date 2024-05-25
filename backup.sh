#!/bin/bash

HOME_DIR="$HOME"
REPO_DIR="$(pwd)"
IGNORED_FILES=("." ".." ".git" ".gitignore" ".vscode")

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
                if [[ " ${IGNORED_FILES[@]} " =~ " $file " ]]; then
                    echo "Ignoring $file..."
                else
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

# Execute the backup function
backup_dotfiles
