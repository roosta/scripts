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
# ### [audio-menu.sh](./audio-menu.sh)
#
# Creates a menu using [rofi-menu.sh](./rofi-menu.sh) 
#
# Requirements:
# - https://github.com/lbonn/rofi
# - [rofi-menu.sh](./rofi-menu.sh)
# - [switch-audio.sh](./switch-audio.sh)
#
# Usage:
# Called as a mode in rofi like this
#
# ```rasi
# configuration {
#   modes: "audio:~/scripts/audio-menu.sh";
# }
# ```
#
# Config for this menu looks like this:
# ```yml
# items:
#   - script: ~/scripts/switch-audio.sh
#     description: Switch to Speakers
#     icon: audio-speakers
#     args: ["speakers"]
# # ...
# ```
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

export ROFI_MENU_CONFIG="${XDG_CONFIG_HOME}/rofi-menu/audio.yml"
exec "${HOME}/scripts/rofi-menu.sh" "$@"
