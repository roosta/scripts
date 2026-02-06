#!/usr/bin/env bash
# MIT License
#
# Copyright (c) 2025 Daniel Berg <mail@roosta.sh>
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
# ### [system-monitor.sh](./system-monitor.sh)
#
# System monitor
#
# Requirements:
# - https://github.com/kovidgoyal/kitty
# - https://github.com/aristocratos/btop
#
# Usage:
# ```sh
# ./system-monitor.sh`
# ```
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

kitty -o 'font_size=12' btop -p 1

# Start alacritty with custom font size and btop as a command. Start it on
# workspace 15, and go back to the previously active workspace.
# Requires: sway, kitty, and btop.
# swaymsg "workspace number 15; exec kitty -o 'font_size=16' btop; workspace back_and_forth"
