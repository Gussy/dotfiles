# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Machine Detection

- **Work laptops**: Hostname starts with `WORK` → no dottools PATH, no NVM
- **Personal laptops**: Everything else → includes dottools PATH and NVM

## Setup

```bash
# First time on new machine
git clone <this-repo> ~/Development/dotfiles
source bin/activate-hermit
chezmoi init --source=~/Development/dotfiles
chezmoi apply

# After first setup, source is saved in config
# Just pull and apply:
cd ~/Development/dotfiles
git pull
chezmoi apply
```

## Commands

```bash
# Apply dotfiles to system
chezmoi apply

# Preview changes before applying
chezmoi diff

# Apply with dry-run
chezmoi apply --dry-run --verbose

# Edit a dotfile (opens template in editor)
chezmoi edit ~/.zshrc

# Add new file to chezmoi
chezmoi add ~/.newfile

# List all managed files
chezmoi managed

# Show template variables for this machine
chezmoi data

# Verify template renders correctly
chezmoi execute-template < dot_zshrc.tmpl

# Reset config if needed
chezmoi init --force
```
