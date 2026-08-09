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
# Setup a terminal window layout for demo purposes
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

hyprctl eval 'hl.dispatch(hl.dsp.exec_cmd("kitty btop"))'
sleep 0.5
hyprctl eval 'hl.dispatch(hl.dsp.exec_cmd("kitty cava"))'
sleep 0.5
hyprctl eval 'hl.dispatch(hl.dsp.layout("togglesplit"))'
sleep 0.5
hyprctl eval 'hl.dispatch(hl.dsp.window.resize({
  y = 400,
  x = 0,
  relative = true,
  window = "title:cava"
}))'
sleep 0.5
hyprctl eval 'hl.dispatch(hl.dsp.focus({window = "title:btop"}))'
sleep 0.5
hyprctl eval 'hl.dispatch(hl.dsp.exec_cmd("kitty cmatrix"))'
sleep 0.5
hyprctl eval 'hl.dispatch(hl.dsp.window.resize({
  y = 0,
  x = 400,
  relative = true,
  window = "title:cmatrix"
}))'
