#!/bin/bash

# Will create a lua file from a repo identifier: repo/name
# This was created to speed up migration from vimrc to init.lua
#
# Requires toilet + rusto font installed to work
# https://github.com/cacalabs/toilet
# https://github.com/xero/figlet-fonts
#
# Also asumes lazy.nvim is being used with a structured file layout
# https://lazy.folke.io/usage/structuring
#
# Usage
# ./add-vim-plugin.sh "roosta/fzf-folds.vim"

# Check if a repository was provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 repo/name"
  exit 1
fi

repo=$1
name=$(basename "$repo")

# Generate ASCII art with toilet
art=$(toilet -d "$HOME/lib/figlet-fonts" -f "rusto" "$name")

{
  # Add each line of ASCII art with Lua comment
  echo "$art" | while IFS= read -r line; do
    echo "-- $line"
  done

  # Add a separator line
  echo "-- $(printf '─%.0s' {1..73})"
  echo ""

  # Add the Lua return statement
  echo "return {"
  echo "  \"$repo\","
  echo "}"
} > "$name".lua

# Print the result
cat "$name".lua
