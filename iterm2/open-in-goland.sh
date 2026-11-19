#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"
LINE="${2:-}"
CWD="${3:-}"

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

# Extract optional #L<line>, #<line>, or :<line> when iTerm2 \2 is empty
if [[ "$TARGET" =~ ^(.+)#L([0-9]+)(-L?[0-9]+)?$ ]]; then
  TARGET="${BASH_REMATCH[1]}"
  [[ -z "$LINE" ]] && LINE="${BASH_REMATCH[2]}"
elif [[ "$TARGET" =~ ^(.+)#([0-9]+)(:[0-9]+)?$ ]]; then
  TARGET="${BASH_REMATCH[1]}"
  [[ -z "$LINE" ]] && LINE="${BASH_REMATCH[2]}"
elif [[ "$TARGET" =~ ^(.+):([0-9]+)(:[0-9]+)?$ ]]; then
  TARGET="${BASH_REMATCH[1]}"
  [[ -z "$LINE" ]] && LINE="${BASH_REMATCH[2]}"
fi

resolve_path() {
  local p="$1"
  if [[ "$p" == ~/* ]]; then
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

GOLAND_BIN="$HOME/Library/Application Support/JetBrains/Toolbox/scripts/goland"
if [[ ! -x "$GOLAND_BIN" ]]; then
  GOLAND_BIN="$HOME/Applications/GoLand.app/Contents/MacOS/goland"
fi
if [[ ! -x "$GOLAND_BIN" ]]; then
  GOLAND_BIN="/Applications/GoLand.app/Contents/MacOS/goland"
fi

if [[ "$LINE" =~ ^[0-9]+$ ]]; then
  exec "$GOLAND_BIN" --line "$LINE" "$RESOLVED"
else
  exec "$GOLAND_BIN" "$RESOLVED"
fi
