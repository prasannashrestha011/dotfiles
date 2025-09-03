#!/bin/bash
set -e

echo "Starting dotfiles installation..."

BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%F_%T)"
mkdir -p "$BACKUP_DIR"
mkdir -p "$HOME/bin"

# -------------------------------
# 1️⃣ Bash configs
# -------------------------------
echo "Installing bash configs..."
if [ -f "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" "$BACKUP_DIR/"
fi
if [ -f "$HOME/.bash_aliases" ]; then
    cp "$HOME/.bash_aliases" "$BACKUP_DIR/"
fi
cp -r bash/* "$HOME/"

# -------------------------------
# 2️⃣ Bin scripts
# -------------------------------
echo "Installing scripts to ~/bin..."
cp -r bin/* ~/bin/
chmod +x ~/bin/*

# -------------------------------
# 3️⃣ Neovim
# -------------------------------
echo "Installing Neovim config..."
mkdir -p ~/.config/nvim
cp -r nvim/* ~/.config/nvim/

# -------------------------------
# 4️⃣ Tmux
# -------------------------------
echo "Installing Tmux config..."
cp -r tmux/* ~/.tmux/

# -------------------------------
# 5️⃣ Rofi
# -------------------------------
echo "Installing Rofi config..."
mkdir -p ~/.config/rofi
cp -r rofi/rofi/* ~/.config/rofi/

# -------------------------------
# 6️⃣ Optional: themes & icons
# -------------------------------
echo "Installing themes and icons..."
mkdir -p ~/.themes ~/.icons
cp -r themes/* ~/.themes/
cp -r icons/* ~/.icons/

# -------------------------------
# 7️⃣ Finalize
# -------------------------------
echo "Sourcing bashrc..."
source ~/.bashrc

echo "Dotfiles installation complete!"
echo "Backup of previous configs stored at $BACKUP_DIR"
