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

# This script is used with fzf as a preview script. It expects 3
# arguments, $1 filename, $2 line number, $3 query, here is an example
# of its usage:

# rg --smart-case --line-number --no-heading . | fzf -d ":" --preview="fzf-preview {1} {2} {q}")

# it shows a preview window with 10 lines above and below displayed
# for the relevant match, and highlights the search query


total=$(wc -l < "$1")

if [[ $(( $2 - 10 )) -lt 1 ]]; then
  start=1
else
  start=$(( $2 - 10 ))
fi

if [[ $(( $2 + 10 )) -gt $total ]]; then
  end=$total
else
  end=$(( $2 + 10 ))
fi

context=$(sed -n "${start},${end}p" "$1")

echo "$context" | rg -N --colors 'match:fg:green' --smart-case --pretty --context 10 "$3" || "$context"

# asd=$(( $2 + 1))

# echo $start | cat
# file=$(echo "$1" | cut -d':' -f1)
# linum=$(echo "$1" | cut -d':' -f2)
# echo $start | cat
# echo $end | cat
# echo $1 | cat
# echo $2 | cat
# pandoc -s -f org -t plain "$1" 2> /dev/null | sed -n "${2}p"
# pandoc -s -f org -t html "$file" | w3m -T text/html +"$linum"
# emacsclient -nw +"$linum" "$file"

# pandoc -s -f org -t man "$*" | man -l -
