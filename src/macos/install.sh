#!/bin/bash

# =============================================================================
# Automated macOS Development Environment Setup Script
# =============================================================================
# This script sets up a complete development environment using:
# - Homebrew for package management
# - Brewfile for declarative package installation
# - Dotfiles symlink management
# - Zsh plugins installation
# =============================================================================

set -e  # Exit on any error

# Color codes for better output readability
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

# Configuration
readonly DOTFILES_DIR="$HOME/Documents/GitHub/dotfiles"
readonly BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# =============================================================================
# Helper Functions
# =============================================================================

print_header() {
    echo -e "\n${BOLD}${BLUE}=== $1 ===${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# =============================================================================
# Main Installation Functions
# =============================================================================

install_homebrew() {
    print_header "Homebrew Installation"
    
    if command -v brew &> /dev/null; then
        print_success "Homebrew already installed"
        print_info "Updating Homebrew..."
        brew update
    else
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        print_success "Homebrew installed successfully"
    fi
}

install_packages() {
    print_header "Package Installation via Brewfile"
    
    local brewfile_path="$DOTFILES_DIR/src/macos/Brewfile"
    
    if [ -f "$brewfile_path" ]; then
        print_info "Installing packages from Brewfile..."
        brew bundle --file="$brewfile_path" --no-lock
        print_success "All packages installed successfully"
    else
        print_warning "Brewfile not found at $brewfile_path, skipping package installation"
    fi
}

setup_directories() {
    print_header "Directory Setup"
    
    print_info "Creating necessary directories..."
    mkdir -p ~/.zsh
    mkdir -p ~/.config
    mkdir -p "$BACKUP_DIR"
    
    print_success "Directories created"
}

install_zsh_plugins() {
    print_header "Zsh Plugins Installation"
    
    local plugins=(
        "zsh-users/zsh-syntax-highlighting:~/.zsh/zsh-syntax-highlighting"
        "zsh-users/zsh-autosuggestions:~/.zsh/zsh-autosuggestions"
        "marlonrichert/zsh-autocomplete:~/.zsh/zsh-autocomplete"
    )
    
    for plugin in "${plugins[@]}"; do
        local repo="${plugin%%:*}"
        local path="${plugin##*:}"
        local name=$(basename "$path")
        
        if [ ! -d "$path" ]; then
            print_info "Installing $name..."
            git clone "https://github.com/$repo.git" "$path"
            print_success "$name installed"
        else
            print_warning "$name already exists, updating..."
            (cd "$path" && git pull)
        fi
    done
}

create_symlinks() {
    print_header "Dotfiles Symlink Creation"
    
    local dotfiles=(".zshrc" ".zshenv" ".vimrc" ".gitconfig")
    
    for file in "${dotfiles[@]}"; do
        local source_file="$DOTFILES_DIR/$file"
        local target_file="$HOME/$file"
        
        # Backup existing file if it exists and isn't a symlink
        if [ -f "$target_file" ] && [ ! -L "$target_file" ]; then
            print_warning "Backing up existing $file"
            mv "$target_file" "$BACKUP_DIR/"
        fi
        
        # Create symlink if source exists
        if [ -f "$source_file" ]; then
            ln -sf "$source_file" "$target_file"
            print_success "Linked $file"
        else
            print_warning "Source file $source_file not found"
        fi
    done
}

configure_shell() {
    print_header "Shell Configuration"
    
    local current_shell=$(basename "$SHELL")
    
    if [ "$current_shell" != "zsh" ]; then
        print_info "Setting Zsh as default shell..."
        local zsh_path=$(which zsh)
        
        if ! grep -q "$zsh_path" /etc/shells; then
            print_info "Adding Zsh to /etc/shells..."
            echo "$zsh_path" | sudo tee -a /etc/shells
        fi
        
        chsh -s "$zsh_path"
        print_success "Zsh set as default shell"
    else
        print_success "Zsh is already the default shell"
    fi
}

setup_fzf() {
    print_header "FZF Configuration"
    
    if command -v fzf &> /dev/null; then
        print_info "Setting up FZF key bindings..."
        $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
        print_success "FZF configured"
    else
        print_warning "FZF not found, skipping configuration"
    fi
}

cleanup_and_finish() {
    print_header "Cleanup and Final Steps"
    
    # Remove empty backup directory
    if [ -d "$BACKUP_DIR" ] && [ ! "$(ls -A "$BACKUP_DIR")" ]; then
        rmdir "$BACKUP_DIR"
        print_info "Empty backup directory removed"
    elif [ -d "$BACKUP_DIR" ]; then
        print_info "Original files backed up to: $BACKUP_DIR"
    fi
    
    print_success "🎉 Setup completed successfully!"
    print_info "Please restart your terminal or run 'source ~/.zshrc' to apply changes"
}

# =============================================================================
# Main Execution
# =============================================================================

main() {
    echo -e "${BOLD}${GREEN}"
    echo "🚀 Starting Automated Development Environment Setup"
    echo "=================================================="
    echo -e "${NC}"
    
    install_homebrew
    install_packages
    setup_directories
    install_zsh_plugins
    create_symlinks
    configure_shell
    setup_fzf
    cleanup_and_finish
}

# Execute main function
main "$@"