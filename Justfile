backup:
    @bash backup.sh

patch:
    @echo "Patching gitconfig"
    @sed -i '' 's|signingkey =.*|signingkey = '"$HOME"'/.ssh/id_ed25519.pub|' $HOME/.gitconfig || true

install: && patch
    @bash install.sh
