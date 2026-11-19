#!/usr/bin/env bash
set -euo pipefail

# Ensure HOME and UTF-8 locale are populated under launchd's minimal environment
export HOME="${HOME:-$(cd ~ && pwd)}"
export LANG="${LANG:-en_US.UTF-8}"
export LC_CTYPE="${LC_CTYPE:-en_US.UTF-8}"

# Dynamically prepend common binary directories (lowest to highest priority)
for dir in \
  "/usr/local/sbin" \
  "/usr/local/bin" \
  "/opt/homebrew/sbin" \
  "/opt/homebrew/bin" \
  "$HOME/go/bin" \
  "$HOME/.local/bin"; do
  if [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]]; then
    PATH="$dir:$PATH"
  fi
done
export PATH

# Optional local overrides (e.g., TMUX_BIN, TMUX_LOG_DIR, TMUX_LOG_FILE)
if [[ -f "$HOME/.config/tmux/env" ]]; then
  # shellcheck disable=SC1091
  source "$HOME/.config/tmux/env"
fi

TMUX_BIN="${TMUX_BIN:-$(command -v tmux || true)}"
if [[ -z "$TMUX_BIN" || ! -x "$TMUX_BIN" ]]; then
  echo "[tmux-server] error: tmux binary not found in PATH ($PATH)" >&2
  exit 1
fi

LOG_DIR="${TMUX_LOG_DIR:-$HOME/Library/Logs}"
LOG_FILE="${TMUX_LOG_FILE:-$LOG_DIR/tmux-server.log}"
mkdir -p "$LOG_DIR"

cd "$HOME"
exec "$TMUX_BIN" -D >>"$LOG_FILE" 2>&1
