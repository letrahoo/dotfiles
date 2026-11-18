# Development tools & Homebrew login environment
typeset -U path
path=("$HOME/.local/bin" $path)
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# JetBrains Toolbox scripts (if installed)
if [[ -d "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]]; then
  path+=("$HOME/Library/Application Support/JetBrains/Toolbox/scripts")
fi

export PATH
