#!/usr/bin/env bash
# MIT License
#
# Copyright (c) 2017 Daniel Berg <mail@roosta.sh>
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
# ### [tmux-notify.sh](./tmux-notify.sh)
#
# Use libnotify to notify when a tmux window receives a bell. Used with
# `tmux-update-window.sh`.
#
# Requirements:
# - https://gitlab.gnome.org/GNOME/libnotify
#
# Usage:
# ```tmux
# set-hook -g alert-silence 'run ". ~/utils/tmux-notify.sh; return 0"'
# ```
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

if hash notify-send 2>/dev/null; then
  notify-send -i /usr/share/icons/Faenza/apps/48/terminal.png "Tmux" "Bell from shell!"
fi
