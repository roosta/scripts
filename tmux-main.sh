#!/usr/bin/env bash
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# BEGIN_DOC
# ### [tmux-main.sh](./tmux-main.sh)
#
# Main session with default layout. Useful if you want tmux to always be
# started with terminal emulator. Source either in shell rc file, or in window
# manager on terminal emulator startup, or just run manually.
#
# Requirements:
# - https://github.com/tmux/tmux
#
# Usage:
# ```sh
# ./tmain.sh
# ```
#
# Resources:
# 1. https://unix.stackexchange.com/questions/80473/how-do-i-run-a-shell-command-from-tmux-conf/80529#80529
# 2. https://wiki.archlinux.org/title/Tmux#Autostart_tmux_with_default_tmux_layout
#
# License [GFDL-1.3](./LICENSES/GFDL-1.3-LICENSE.txt)
# END_DOC

if ! tmux has-session -t main 2>/dev/null; then
  tmux new-session -s main -n dev -d
  tmux split-window -h -d -t dev
  tmux new-window -a -n work -d
  # tmux new-window -a -n log -d
  # tmux new-window -a -n serve -d
fi
tmux attach -t main
