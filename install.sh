#!/bin/bash

HOME_DIR="$HOME"
REPO_DIR="$(pwd)"
IGNORED_FILES=("." ".." ".git" ".gitignore" ".vscode")

echo "Home directory: $HOME_DIR"
echo "Repository directory: $REPO_DIR"

# Function to restore or install dotfiles to the home directory
install_dotfiles() {
    echo "Starting restoration/installation of dotfiles to the home directory..."
    # Loop through the files in the repository directory
    for file in $(ls -A $REPO_DIR); do
        # Check if the file starts with a dot, indicating it's a dotfile
        if [[ $file == .* ]]; then
            # Check if the file is in the ignored files list
            if [[ " ${IGNORED_FILES[@]} " =~ " $file " ]]; then
                echo "Skipping $file..."
            else
                # Check if the dotfile already exists in the home directory
                if [ -e "$HOME_DIR/$file" ]; then
                    # Ask the user if they want to overwrite the existing dotfile
                    read -p "$file already exists. Do you want to overwrite it? (y/n): " answer
                    if [[ $answer = [Yy]* ]]; then
                        echo "Overwriting $file..."
                        cp "$REPO_DIR/$file" "$HOME_DIR/$file"
                    else
                        echo "Skipping $file..."
                    fi
                else
                    echo "Installing $file..."
                    # Copy the file from the repository directory to the home directory
                    cp "$REPO_DIR/$file" "$HOME_DIR/$file"
                fi
            fi
        fi
    done
    echo "Installation complete."
}

# Execute the install function
install_dotfiles
