#!/usr/bin/env bash
# Install the shell and terminal subset without applying the full machine setup.
set -euo pipefail
cd "$(dirname "$0")"
repo="$PWD"
if ! command -v brew >/dev/null; then
  echo 'Install Homebrew first: https://brew.sh/' >&2
  exit 1
fi
brew bundle install --file="$repo/Brewfile.light"
# Use a temporary config so the full profile and its Bitwarden settings are untouched.
temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-light.XXXXXX")
config="$temp_dir/chezmoi.toml"
trap 'rm -rf "$temp_dir"' EXIT
cat > "$config" <<CONFIG
[data]
    isWork = false
CONFIG
args=(--config "$config" --source "$repo")
targets=("$HOME/.zprofile" "$HOME/.zshrc" "$HOME/.config/zsh/env.zsh" "$HOME/.config/ohmyposh/zen.toml" "$HOME/.config/ghostty/config")
mkdir -p "$HOME/.config/zsh" "$HOME/.config/ohmyposh" "$HOME/.config/ghostty"
echo 'Previewing the light profile:'
chezmoi "${args[@]}" diff -- "${targets[@]}"
chezmoi "${args[@]}" apply --verbose -- "${targets[@]}"
echo 'Light profile applied. Start a new shell to load it.'
