#!/bin/bash

set -e

CHAR_INDEX=0

get_next_char() {
  case $CHAR_INDEX in
    0) CHAR_OUT="|"; CHAR_INDEX=1 ;;
    1) CHAR_OUT="/"; CHAR_INDEX=2 ;;
    2) CHAR_OUT="-"; CHAR_INDEX=3 ;;
    3) CHAR_OUT="\\"; CHAR_INDEX=0 ;;
  esac
}

log() {
  get_next_char
  echo -e "$CHAR_OUT  $1"
}
log_success() {
  get_next_char
  printf "\033[0;32m%s\033[0m  %s\n" "$CHAR_OUT" "$1"
}
log_warning() {
  get_next_char
  printf "\033[1;33m%s\033[0m  %s\n" "$CHAR_OUT" "$1"
}
log_error() {
  get_next_char
  printf "\033[0;31m%s\033[0m  %s\n" "$CHAR_OUT" "$1"
}
log_blank() {
  get_next_char
  echo -e "$CHAR_OUT  "
}
log_start() {
  echo -e "*  $1"
}
log_end() {
  echo -e "*  $1"
}

detect_system() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    if [[ $(uname -m) == "arm64" ]]; then
      ARCH="arm64"
      HOMEBREW_PREFIX="/opt/homebrew"
    else
      ARCH="x86_64"
      HOMEBREW_PREFIX="/usr/local"
    fi
  elif [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "linux-musl"* ]] || [[ "$OSTYPE" == "linux"* ]]; then
    OS="linux"
    ARCH=$(uname -m)
    HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  else
    log_error "Unsupported: $OSTYPE"
    exit 1
  fi

  log "Detected: $OS ($ARCH)"
}

exists() {
  command -v "$1" >/dev/null 2>&1
}

ask_confirmation() {
  local prompt="$1"
  local default="${2:-n}"
  
  if [[ "$default" == "y" ]]; then
    echo -n "$prompt [Y/n]: "
  else
    echo -n "$prompt [y/N]: "
  fi
  
  read -r response
  case "$response" in
    [yY][eE][sS]|[yY])
      return 0
      ;;
    [nN][oO]|[nN])
      return 1
      ;;
    "")
      if [[ "$default" == "y" ]]; then
        return 0
      else
        return 1
      fi
      ;;
    *)
      return 1
      ;;
  esac
}

backup_configs() {
  log "Backing up existing configs..."
  BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
  mkdir -p "$BACKUP_DIR"

  configs=("bat" "delta" "fish" "ghostty" "nvim" "yazi" "zellij" "starship.toml" "zellij")

  for config in "${configs[@]}"; do
    if [[ -e "$HOME/.config/$config" ]]; then
      log "    Backing up ~/.config/$config"
      mv "$HOME/.config/$config" "$BACKUP_DIR/$config"
    fi
  done

  if [[ -e "$HOME/.gitconfig" ]]; then
    log "    Backing up ~/.gitconfig"
    mv "$HOME/.gitconfig" "$BACKUP_DIR/.gitconfig"
  fi

  log_success "Backup completed in $BACKUP_DIR"
}

install_ruby_linux() {
  if [[ "$OS" != "linux" ]]; then
    return
  fi

  if exists ruby; then
    local ruby_version
    ruby_version=$(ruby --version 2>/dev/null || echo "unknown")
    log_success "Ruby already installed: $ruby_version"
    log "    Ruby location: $(which ruby)"
    return
  fi

  log "Installing Ruby (required for Homebrew on Linux)..."
  log "Package manager detection:"

  for cmd in dnf yum dnf5 apt-get apk pacman; do
    if exists "$cmd"; then
      log "    Found: $cmd -> $(command -v $cmd)"
    fi
  done

  if exists dnf; then
    sudo dnf group install -y development-tools
    sudo dnf install -y ruby ruby-devel git
  elif exists apk; then
    sudo apk add --no-cache ruby ruby-dev build-base git
  elif exists apt-get; then
    sudo apt-get update && sudo apt-get install -y ruby ruby-dev build-essential git
  elif exists pacman; then
    sudo pacman -S --noconfirm ruby base-devel git
  else
    log_warning "Could not install Ruby automatically. Please install Ruby manually."
    return 1
  fi

  if exists ruby; then
    local ruby_version
    ruby_version=$(ruby --version 2>/dev/null || echo "unknown")
    log_success "Ruby installed: $ruby_version"
    log "    Ruby location: $(which ruby)"
  else
    log_error "Ruby installation failed"
    return 1
  fi
}

