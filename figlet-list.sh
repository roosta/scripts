#!/usr/bin/env bash
# MIT License
#
# Copyright (c) 2025 Daniel Berg <mail@roosta.sh>
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
# BEGIN_DOC
# ### [figlet-list.sh](./figlet-list.sh)
#
# Script to display all toilet/figlet fonts with sample text in `$PAGER`
#
# Requirements:
# - https://github.com/cacalabs/toilet
# - https://github.com/xero/figlet-fonts
#
# Usage
# ```sh
# ./figlet-list.sh
# ```
#
# Script will try `/usr/share/figlet` and `$HOME/lib/figlet-fonts`. I got extra
# fonts installed in the latter.
# 
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

TOILET_FONT_PATH=${TOILET_FONT_PATH:=/usr/share/figlet}
FIGLET_FONTS_PATH="$HOME/lib/figlet-fonts"
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

    # Skip if no matches were found
    [[ -e "$i" ]] || continue

    # Extract just the filename from the path
    file=${i##*/}
    name=${file%.*}
    dir=${i%/*}

    # ASCII source:
    # https://github.com/xero/dotfiles
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

