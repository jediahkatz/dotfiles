#!/usr/bin/env bash
set -euo pipefail

# macOS dotfiles install script
# Run from the dotfiles directory: ./scripts/install-macos.sh

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "Installing dotfiles from $DOTFILES"

# ─── Homebrew ────────────────────────────────────────────────────────────────

if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew already installed."
fi

# ─── Brew packages ───────────────────────────────────────────────────────────

echo "Installing brew packages..."
packages=(
  tmux fd bat lsd diff-so-fancy ripgrep fzf hub nano tlrc mise
)

for pkg in "${packages[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    echo "  $pkg: already installed"
  else
    echo "  Installing $pkg..."
    brew install "$pkg"
  fi
done

# ─── Oh My Zsh ───────────────────────────────────────────────────────────────

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh already installed."
fi

# ─── Zsh plugins ─────────────────────────────────────────────────────────────

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

plugin_names=(fzf-tab zsh-z zsh-autosuggestions fast-syntax-highlighting)
plugin_urls=(
  "https://github.com/Aloxaf/fzf-tab"
  "https://github.com/agkozak/zsh-z"
  "https://github.com/zsh-users/zsh-autosuggestions"
  "https://github.com/zdharma-continuum/fast-syntax-highlighting"
)

echo "Installing zsh plugins..."
for i in "${!plugin_names[@]}"; do
  plugin="${plugin_names[$i]}"
  url="${plugin_urls[$i]}"
  if [ -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
    echo "  $plugin: already installed"
  else
    echo "  Installing $plugin..."
    git clone "$url" "$ZSH_CUSTOM/plugins/$plugin"
  fi
done

# ─── Powerlevel10k ───────────────────────────────────────────────────────────

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
  echo "Powerlevel10k already installed."
fi

# ─── Mise (version manager for Node, Python, etc.) ──────────────────────────

if command -v mise &>/dev/null; then
  echo "mise already installed. Installing Node LTS..."
  mise use --global node@lts 2>/dev/null || true
else
  echo "mise not found — should have been installed via brew above."
fi

# ─── TPM (Tmux Plugin Manager) ──────────────────────────────────────────────

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  echo "TPM already installed."
fi

# ─── Font ────────────────────────────────────────────────────────────────────

if brew list --cask font-meslo-lg-nerd-font &>/dev/null; then
  echo "MesloLGS Nerd Font already installed."
else
  echo "Installing MesloLGS Nerd Font..."
  brew install --cask font-meslo-lg-nerd-font
fi

# ─── Symlinks ────────────────────────────────────────────────────────────────

echo "Creating symlinks..."

create_symlink() {
  local src="$1"
  local dest="$2"

  if [ -L "$dest" ]; then
    local current_target
    current_target="$(readlink "$dest")"
    if [ "$current_target" = "$src" ]; then
      echo "  $dest -> $src (already linked)"
      return
    fi
    echo "  Removing existing symlink $dest -> $current_target"
    rm "$dest"
  elif [ -f "$dest" ]; then
    echo "  Backing up $dest to ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  ln -s "$src" "$dest"
  echo "  $dest -> $src"
}

create_symlink "$DOTFILES/.zshrc"          "$HOME/.zshrc"
create_symlink "$DOTFILES/.p10k.zsh"       "$HOME/.p10k.zsh"
create_symlink "$DOTFILES/.alacritty.toml" "$HOME/.alacritty.toml"
create_symlink "$DOTFILES/osx/.tmux.conf"  "$HOME/.tmux.conf"
create_symlink "$DOTFILES/osx/.nanorc"     "$HOME/.nanorc"

# ─── Install tmux plugins ───────────────────────────────────────────────────

echo "Installing tmux plugins via TPM..."
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

# ─── Done ────────────────────────────────────────────────────────────────────

echo ""
echo "Done! Restart your terminal or run: exec zsh -l"
echo ""
echo "Manage tool versions with mise:"
echo "  mise use node@20       # install and use Node 20 in current directory"
echo "  mise use --global node@lts  # set global default"
echo "  mise ls                # list installed versions"