install_homebrew() {
  if exists brew; then
    log_success "Homebrew already installed"
    return
  fi

  if [[ "$OS" == "linux" ]]; then
    install_ruby_linux
  fi

  log "Installing Homebrew..."
  
  export NONINTERACTIVE=1
  
  if ! curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh > /dev/null 2>&1; then
    log_error "Failed to download Homebrew install script"
    return 1
  fi
  
  if bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    if [[ "$OS" == "linux" ]]; then
      eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
    elif [[ "$OS" == "macos" && "$ARCH" == "arm64" ]]; then
      eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
    fi
    log_success "Homebrew installed"
  else
    log_error "Homebrew installation failed"
    log "Trying to continue without Homebrew..."
    return 1
  fi
}

clone_dotfiles() {
  if [[ -d "$HOME/dotfiles" ]]; then
    log_warning "~/dotfiles already exists. Pulling latest changes..."
    cd "$HOME/dotfiles"
    git pull origin main || {
      log_warning "    Failed to pull latest changes, continuing with existing dotfiles"
    }
  else
    log "Cloning dotfiles repository..."
    git clone https://github.com/956MB/dotfiles.git "$HOME/dotfiles" || {
      log_error "Failed to clone dotfiles repository"
      exit 1
    }
  fi

  log_success "Dotfiles repository ready"
}

create_symlinks() {
  log "Creating symlinks..."
  mkdir -p "$HOME/.config"

  configs=("bat" "btop" "delta" "fish" "ghostty" "nvim" "yazi" "zellij" "starship.toml" "zellij")

  for config in "${configs[@]}"; do
    if [[ -d "$HOME/dotfiles/$config" ]]; then
      ln -sf "$HOME/dotfiles/$config" "$HOME/.config/$config"
      log_success "    Linked ~/.config/$config"
    else
      log_warning "    Config directory $config not found in dotfiles"
    fi
  done

  if [[ -f "$HOME/dotfiles/starship/starship.toml" ]]; then
    ln -sf "$HOME/dotfiles/starship/starship.toml" "$HOME/.config/starship.toml"
    log_success "    Linked ~/.config/starship.toml"
  else
    log_warning "    starship.toml not found in dotfiles/starship/"
  fi

  if [[ -f "$HOME/dotfiles/.gitconfig" ]]; then
    if ask_confirmation "Link .gitconfig? (This will replace current git configuration)"; then
      ln -sf "$HOME/dotfiles/.gitconfig" "$HOME/.gitconfig"
      log_success "    Linked ~/.gitconfig"
    else
      log "    Skipped linking .gitconfig"
    fi
  else
    log_warning "    .gitconfig not found in dotfiles"
  fi
}

install_packages() {
  if [[ ! -f "$HOME/dotfiles/Brewfile" ]]; then
    log_warning "Brewfile not found, skipping package installation"
    return
  fi

  if ! ask_confirmation "Install additional packages from Brewfile? (development tools, utilities)"; then
    log "Skipping package installation"
    return
  fi

  log "Installing packages from Brewfile..."
  
  brew update || {
    log_warning "Failed to update Homebrew, continuing with installation"
  }
  
  if [[ "$OS" == "linux" ]]; then
    log "    Installing core packages (GUI apps not supported on Linux)"
    brew bundle --file="$HOME/dotfiles/Brewfile" || {
      log_warning "Some packages failed to install, continuing..."
    }
  else
    if ask_confirmation "Install GUI applications? (browsers, editors, utilities)"; then
      log "    Installing all packages including GUI applications..."
      brew bundle --file="$HOME/dotfiles/Brewfile" || {
        log_warning "Some packages failed to install, continuing..."
      }
    else
      log "    Installing core packages only (skipping GUI applications)..."
      brew bundle --file="$HOME/dotfiles/Brewfile" --no-cask || {
        log_warning "Some packages failed to install, continuing..."
      }
    fi
  fi
  
  log_success "Package installation completed"
}

