#!/usr/bin/env bash
# MIT License
#
# Copyright (c) 2026 Daniel Berg <mail@roosta.sh>
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
# ### [demo-layout.sh](./demo-layout.sh)
#
# Create a demonstartion layout in hyprland, opening several windows in a
# spesific arrangement. Add random pauses between actions to reduce mechanical
# appearance.
#
# Requirements:
# - https://github.com/kovidgoyal/kitty
# - https://github.com/karlstav/cava
# - https://www.asty.org/cmatrix/
# - https://github.com/aristocratos/btop
#
# Usage:
# ```sh
# ./demo-layout.sh
# ```
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

# jitter_sleep <ms> [spread_percent] — pause with human-ish variance

set -euo pipefail

jitter_sleep() {
  local ms=${1:-500} spread=${2:-25}
  local delta=$(( ms * spread / 100 ))
  local out=$(( ms - delta + RANDOM % (2 * delta + 1) ))
  (( RANDOM % 8 == 0 )) && out=$(( out + 150 + RANDOM % 450 ))  # occasional hesitation
  sleep "$(printf '%d.%03d' $(( out / 1000 )) $(( out % 1000 )))"
}

beat()  { jitter_sleep "${1:-100}"; }   # quick follow-up keystroke
pause() { jitter_sleep "${1:-250}"; }   # normal beat between actions
think() { jitter_sleep "${1:-600}"; }   # "deciding what to do next"

hyprctl eval 'hl.dispatch(hl.dsp.focus({workspace = 5}))'
think

hyprctl eval 'hl.dispatch(hl.dsp.exec_cmd("kitty btop"))'
think

hyprctl eval 'hl.dispatch(hl.dsp.layout("preselect d"))'
beat
hyprctl eval 'hl.dispatch(hl.dsp.exec_cmd("kitty cava"))'
pause

hyprctl eval 'hl.dispatch(hl.dsp.focus({window = "title:cava"}))'
pause
hyprctl eval 'hl.dispatch(hl.dsp.window.resize({
  y = 400, x = 0, relative = true, window = "title:cava"
}))'
think

hyprctl eval 'hl.dispatch(hl.dsp.focus({window = "title:btop"}))'
pause
hyprctl eval 'hl.dispatch(hl.dsp.exec_cmd("kitty cmatrix"))'
beat
hyprctl eval 'hl.dispatch(hl.dsp.window.resize({
  y = 0, x = 400, relative = true, window = "title:cmatrix"
}))'
think

hyprctl eval 'hl.dispatch(hl.dsp.exec_cmd("kitty --title fastfetch sh -c \"fastfetch --pipe false --logo none | more\""))'
