#!/usr/bin/env bash
# =============================================================================
# Script to display all toilet/figlet fonts with sample text
# =============================================================================
# It will try /usr/share/figlet and /usr/share/figlet/fonts. I got extra fonts
# installed in the latter.
# Refs:
# =============================================================================
# https://github.com/xero/figlet-fonts
# https://github.com/xero/dotfiles

TOILET_FONT_PATH=${TOILET_FONT_PATH:=/usr/share/figlet}
FIGLET_FONTS_PATH="/usr/share/figlet/fonts"
PAGER=${PAGER:=less}

process_fonts_from_dir() {
  local dir=$1

  if [[ ! -d "$dir" ]]; then
    echo "Directory not found: $dir"
    return
  fi

  echo "=== Fonts from $dir ==="
  echo ""

  # Loop through all toilet and figlet font files
  for i in "${dir}"/*.{t,f}lf; do

    # Skip if no matches were found (happens when the glob doesn't match any files)
    [[ -e "$i" ]] || continue

    # Extract just the filename from the path
    file=${i##*/}
    name=${file%.*}
    dir=${i%/*}

    echo ""
    echo "╓───── $file"
    echo "╙────────────────────────────────────── ─ ─ "
    echo ""
    toilet -d "$dir" -f "$file" "$name"
  done
}

{
  process_fonts_from_dir "$TOILET_FONT_PATH"
  process_fonts_from_dir "$FIGLET_FONTS_PATH"
} | "$PAGER"

