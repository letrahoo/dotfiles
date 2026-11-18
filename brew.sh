#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Updating Homebrew..."
brew update

FORMULAE=(
  git
  tree
  neovim
  ripgrep
  jq
  tmux
  gh
  fnm
)

for pkg in "${FORMULAE[@]}"; do
  if brew list --formula "$pkg" >/dev/null 2>&1 || command -v "${pkg/neovim/nvim}" >/dev/null 2>&1 && [[ "$pkg" != "ripgrep" ]]; then
    echo "✓ $pkg already available"
  elif [[ "$pkg" == "ripgrep" ]] && command -v rg >/dev/null 2>&1; then
    echo "✓ ripgrep (rg) already available"
  else
    echo "Installing $pkg..."
    brew install "$pkg"
  fi
done

# Terminal Font: Maple Mono NF CN (Everforest default 16pt font)
if brew list --cask font-maple-mono-nf-cn >/dev/null 2>&1; then
  echo "✓ font-maple-mono-nf-cn already installed"
else
  echo "Installing font-maple-mono-nf-cn..."
  brew install --cask font-maple-mono-nf-cn
fi

# iTerm2 (skip if already installed in /Applications)
if [[ -d "/Applications/iTerm.app" ]] || brew list --cask iterm2 >/dev/null 2>&1; then
  echo "✓ iTerm2 already installed"
else
  echo "Installing iTerm2..."
  brew install --cask iterm2
fi

brew cleanup
echo "Brew dependencies ready."