install_fish_tools() {
  if ! exists brew; then
    log_warning "Homebrew not available, skipping Fish tools installation"
    return 1
  fi

  log "Installing essential Fish shell tools..."
  
  local tools=("eza" "starship" "zoxide" "zellij")
  
  for tool in "${tools[@]}"; do
    if exists "$tool"; then
      log_success "$tool already installed"
    else
      log "    Installing $tool..."
      brew install "$tool" || {
        log_warning "Failed to install $tool, continuing..."
      }
    fi
  done
  
  log_success "Fish tools installation completed"
}

set_fish_shell() {
  if ! exists brew; then
    log_warning "Homebrew not available, skipping Fish shell setup"
    return 1
  fi

  log "Installing Fish shell..."
  brew install fish || {
    log_error "Failed to install Fish shell"
    return 1
  }

  FISH_PATH="$HOMEBREW_PREFIX/bin/fish"

  if [[ ! -f "$FISH_PATH" ]]; then
    log_error "Fish shell not found at $FISH_PATH after installation"
    return 1
  fi

  if [[ "$SHELL" == "$FISH_PATH" ]]; then
    log_success "Fish is already the default shell"
    return
  fi

  log "Setting Fish as default shell..."

  if ! grep -q "$FISH_PATH" /etc/shells 2>/dev/null; then
    log "    Adding fish to /etc/shells (requires sudo)"
    echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null || {
      log_error "Failed to add fish to /etc/shells"
      return 1
    }
  fi

  chsh -s "$FISH_PATH" || {
    log_error "Failed to change default shell to fish"
    return 1
  }

  log_success "Fish installed"
}

show_logo() {
  clear
  echo -e "
*            /////////////////////////////    
|          /···|/////////////////////|···|    
/         |·/||/                    /||/      
-       /·|  /·|                  |||/        
\\      |·/    |·/              /|·|/          
|    /·|      /·|            /|·|/            
/   ||/        |·/         /||/               
- /··|/////////|·|       /||////            //
\\ ////////////////    /|||//|||·|        /|||/
|                   /|·|||||/  |·|    /|||/   
/                 /|···||/      |·|/|||/      
-               /|··||/         /···/         
\\            /|··||/         /|||/|·|         
|          /|··|/         /|||/    |·|        
/        /|·|/         /|···|//////|··|       
-        //            ////////////////       
\\  
* -> https://github.com/956MB/dotfiles <- *
|
/  This script will install and configure development tools and dotfiles"
  echo -e "\033[1;33m-\033[0m  It will backup existing configs and install: Homebrew, Fish shell, and more"
  echo -e "\\  Usage: install.sh [--packages-only | -p] for packages only"
  echo -e "|  "

  while true; do
    echo -n "*  Press Enter to continue, 'p' for packages only, 'q' to quit, or Ctrl+C to cancel..."
    read -r -n1 response
    echo ""
    case "$response" in
      ""|$'\n')
        break
        ;;
      [pP])
        packages_only
        return
        ;;
      [qQ])
        echo "|  Installation cancelled"
        exit 0
        ;;
      *)
        echo "/  Invalid input. Press Enter to continue or 'q' to quit."
        ;;
    esac
  done
}

packages_only() {
  show_logo
  log_start "Installing packages only..."
  detect_system
  
  if [[ ! -d "$HOME/dotfiles" ]]; then
    clone_dotfiles
  fi
  
  install_packages
  log_end "Package installation completed!"
}

main() {
  if [[ "$1" == "--packages-only" || "$1" == "-p" ]]; then
    packages_only
    return
  fi
  
  show_logo
  log_start "Starting dotfiles installation..."
  detect_system
  backup_configs
  install_homebrew
  clone_dotfiles
  create_symlinks
  install_packages
  install_fish_tools
  set_fish_shell
  log_success "Dotfiles installation completed!"
  log_end "Initializing Fish shell ($FISH_PATH)..."
  
  exec "$FISH_PATH"
}

main "$@"
