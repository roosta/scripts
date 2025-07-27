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
# ### [add-vim-plugin.sh](./add-vim-plugin.sh)
#
# Will create a plugin file for lazy.nvim at ~/.config/nvim/lua/plugins from a
# repo identifier: repo/name This was created to speed up migration from vimrc
# to init.lua
#
# Requirements:
# - https://neovim.io/
# - https://github.com/cacalabs/toilet
# - https://github.com/xero/figlet-fonts
# - https://github.com/folke/lazy.nvim
#
# Also asumes lazy.nvim is being used with a structured file layout
# https://lazy.folke.io/usage/structuring
#
# Usage
# ```sh
# ./add-vim-plugin.sh "roosta/fzf-folds.vim"
# ```
# 
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

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
} > "$XDG_CONFIG_HOME/nvim/lua/plugins/$name".lua

# Print the result
cat "$XDG_CONFIG_HOME/nvim/lua/plugins/$name".lua
