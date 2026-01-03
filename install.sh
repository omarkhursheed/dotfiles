#!/bin/bash
# Dotfiles bootstrap script
# Usage: curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/install.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[x]${NC} $1"; exit 1; }

# Configuration
DOTFILES="$HOME/dotfiles"
REPO="https://github.com/omarkhursheed/dotfiles.git"

# ============================================
# Parse arguments
# ============================================
INSTALL_NEOVIM=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --full)
            INSTALL_NEOVIM=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

# ============================================
# Get or update dotfiles
# ============================================
if [ -d "$DOTFILES" ]; then
    log "Updating existing dotfiles..."
    cd "$DOTFILES"
    git pull --ff-only 2>/dev/null || warn "Could not pull updates"
else
    if command -v git &>/dev/null; then
        log "Cloning dotfiles..."
        git clone "$REPO" "$DOTFILES"
    else
        error "git is not installed. Please install git first."
    fi
fi

cd "$DOTFILES"

# ============================================
# Backup and symlink helper
# ============================================
backup_and_link() {
    local src="$1"
    local dest="$2"

    if [ ! -f "$src" ]; then
        warn "Source file does not exist: $src"
        return
    fi

    # Backup existing file if it exists and is not a symlink
    if [ -f "$dest" ] && [ ! -L "$dest" ]; then
        local backup="$dest.backup.$(date +%Y%m%d_%H%M%S)"
        warn "Backing up $dest to $backup"
        mv "$dest" "$backup"
    fi

    # Remove existing symlink
    [ -L "$dest" ] && rm "$dest"

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    # Create symlink
    ln -sf "$src" "$dest"
    log "Linked $dest"
}

# ============================================
# Detect shell and OS
# ============================================
detect_shell() {
    if [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    elif [ -n "$BASH_VERSION" ]; then
        echo "bash"
    elif [ "$SHELL" = "/bin/zsh" ]; then
        echo "zsh"
    else
        echo "bash"
    fi
}

OS="$(uname -s)"
SHELL_TYPE="$(detect_shell)"

log "Detected OS: $OS"
log "Detected shell: $SHELL_TYPE"

# ============================================
# Install shell config
# ============================================
if [ "$SHELL_TYPE" = "zsh" ]; then
    backup_and_link "$DOTFILES/shell/zshrc" "$HOME/.zshrc"
else
    backup_and_link "$DOTFILES/shell/bashrc" "$HOME/.bashrc"
fi

# ============================================
# Install git config
# ============================================
backup_and_link "$DOTFILES/git/gitconfig" "$HOME/.gitconfig"
backup_and_link "$DOTFILES/git/gitignore_global" "$HOME/.gitignore_global"

# ============================================
# Install tmux config
# ============================================
backup_and_link "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"

# ============================================
# Install SSH config defaults
# ============================================
mkdir -p "$HOME/.ssh/sockets"
chmod 700 "$HOME/.ssh"
chmod 700 "$HOME/.ssh/sockets"

# Append SSH defaults if not already present
if [ -f "$HOME/.ssh/config" ]; then
    if ! grep -q "ControlMaster auto" "$HOME/.ssh/config" 2>/dev/null; then
        log "Appending SSH defaults to ~/.ssh/config"
        echo "" >> "$HOME/.ssh/config"
        echo "# Added by dotfiles installer" >> "$HOME/.ssh/config"
        cat "$DOTFILES/ssh/config_defaults" >> "$HOME/.ssh/config"
    else
        warn "SSH config already has ControlMaster settings, skipping"
    fi
else
    log "Creating ~/.ssh/config with defaults"
    cp "$DOTFILES/ssh/config_defaults" "$HOME/.ssh/config"
fi
chmod 600 "$HOME/.ssh/config"

# ============================================
# Install neovim config (optional)
# ============================================
if [ "$INSTALL_NEOVIM" = true ]; then
    mkdir -p "$HOME/.config/nvim"
    backup_and_link "$DOTFILES/nvim/init.vim" "$HOME/.config/nvim/init.vim"
fi

# ============================================
# Install basic tools (Linux only)
# ============================================
if [ "$OS" = "Linux" ] && command -v apt &>/dev/null; then
    log "Installing basic tools via apt..."
    sudo apt update -qq
    sudo apt install -y -qq tmux htop curl wget git ncdu 2>/dev/null || warn "Some packages failed to install"
fi

# ============================================
# Done!
# ============================================
echo ""
log "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.bashrc (or ~/.zshrc)"
echo "  2. Start tmux: tm"
echo "  3. For GPU monitoring: gpu or gpuwatch"
echo ""
if [ "$INSTALL_NEOVIM" = false ]; then
    echo "  To install neovim config, run: $DOTFILES/install.sh --full"
fi
