#!/usr/bin/env bash
# MIT License
#
# Copyright (c) 2018 Daniel Berg <mail@roosta.sh>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the “Software”), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# BEGIN_DOC
# ### [waybar-dev.sh](./waybar-dev.sh)
#
# Uses `entr` to watch for changes in my Waybar config files, and will restart
# Waybar on save. I use this when I develop themes and customization, you can
# pass `-d` to open a GTK debugger window as well, to get CSS selectors used
# for styling Waybar.
#
# Requirements:
# - https://eradman.com/entrproject/
# - https://github.com/Alexays/Waybar
#
# Usage:
#
# ```tmux
# ./waybar-dev.sh [OPTIONS]
#
#     OPTIONS:
#       -d, --debug      open debug inspector
# ```
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

# Parse command line arguments
DEBUG_MODE=0
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -d|--debug) DEBUG_MODE=1 ;;
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
  shift
done

CONFIG_FILES=(
  "$HOME/.config/waybar/config.jsonc"
  "$HOME/.config/waybar/modules.jsonc"
  "$HOME/.config/waybar/style.css"
)

# Create the command based on debug mode
if [ $DEBUG_MODE -eq 1 ]; then
  printf '%s\n' "${CONFIG_FILES[@]}" | entr -r env GTK_DEBUG=interactive waybar
else
  printf '%s\n' "${CONFIG_FILES[@]}" | entr -r waybar
fi
