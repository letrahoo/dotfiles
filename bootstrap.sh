#!/usr/bin/env bash
set -euo pipefail

echo "Bootstrap started"

# 1. Vim & Neovim
mkdir -p ~/.vim ~/.config/nvim
cp -r vim/ ~/.vim
cp -r vim/ ~/.config/nvim

# 2. Zsh
cp ./zsh/.zshrc ~/.zshrc

# 3. iTerm2 Dynamic Profiles & Appearance (macOS)
if [[ "$(uname -s)" == "Darwin" ]]; then
  ITERM_DYN_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  mkdir -p "$ITERM_DYN_DIR"
  cp ./iterm2/DynamicProfiles/*.json "$ITERM_DYN_DIR/"

  # Set Everforest Dark (High Contrast) as default profile & Minimal tab bar theme
  defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "everforest-dark-hc-0001"
  defaults write com.googlecode.iterm2 TabStyleWithAutomaticOption -int 5
  defaults write com.googlecode.iterm2 HideTabNumber -bool true
  defaults write com.googlecode.iterm2 HideTabCloseButton -bool true
  defaults write com.googlecode.iterm2 StretchTabsToFillBar -bool true
fi

echo "Bootstrap ended"
