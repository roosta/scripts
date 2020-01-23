#!/usr/bin/env bash

# Copyright (C) 2019 Daniel Berg <mail@roosta.sh>

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

# This script is used with fzf as a preview script. It expects 2
# arguments, $1 full match, $2 query, here is an example
# of its usage:

# rg --smart-case --line-number --no-heading . | fzf -d ":" --preview="fzf-preview {} {q}")

# Make sure the script is on your $path

# it shows a preview window of the file of the location that is
# selected. It is sized based on FZF_PREVIEW_LINES with the match in
# the middle, and highlights the search query.

# I made it for searching through org-mode files, I keep a lot of
# notes, and this helps me find what I'm looking for.
# TODO Optional colorize
# TODO Check for rg
set -euo pipefail
IFS=$'\n\t'

# Manually parse filetype
# For available lexers run
# pygmentize -L lexers
_get_filetype() {
  local file filetype
  file="$1"
    case "$1" in
         *.el)
           filetype="elisp"
           ;;
         *.clj)
           filetype="clojure"
           ;;
         *.cljs)
           filetype="clojurescript"
           ;;
         *.js | *.jsm)
           filetype="javascript"
           ;;
         *.css)
           filetype="css"
           ;;
         Makefile)
           filetype="makefile"
           ;;
         *.cpp | *.hpp | *.c++ | *.h++ | *.cc | *.hh | *.cxx | *.hxx | *.C | *.H | *.cp | *.CPP)
           filetype="cpp"
           ;;
         *.sh | *.ksh | *.bash | *.ebuild | *.eclass | *.exheres-0 | *.exlib | *.zsh | .bashrc | bashrc | .bash_* | bash_* | zshrc | .zshrc | PKGBUILD)
           filetype="bash"
           ;;
         *.py | *.pyw | *.jy | *.sage | *.sc | SConstruct | SConscript | *.bzl | BUCK | BUILD | BUILD.bazel | WORKSPACE | *.tac)
           filetype="python"
           ;;
         *) filetype=false
    esac
    echo "$filetype"

}

_fzf_preview() {
  local file linum total partial_match half_lines start end total context filetype query out
  current_line="$1"
  query="$2"
  file=$(echo "$current_line" | cut -d':' -f1)
  if [ -f "$file" ]; then
    linum=$(echo "$current_line" | cut -d':' -f2)
    total=$(wc -l < "$file")
    partial_match=$(echo "$current_line" | cut -d':' -f3-)
    half_lines=$(( FZF_PREVIEW_LINES / 2))
    filetype=$(_get_filetype "$file")

    [[ $(( linum - half_lines )) -lt 1 ]] && start=1 || start=$(( linum - half_lines ))
    [[ $(( linum + half_lines )) -gt $total ]] && end=$total || end=$(( linum + half_lines ))
    [[ $start -eq 1 &&  $end -ne $total ]] && end=$FZF_PREVIEW_LINES

    context=$(sed -n "${start},${end}p" "$file")

    if [ "$filetype" = false ]; then
      out="$context"
    else
      out=$(pygmentize -l "$filetype" <<< "$context")
    fi

    rg --no-line-number \
       --color "always" \
       --colors 'match:bg:magenta' \
       --colors 'match:fg:white' \
       --smart-case \
       --after-context "$end" \
       --before-context "$start" "$query" <<< "$out" || \
      rg --fixed-strings \
         --no-line-number \
         --color "always" \
         --colors 'match:bg:magenta' \
         --colors 'match:fg:white' \
         --after-context "$end" \
         --before-context "$start" "$partial_match" <<< "$out"
    fi
}

_exit_if_unsupported() {
  local version version_only_digits supported_version supported_version_only_digits
  version=$(fzf --version | awk '{print $1}')
  version_only_digits=$(echo "$version" | tr -dC '[:digit:]')
  supported_version="0.18.0"
  supported_version_only_digits=$(echo "$supported_version" | tr -dC '[:digit:]')
  if [ "$version_only_digits" -lt "$supported_version_only_digits" ]; then
    echo "Unsupported fzf version ($version), upgrade to $supported_version or higher"
    exit 1
  fi
}

main() {
  _exit_if_unsupported
  _fzf_preview "$@"
}

main "$@"
