#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Bootstrap started from $REPO_DIR"

link_path() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  # If destination is an actual directory (not a symlink), remove it so ln -sfn doesn't nest inside it
  if [[ -d "$dst" && ! -L "$dst" ]]; then
    rm -rf "$dst"
  fi
  ln -sfn "$src" "$dst"
  echo "  linked: $dst -> $src"
}

# 1. Oh My Zsh & Third-Party Plugins (idempotent clone if missing)
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "Installing Oh My Zsh..."
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
else
  echo "✓ Oh My Zsh already installed"
fi

ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM_DIR/plugins"

if [[ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
else
  echo "✓ zsh-syntax-highlighting already installed"
fi

if [[ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]]; then
  echo "Installing zsh-autosuggestions..."
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
    "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
else
  echo "✓ zsh-autosuggestions already installed"
fi

# 2. Vim & Neovim (symlink config files while preserving local plugged/ and undodir/)
for target_dir in "$HOME/.config/nvim" "$HOME/.vim"; do
  mkdir -p "$target_dir/autoload"
  for item in init.vim plug.vim keymap.vim coc-settings.json colors; do
    link_path "$REPO_DIR/vim/$item" "$target_dir/$item"
  done
  link_path "$REPO_DIR/vim/autoload/plug.vim" "$target_dir/autoload/plug.vim"
done
link_path "$REPO_DIR/vim/vimrc" "$HOME/.vimrc"

# 3. Zsh & Tmux (symlink .zshrc, .zprofile, .tmux.conf; keep local ~/.zshrc.local untouched)
link_path "$REPO_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_path "$REPO_DIR/zsh/.zprofile" "$HOME/.zprofile"
if [[ -f "$REPO_DIR/tmux/.tmux.conf" ]]; then
  link_path "$REPO_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
fi
if [[ -f "$REPO_DIR/tmux/tmux-server.sh" ]]; then
  link_path "$REPO_DIR/tmux/tmux-server.sh" "$HOME/.local/bin/tmux-server"
fi
if [[ -f "$HOME/.zshrc.local" ]]; then
  echo "✓ Preserved untracked local overrides at ~/.zshrc.local"
fi

# 4. iTerm2 Dynamic Profiles, Tmux LaunchAgent & Minimal Appearance (macOS)
if [[ "$(uname -s)" == "Darwin" ]]; then
  ITERM_DYN_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  mkdir -p "$ITERM_DYN_DIR"
  link_path "$REPO_DIR/iterm2/open-in-goland.sh" "$HOME/.local/bin/open-in-goland"
  for profile in "$REPO_DIR"/iterm2/DynamicProfiles/*.json; do
    link_path "$profile" "$ITERM_DYN_DIR/$(basename "$profile")"
  done

  if [[ -f "$REPO_DIR/tmux/com.user.tmux.plist" ]]; then
    TMUX_PLIST="$HOME/Library/LaunchAgents/com.user.tmux.plist"
    link_path "$REPO_DIR/tmux/com.user.tmux.plist" "$TMUX_PLIST"
    GUI_DOMAIN="gui/$(id -u)"
    if launchctl print "$GUI_DOMAIN/com.user.tmux" >/dev/null 2>&1; then
      echo "✓ com.user.tmux LaunchAgent already running (existing tmux sessions preserved)"
    else
      launchctl bootstrap "$GUI_DOMAIN" "$TMUX_PLIST"
      echo "✓ Bootstrapped com.user.tmux LaunchAgent ($GUI_DOMAIN)"
    fi
  fi

  # Set Everforest Dark (High Contrast) as default profile & Minimal tab bar theme
  defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "everforest-dark-hc-0001"
  defaults write com.googlecode.iterm2 TabStyleWithAutomaticOption -int 5
  defaults write com.googlecode.iterm2 HideTabNumber -bool true
  defaults write com.googlecode.iterm2 HideTabCloseButton -bool true
  defaults write com.googlecode.iterm2 StretchTabsToFillBar -bool true
fi

echo "Bootstrap ended"
