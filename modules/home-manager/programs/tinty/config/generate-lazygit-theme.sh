#!/usr/bin/env bash
# Generate lazygit theme colors from a tinted-shell script.
# Called by tinty as a hook for the tinted-shell item.
#
# Usage: generate-lazygit-theme.sh <tinted-shell-script-path>

set -euo pipefail

SHELL_SCRIPT="$1"
CONFIG_FILE="$HOME/.config/lazygit/theme.yml"

if [ ! -f "$SHELL_SCRIPT" ]; then
  echo "generate-lazygit-theme: shell script not found: $SHELL_SCRIPT" >&2
  exit 1
fi

# Extract colorXX="RR/GG/BB" and convert to #rrggbb
extract_color() {
  local varname="$1"
  local hex
  hex=$(grep "^${varname}=" "$SHELL_SCRIPT" | head -1 | sed 's/.*"\(.*\)".*/\1/' | tr -d '/')
  echo "#${hex}"
}

# Base16 color slots from tinted-shell variables
base00=$(extract_color "color00")  # background
base01=$(extract_color "color18")  # surface
base02=$(extract_color "color19")  # selection bg
base03=$(extract_color "color08")  # comments/muted
base04=$(extract_color "color20")  # dark fg
base05=$(extract_color "color07")  # foreground
base08=$(extract_color "color01")  # red
base0B=$(extract_color "color02")  # green
base0C=$(extract_color "color06")  # cyan
base0D=$(extract_color "color04")  # blue
base0E=$(extract_color "color05")  # purple

mkdir -p "$(dirname "$CONFIG_FILE")"

cat > "$CONFIG_FILE" << EOF
gui:
  theme:
    selectedLineBgColor:
      - '${base01}'
    activeBorderColor:
      - '${base0B}'
      - bold
    inactiveBorderColor:
      - '${base03}'
    searchingActiveBorderColor:
      - '${base0C}'
      - bold
    optionsTextColor:
      - '${base0D}'
    cherryPickedCommitFgColor:
      - '${base0D}'
    cherryPickedCommitBgColor:
      - '${base0C}'
    markedBaseCommitFgColor:
      - '${base0D}'
    markedBaseCommitBgColor:
      - '${base0E}'
    unstagedChangesColor:
      - '${base08}'
    defaultFgColor:
      - '${base05}'
EOF
