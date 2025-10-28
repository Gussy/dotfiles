# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/) and [Bitwarden](https://bitwarden.com/).

## Quick Start

**One-liner for fresh macOS setup:**

```bash
git clone https://github.com/Gussy/dotfiles.git ~/Development/dotfiles && cd ~/Development/dotfiles && ./bootstrap.sh
```

This will:
- Install Homebrew and all packages
- Set up Bitwarden CLI for secrets management
- Initialize chezmoi and apply dotfiles
- Configure SSH, npm, macOS settings, and more

**Prerequisites**: You'll need a Bitwarden account with a "Dotfiles Configuration" item. See [BITWARDEN_SETUP.md](BITWARDEN_SETUP.md) for details.

---

## How It Works

### Machine Detection

Dotfiles automatically detect work vs personal machines using hostname prefixes stored securely in Bitwarden:
- **Work laptops**: Hostname matches configured prefix → excludes personal dev tools
- **Personal laptops**: Everything else → includes full development environment

### Secrets Management

Sensitive values (git name, email, work hostname prefix) are stored in Bitwarden, not in the repository. Templates fetch these values at apply-time using `bitwardenFields`.

## Manual Setup

If you prefer not to use the bootstrap script:

```bash
# Clone the repo
git clone https://github.com/Gussy/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles

# Set up Bitwarden (follow BITWARDEN_SETUP.md)
bw login
export BW_SESSION="$(bw unlock --raw)"

# Initialize and apply with chezmoi
chezmoi init --source=~/dotfiles
chezmoi apply
```

## Updating Dotfiles

After initial setup:

```bash
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
