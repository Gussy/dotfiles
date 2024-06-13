#!/bin/bash

HOME_DIR="$HOME"
CONFIG_DIR="$HOME/.config"
REPO_DIR="$(pwd)"
IGNORED_FILES=("." ".." ".git" ".gitignore" ".vscode" "bin")
CONFIG_FOLDERS=("ohmyposh" "iterm2-settings")

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
            if [[ ! " ${IGNORED_FILES[@]} " =~ " $file " ]]; then
                # Check if the dotfile already exists in the home directory
                if [ -e "$HOME_DIR/$file" ]; then
                    # Ask the user if they want to overwrite the existing dotfile
                    read -p "$file already exists. Do you want to overwrite it? (y/n): " answer
                    if [[ $answer = [Yy]* ]]; then
                        echo "Overwriting $file..."
                        cp "$REPO_DIR/$file" "$HOME_DIR/$file"
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

# Function to restore or install config folders to the .config directory
install_config_folders() {
    echo "Starting restoration/installation of config folders to the .config directory..."
    # Loop through the config folders
    for folder in "${CONFIG_FOLDERS[@]}"; do
        # Check if the folder already exists in the .config directory
        if [ -d "$CONFIG_DIR/$folder" ]; then
            # Ask the user if they want to overwrite the existing folder
            read -p "$folder already exists in .config. Do you want to overwrite it? (y/n): " answer
            if [[ $answer = [Yy]* ]]; then
                echo "Overwriting $folder..."
                cp -r "$REPO_DIR/.config/$folder" "$CONFIG_DIR/$folder"
            fi
        else
            echo "Installing $folder..."
            # Copy the folder from the repository directory to the .config directory
            cp -r "$REPO_DIR/.config/$folder" "$CONFIG_DIR/$folder"
        fi
    done
    echo "Installation complete."
}

# Execute the install functions
install_dotfiles
install_config_folders
