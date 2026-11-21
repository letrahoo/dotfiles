#!/usr/bin/env bash
set -euo pipefail

# Ensure Homebrew & user CLI paths are available when invoked by GUI iTerm2
for dir in "$HOME/.local/bin" "/opt/homebrew/bin" "/usr/local/bin"; do
  if [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]]; then
    PATH="$PATH:$dir"
  fi
done
export PATH

TARGET="${1:-}"
LINE="${2:-}"
CWD="${3:-}"
COLUMN=""

[[ -z "$TARGET" ]] && exit 0

# Handle file:// and other URL schemes
if [[ "$TARGET" == file://* ]]; then
  TARGET="${TARGET#file://localhost}"
  TARGET="${TARGET#file://}"
  if [[ "$TARGET" == *%* ]] && command -v python3 >/dev/null 2>&1; then
    TARGET="$(python3 -c 'import sys, urllib.parse; print(urllib.parse.unquote(sys.argv[1]))' "$TARGET")"
  fi
elif [[ "$TARGET" =~ ^[a-zA-Z][a-zA-Z0-9+.-]*:// ]]; then
  exec open "$TARGET"
fi

# Extract optional #L<line>, #<line>[:<col>], or :<line>[:<col>] (match 2-part before 1-part for POSIX greedy .+)
if [[ "$TARGET" =~ ^(.+)#L([0-9]+)(-L?[0-9]+)?$ ]]; then
  TARGET="${BASH_REMATCH[1]}"
  [[ -z "$LINE" ]] && LINE="${BASH_REMATCH[2]}"
elif [[ "$TARGET" =~ ^(.+)#([0-9]+):([0-9]+)$ ]]; then
  TARGET="${BASH_REMATCH[1]}"
  [[ -z "$LINE" ]] && LINE="${BASH_REMATCH[2]}"
  COLUMN="${BASH_REMATCH[3]}"
elif [[ "$TARGET" =~ ^(.+)#([0-9]+)$ ]]; then
  TARGET="${BASH_REMATCH[1]}"
  [[ -z "$LINE" ]] && LINE="${BASH_REMATCH[2]}"
elif [[ "$TARGET" =~ ^(.+):([0-9]+):([0-9]+)$ ]]; then
  TARGET="${BASH_REMATCH[1]}"
  [[ -z "$LINE" ]] && LINE="${BASH_REMATCH[2]}"
  COLUMN="${BASH_REMATCH[3]}"
elif [[ "$TARGET" =~ ^(.+):([0-9]+)$ ]]; then
  TARGET="${BASH_REMATCH[1]}"
  [[ -z "$LINE" ]] && LINE="${BASH_REMATCH[2]}"
fi

resolve_path() {
  local p="$1"
  if [[ "$p" == "~/"* ]]; then
    p="$HOME/${p#\~/}"
  fi
  if [[ "$p" == /* && -e "$p" ]]; then
    printf '%s\n' "$p"
    return 0
  fi
  if [[ -n "$CWD" && -e "$CWD/$p" ]]; then
    printf '%s\n' "$CWD/$p"
    return 0
  fi
  if command -v tmux >/dev/null 2>&1; then
    local attached_session pane_path
    attached_session="$(tmux list-clients -F '#{session_name}' 2>/dev/null | head -n 1 || true)"
    if [[ -n "$attached_session" ]]; then
      while IFS= read -r pane_path; do
        if [[ -n "$pane_path" && -e "$pane_path/$p" ]]; then
          printf '%s\n' "$pane_path/$p"
          return 0
        fi
      done < <(tmux list-panes -s -t "$attached_session" -F '#{?window_active,1,0} #{?pane_active,1,0} #{pane_current_path}' 2>/dev/null | sort -rn | cut -d' ' -f3-)
    fi
    while IFS= read -r pane_path; do
      if [[ -n "$pane_path" && -e "$pane_path/$p" ]]; then
        printf '%s\n' "$pane_path/$p"
        return 0
      fi
    done < <(tmux list-panes -a -F '#{pane_current_path}' 2>/dev/null || true)
  fi
  return 1
}

RESOLVED="$(resolve_path "$TARGET" || true)"
[[ -z "$RESOLVED" ]] && exit 0

find_goland() {
  local candidate
  for candidate in \
    "$HOME/Library/Application Support/JetBrains/Toolbox/scripts/goland" \
    "$HOME/Applications/GoLand.app/Contents/MacOS/goland" \
    "/Applications/GoLand.app/Contents/MacOS/goland" \
    "$(command -v goland 2>/dev/null || true)"; do
    if [[ -n "$candidate" && -x "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

find_vscode() {
  local candidate
  for candidate in \
    "$(command -v code 2>/dev/null || true)" \
    "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" \
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"; do
    if [[ -n "$candidate" && -x "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

if GOLAND_BIN="$(find_goland)"; then
  if [[ ! -d "$RESOLVED" && "$LINE" =~ ^[0-9]+$ ]]; then
    exec "$GOLAND_BIN" --line "$LINE" "$RESOLVED"
  else
    exec "$GOLAND_BIN" "$RESOLVED"
  fi
fi

if CODE_BIN="$(find_vscode)"; then
  if [[ ! -d "$RESOLVED" && "$LINE" =~ ^[0-9]+$ ]]; then
    if [[ "$COLUMN" =~ ^[0-9]+$ ]]; then
      exec "$CODE_BIN" --goto "$RESOLVED:$LINE:$COLUMN"
    else
      exec "$CODE_BIN" --goto "$RESOLVED:$LINE"
    fi
  else
    exec "$CODE_BIN" "$RESOLVED"
  fi
fi

exec open "$RESOLVED"
