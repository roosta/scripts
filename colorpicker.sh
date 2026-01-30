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
# ### [colorpicker.sh](./colorpicker.sh)
#
# Starts a colorpicker and saves result to clipboard
#
# Requirements:
#
# - https://github.com/bugaevc/wl-clipboard
# - https://github.com/hyprwm/hyprpicker
#
# Usage
#
# ```sh
# ./colorpicker.sh
# ```
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

# Added sleep here because otherwise rofi will be open when hyprpicker "freeze"
# the screen
# sleep .2s && hyprpicker -a "$@"

flatpak run com.github.finefindus.eyedropper

