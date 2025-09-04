#!/bin/bash
set -e

echo "Starting dotfiles installation..."

# Backup previous configs
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%F_%T)"
mkdir -p "$BACKUP_DIR"
mkdir -p "$HOME/bin"

# Function to safely backup existing files
backup_if_exists() {
    local file="$1"
    if [ -f "$file" ]; then
        cp "$file" "$BACKUP_DIR/"
        echo "Backed up $(basename "$file")"
    fi
}

# Function to install configs from a directory
install_configs() {
    local src_dir="$1"
    local dest_dir="$2"
    local desc="$3"
    
    echo "Installing $desc..."
    
    if [ -d "$src_dir" ] && [ "$(ls -A "$src_dir" 2>/dev/null)" ]; then
        mkdir -p "$dest_dir"
        cp -r "$src_dir"/. "$dest_dir/"
        echo "$desc installed successfully."
    else
        echo "No $desc found, skipping..."
    fi
}

# -------------------------------
# 1️⃣ Bash configs
# -------------------------------
echo "Installing bash configs..."

# Backup existing bash configs
backup_if_exists "$HOME/.bashrc"
backup_if_exists "$HOME/.bash_aliases"
backup_if_exists "$HOME/.bash_profile"
backup_if_exists "$HOME/.inputrc"

# Install bash configs (including hidden files)
if [ -d "bash" ] && [ "$(ls -A bash/ 2>/dev/null)" ]; then
    cp -r bash/. "$HOME/"
    echo "Bash configs installed successfully."
else
    echo "No bash configs found, skipping..."
fi

# -------------------------------
# 2️⃣ Bin scripts
# -------------------------------
echo "Installing scripts to ~/bin..."
if [ -d "bin" ] && [ "$(ls -A bin/ 2>/dev/null)" ]; then
    cp -r bin/. ~/bin/
    chmod +x ~/bin/*
    echo "Bin scripts installed successfully."
else
    echo "No bin scripts found, skipping..."
fi

# -------------------------------
# 3️⃣ Neovim
# -------------------------------
install_configs "nvim" "$HOME/.config/nvim" "Neovim config"

# -------------------------------
# 4️⃣ Tmux
# -------------------------------
echo "Installing Tmux config..."

# Backup existing tmux config
backup_if_exists "$HOME/.tmux.conf"

# Install tmux configs
if [ -d "tmux" ] && [ "$(ls -A tmux/ 2>/dev/null)" ]; then
    # Handle both .tmux.conf in root and tmux directory structure
    if [ -f "tmux/.tmux.conf" ]; then
        cp tmux/.tmux.conf "$HOME/"
        echo "Tmux config (.tmux.conf) installed."
    fi
    
    # Install other tmux configs to ~/.tmux/ directory
    mkdir -p ~/.tmux
    cp -r tmux/. ~/.tmux/
    echo "Tmux configs installed successfully."
else
    echo "No Tmux config found, skipping..."
fi

# -------------------------------
# 5️⃣ Rofi
# -------------------------------
install_configs "rofi/rofi" "$HOME/.config/rofi" "Rofi config"

# -------------------------------
# 6️⃣ Themes
# -------------------------------
install_configs "themes" "$HOME/.themes" "themes"

#5️⃣ VSCode Extensions
echo "Installing VSCode extensions..."
if [ -f "$HOME/dotfiles/vscode/extensions.txt" ]; then
    cat "$HOME/dotfiles/vscode/extensions.txt" | xargs -L 1 code --install-extension
fi
#my vscode settings and key bindings
mkdir -p "$HOME/.config/Code/User"
cp -f "$HOME/dotfiles/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
cp -f "$HOME/dotfiles/vscode/keybindings.json" "$HOME/.config/Code/User/keybindings.json"
# -------------------------------
# 7️⃣ Icons
# -------------------------------
install_configs "icons" "$HOME/.icons" "icons"

# -------------------------------
# 8️⃣ Make scripts executable
# -------------------------------
echo "Setting executable permissions..."
[ -d "$HOME/bin" ] && chmod +x "$HOME/bin"/* 2>/dev/null || true
#neo fetch config 
cp -rf "$HOME/dotfiles/neofetch/neofetch/" "$HOME/.config/neofetch/"
#assets configurations 
mkdir -p "$HOME/.local/share/backgrounds/"
mkdir -p "$HOME/.face"

cp -f "$HOME/dotfiles/assets/background.jpg" "$HOME/.local/share/backgrounds/background.jpg"
cp -f "$HOME/dotfiles/assets/profile.jpeg" "$HOME/.face"
# -------------------------------
# 9️⃣ Finalize
# -------------------------------
echo "Finalizing installation..."

# Source bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    echo "Note: Run 'source ~/.bashrc' or restart your terminal to apply bash changes."
fi

# Print summary
echo ""
echo "=============================================="
echo "✅ Dotfiles installation complete!"
echo "=============================================="
echo "📁 Backup location: $BACKUP_DIR"
echo "🔧 Installed configurations:"

# Check what was actually installed
[ -f "$HOME/.bashrc" ] && echo "   • Bash configs"
[ -d "$HOME/bin" ] && [ "$(ls -A "$HOME/bin" 2>/dev/null)" ] && echo "   • Bin scripts"
[ -d "$HOME/.config/nvim" ] && echo "   • Neovim config"
[ -f "$HOME/.tmux.conf" ] || [ -d "$HOME/.tmux" ] && echo "   • Tmux config"
[ -d "$HOME/.config/rofi" ] && echo "   • Rofi config"
[ -d "$HOME/.themes" ] && [ "$(ls -A "$HOME/.themes" 2>/dev/null)" ] && echo "   • Themes"
[ -d "$HOME/.icons" ] && [ "$(ls -A "$HOME/.icons" 2>/dev/null)" ] && echo "   • Icons"

echo ""
echo "💡 Tips:"
echo "   • Restart your terminal or run 'source ~/.bashrc'"
echo "   • Your old configs are backed up in $BACKUP_DIR"
echo "   • Run 'ls ~/bin' to see available scripts"
echo "=============================================="
