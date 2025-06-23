#!/bin/bash

# Installation script for phantom-dlp
# This script will install phantom-dlp as a system command

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_NAME="phantom-dlp"
SCRIPT_FILE="phantom-dlp.sh"

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

info() {
    echo -e "${BLUE}[INSTALL]${NC} $1"
}

# Method 1: Install to /usr/local/bin (Recommended)
install_system_wide() {
    info "Installing phantom-dlp system-wide to /usr/local/bin"
    
    if [[ ! -f "$SCRIPT_FILE" ]]; then
        error "phantom-dlp.sh not found in current directory"
        exit 1
    fi
    
    # Copy script to /usr/local/bin without .sh extension
    sudo cp "$SCRIPT_FILE" "/usr/local/bin/$SCRIPT_NAME"
    
    # Make executable
    sudo chmod +x "/usr/local/bin/$SCRIPT_NAME"
    
    # Set proper ownership
    sudo chown root:root "/usr/local/bin/$SCRIPT_NAME"
    
    log "✓ phantom-dlp installed to /usr/local/bin/$SCRIPT_NAME"
    log "✓ You can now run 'phantom-dlp' from anywhere"
}

# Method 2: Install to ~/.local/bin (User-specific)
install_user_local() {
    info "Installing phantom-dlp for current user to ~/.local/bin"
    
    if [[ ! -f "$SCRIPT_FILE" ]]; then
        error "phantom-dlp.sh not found in current directory"
        exit 1
    fi
    
    # Create ~/.local/bin if it doesn't exist
    mkdir -p "$HOME/.local/bin"
    
    # Copy script
    cp "$SCRIPT_FILE" "$HOME/.local/bin/$SCRIPT_NAME"
    
    # Make executable
    chmod +x "$HOME/.local/bin/$SCRIPT_NAME"
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc" 2>/dev/null || true
        warning "Added $HOME/.local/bin to PATH in .bashrc and .zshrc"
        warning "Run 'source ~/.bashrc' or restart your terminal"
    fi
    
    log "✓ phantom-dlp installed to $HOME/.local/bin/$SCRIPT_NAME"
    log "✓ You can now run 'phantom-dlp' from anywhere"
}

# Method 3: Create symlink in /usr/local/bin
create_symlink() {
    info "Creating symlink to phantom-dlp in /usr/local/bin"
    
    if [[ ! -f "$PWD/$SCRIPT_FILE" ]]; then
        error "phantom-dlp.sh not found in current directory"
        exit 1
    fi
    
    # Make current script executable
    chmod +x "$PWD/$SCRIPT_FILE"
    
    # Create symlink
    sudo ln -sf "$PWD/$SCRIPT_FILE" "/usr/local/bin/$SCRIPT_NAME"
    
    log "✓ Symlink created: /usr/local/bin/$SCRIPT_NAME -> $PWD/$SCRIPT_FILE"
    log "✓ You can now run 'phantom-dlp' from anywhere"
    warning "Note: Don't move or delete the original script file"
}

# Method 4: Add alias to shell rc files
create_alias() {
    info "Creating alias for phantom-dlp in shell configuration"
    
    if [[ ! -f "$PWD/$SCRIPT_FILE" ]]; then
        error "phantom-dlp.sh not found in current directory"
        exit 1
    fi
    
    # Make script executable
    chmod +x "$PWD/$SCRIPT_FILE"
    
    local alias_line="alias phantom-dlp='$PWD/$SCRIPT_FILE'"
    
    # Add to bash configuration
    if ! grep -q "alias phantom-dlp=" "$HOME/.bashrc" 2>/dev/null; then
        echo "$alias_line" >> "$HOME/.bashrc"
        log "✓ Added alias to ~/.bashrc"
    fi
    
    # Add to zsh configuration if zsh is installed
    if command -v zsh &> /dev/null && [[ -f "$HOME/.zshrc" ]]; then
        if ! grep -q "alias phantom-dlp=" "$HOME/.zshrc" 2>/dev/null; then
            echo "$alias_line" >> "$HOME/.zshrc"
            log "✓ Added alias to ~/.zshrc"
        fi
    fi
    
    log "✓ Alias created for phantom-dlp"
    warning "Run 'source ~/.bashrc' or restart your terminal"
    warning "Note: Don't move or delete the original script file"
}

# Method 5: Install as AUR package (Advanced)
create_pkgbuild() {
    info "Creating PKGBUILD for phantom-dlp"
    
    mkdir -p "phantom-dlp-pkg"
    cd "phantom-dlp-pkg"
    
    cat > PKGBUILD << 'EOF'
# Maintainer: Your Name <your.email@example.com>
pkgname=phantom-dlp
pkgver=1.0
pkgrel=1
pkgdesc="Advanced yt-dlp wrapper with user-friendly interface"
arch=('any')
url="https://github.com/yourusername/phantom-dlp"
license=('MIT')
depends=('yt-dlp' 'ffmpeg' 'bash')
source=("phantom-dlp.sh")
sha256sums=('SKIP')

package() {
    install -Dm755 "${srcdir}/phantom-dlp.sh" "${pkgdir}/usr/bin/phantom-dlp"
}
EOF
    
    cp "../$SCRIPT_FILE" .
    
    log "✓ PKGBUILD created in phantom-dlp-pkg directory"
    log "To build and install:"
    log "  cd phantom-dlp-pkg"
    log "  makepkg -si"
    
    cd ..
}

# Uninstall function
uninstall() {
    info "Uninstalling phantom-dlp..."
    
    # Remove from system locations
    if [[ -f "/usr/local/bin/$SCRIPT_NAME" ]]; then
        sudo rm "/usr/local/bin/$SCRIPT_NAME"
        log "✓ Removed from /usr/local/bin"
    fi
    
    if [[ -f "$HOME/.local/bin/$SCRIPT_NAME" ]]; then
        rm "$HOME/.local/bin/$SCRIPT_NAME"
        log "✓ Removed from ~/.local/bin"
    fi
    
    # Remove aliases
    if grep -q "alias phantom-dlp=" "$HOME/.bashrc" 2>/dev/null; then
        sed -i '/alias phantom-dlp=/d' "$HOME/.bashrc"
        log "✓ Removed alias from ~/.bashrc"
    fi
    
    if [[ -f "$HOME/.zshrc" ]] && grep -q "alias phantom-dlp=" "$HOME/.zshrc" 2>/dev/null; then
        sed -i '/alias phantom-dlp=/d' "$HOME/.zshrc"
        log "✓ Removed alias from ~/.zshrc"
    fi
    
    log "✓ phantom-dlp uninstalled"
}

# Check if running as installer
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo -e "${BLUE}=== PHANTOM-DLP INSTALLER ===${NC}"
    echo "Choose installation method:"
    echo "1) System-wide installation (/usr/local/bin) [Recommended]"
    echo "2) User-local installation (~/.local/bin)"
    echo "3) Create symlink (/usr/local/bin -> current location)"
    echo "4) Create shell alias"
    echo "5) Create PKGBUILD for Arch package"
    echo "6) Uninstall phantom-dlp"
    echo "0) Exit"
    
    read -p "Enter choice [1]: " choice
    choice=${choice:-1}
    
    case $choice in
        1) install_system_wide ;;
        2) install_user_local ;;
        3) create_symlink ;;
        4) create_alias ;;
        5) create_pkgbuild ;;
        6) uninstall ;;
        0) exit 0 ;;
        *) error "Invalid choice"; exit 1 ;;
    esac
fi