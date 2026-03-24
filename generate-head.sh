#!/usr/bin/env bash
# MIT License
#
# Copyright (c) 2026 Daniel Berg <mail@roosta.sh>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Drafted March 2026 based on LLM suggestion (claude-4.6-sonnet)
# reviewed and edited by Daniel Berg <mail@roosta.sh>
#
# BEGIN_DOC
# ### [generate-head.sh](./generate-head.sh)
#
# Generate a file heading for dotfiles
#
# Requirements:
# - https://github.com/cacalabs/toilet
# - https://github.com/xero/figlet-fonts
#
# Usage:
# ```bash
# ./generate-head.sh <text> [font]  # Outputs the head
# ```
#
# >[!TIP]
# > Set AUTHOR, GITHUB, LICENSE env vars to override defaults.
# > Set FONT_DIR to point to your figlet fonts directory.
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

set -euo pipefail

INPUT="${1:?Usage: $0 <text> [font]}"
FONT="${2:-pagga}"
FONT_DIR="${FONT_DIR:-$HOME/lib/figlet-fonts}"

AUTHOR="${AUTHOR:-Daniel Berg <mail@roosta.sh>}"
GITHUB="${GITHUB:-https://github.com/roosta/dotfiles}"
LICENSE="${LICENSE:-GNU General Public License v3}"

L_BLOCK="█▀▀▀▀▀▀▀▀█"
R_BLOCK="█▀▀▀▀▀▀▀▀█"
L_SEP="█▀▀▀▀▀▀▀▀▀"
R_SEP="▀▀▀▀▀▀▀▀▀█"
MIN_PAD=2

charlen() { printf "%s" "$1" | wc -m; }

repeat() {
  local i
  for ((i = 0; i < $2; i++)); do printf "%s" "$1"; done
}

# Generate toilet art, strip blank lines
mapfile -t LINES < <(
  toilet -d "$FONT_DIR" -f "$FONT" -- "$INPUT" \
    | sed '/^[[:space:]]*$/d'
)

[[ ${#LINES[@]} -eq 0 ]] && { echo "Error: toilet produced no output" >&2; exit 1; }

# Find max character width across all toilet lines
MAX_TXT=0
for line in "${LINES[@]}"; do
  len=$(charlen "$line")
  (( len > MAX_TXT )) && MAX_TXT=$len
done

# Minimum INNER for info lines: lb(2) + " "(1) + label(7) + " : "(3) + value + rb(2) = INNER+2
# => INNER >= 13 + max_info_len
MAX_INFO=0
for val in "$AUTHOR" "$GITHUB" "$LICENSE"; do
  vlen=$(charlen "$val")
  (( vlen > MAX_INFO )) && MAX_INFO=$vlen
done

PAD_L=$MIN_PAD
PAD_R=$MIN_PAD
L_BLOCK_LEN=$(charlen "$L_BLOCK")
R_BLOCK_LEN=$(charlen "$R_BLOCK")
INNER=$(( L_BLOCK_LEN + PAD_L + MAX_TXT + PAD_R + R_BLOCK_LEN ))

# Expand padding equally if info lines don't fit; right gets the extra if deficit is odd
MIN_INNER=$(( 13 + MAX_INFO ))
if (( INNER < MIN_INNER )); then
  DEFICIT=$(( MIN_INNER - INNER ))
  PAD_L=$(( MIN_PAD + DEFICIT / 2 ))
  PAD_R=$(( MIN_PAD + (DEFICIT + 1) / 2 ))
  INNER=$(( L_BLOCK_LEN + PAD_L + MAX_TXT + PAD_R + R_BLOCK_LEN ))
fi

# Build decorators with final padding
L_DECO="${L_BLOCK}$(repeat '░' "$PAD_L")"
R_DECO="$(repeat '░' "$PAD_R")${R_BLOCK}"

# ── Top border ────────────────────────────────────────────────────────────────────────────
printf "┌%s┐\n" "$(repeat '─' "$INNER")"

# ── Text art lines ───────────────────────────────────────────────────────────────────────
for line in "${LINES[@]}"; do
  len=$(charlen "$line")
  pad=$(( MAX_TXT - len ))
  printf "│%s%s%s%s│\n" "$L_DECO" "$line" "$(repeat '░' "$pad")" "$R_DECO"
done

# ── Separator ───────────────────────────────────────────────────────────────────────────
sep_dashes=$(( INNER - $(charlen "$L_SEP") - $(charlen "$R_SEP") ))
printf "│%s%s%s│\n" "$L_SEP" "$(repeat '─' "$sep_dashes")" "$R_SEP"

# ── Info lines ──────────────────────────────────────────────────────────────────────────
# Layout: lb(2) + " " + label(7) + " : " + value + padding + rb(2) = INNER + 2
# => padding = INNER - 13 - len(value)
info_line() {
  local lb="$1" rb="$2" label="$3" value="$4"
  local pad=$(( INNER - 13 - $(charlen "$value") ))
  (( pad < 0 )) && pad=0
  printf "%s %-7s : %s%*s%s\n" "$lb" "$label" "$value" "$pad" "" "$rb"
}

info_line "├┤" "├┤" "Author"  "$AUTHOR"
info_line "││" "││" "Github"  "$GITHUB"
info_line "├┤" "├┤" "License" "$LICENSE"

# ── Bottom border ────────────────────────────────────────────────────────────────────────
printf "┆└%s┘┆\n" "$(repeat '─' "$(( INNER - 2 ))")"

