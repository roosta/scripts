#!/usr/bin/env bash

# Copyright (C) 2020 Daniel Berg <mail@roosta.sh>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# ====================================

# This script is used with fzf as a preview script. Shows the file
# content around the search query match in fzf preview window

# This script expects 2 arguments, $1 current line, $2 query, here is
# an example of its usage:

# Find in files
# fif() {
#   match=$(\rg \
#             --smart-case \
#             --color "always" \
#             --line-number \
#             --hidden \
#             --no-heading . | fzf -d ":" --ansi --nth "2.." --with-nth "1,3.." --preview="fzf-preview {} {q}") &&
#     linum=$(echo "$match" | cut -d':' -f2) &&
#     file=$(echo "$match" | cut -d':' -f1) &&
#     emacsclient -nw +$linum $file && popd
# }

# Make sure the script is on your $PATH

# If pygmentize is installed this script will colorize certain filetypes
# If you'd like more filetypes supported simply modify _get_filetype
# function.

set -euo pipefail
IFS=$'\n\t'

_fzf_preview() {
  local file linum total half_lines start end total
  match="$1"
  file=$(echo "$match" | cut -d':' -f1)
  linum=$(echo "$match" | cut -d':' -f2)
  if [ -f "$file" ]; then
    linum=$(echo "$match" | cut -d':' -f2)
    total=$(wc -l < "$file")
    half_lines=$(( FZF_PREVIEW_LINES / 2))

    # Setup beginning and end of context
    [[ $(( linum - half_lines )) -lt 1 ]] && start=1 || start=$(( linum - half_lines ))
    [[ $(( linum + half_lines )) -gt $total ]] && end=$total || end=$(( linum + half_lines ))
    [[ $start -eq 1 &&  $end -ne $total ]] && end=$FZF_PREVIEW_LINES

    bat --number \
        ---color=always \
        --highlight-line "$linum" \
        --line-range "${start}:${end}" "$file"
    fi
}

_exit_if_unsupported() {
  local version version_only_digits supported_version supported_version_only_digits

  version=$(fzf --version | awk '{print $1}')
  version_only_digits=$(echo "$version" | tr -dC '[:digit:]')
  supported_version="0.18.0"
  supported_version_only_digits=$(echo "$supported_version" | tr -dC '[:digit:]')
  if [ "$version_only_digits" -lt "$supported_version_only_digits" ]; then
    echo "fzf-preview.sh: Unsupported fzf version ($version), upgrade to $supported_version or higher" >&2;
    exit 1;
  fi
  command -v bat >/dev/null 2>&1 || { echo "fzf-preview.sh: bat needs to be installed for this script to work" >&2; exit 1; }
}

main() {
  if [ "$#" != "1" ]; then
    echo "fzf-preview.sh: this scripts takes exactly one argument" >&2;
    exit 1;
  else
    _exit_if_unsupported
    _fzf_preview "$@"
  fi
}

main "$@"
