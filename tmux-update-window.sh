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
# ### [tmux-update-window.sh](./tmux-update-window.sh)
#
# Create an update window if `main` session exist. Set this window to monitor
# silence. When I start an update, and then do something else I'd like to be
# alerted on silence since that indicates that its either finished or requires
# input.
#
# Requirements:
# - https://ngrok.com/
# - https://github.com/tmux/tmux
#
# Usage:
# Requires a running tmux session
#
# ```tmux
# ./tmux-update-window.sh
# ```
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

tmux new-window -a -n update
tmux setw -t update monitor-silence 300
tmux send-keys -t update 'paru -Syyu --sudoloop' C-m
