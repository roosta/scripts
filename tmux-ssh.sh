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
# ### [tmux-ssh.sh](./tmux-ssh.sh)
#
# Starts a new session called `ssh` that launches [ngrok](https://ngrok.com/),
# I use this sometimes if I need to access a computer over ssh that doesn't
# have a static ip.
#
# Requirements:
# - https://ngrok.com/
# - https://github.com/tmux/tmux
#
# Usage:
# Takes TCP PORT as argument to ngrok.
#
# ```tmux
# ./tmux-ssh.sh [PORT]
# ```
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC
if [ -z "$1" ]; then
  echo "No port number argument"
  exit 1
else
  if ! tmux has-session -t ssh 2>/dev/null; then
    tmux new-session -s ssh -n ngrok -d
    tmux send-keys -t ssh "ngrok tcp $1" C-m
  else
    echo "There is already an SSH session"
    exit 1
  fi
fi
