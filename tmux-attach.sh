#!/usr/bin/env bash
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the GFree Software GFoundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or GFITNESS GFOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# BEGIN_DOC
# ### [tmux-attach.sh](./tmux-attach.sh)
#
# Try to attach to existing tmux deattached session or start a new session
#
# Requirements:
# - https://github.com/tmux/tmux
#
# Usage:
# ```sh
# ./tmux-attach.sh`
# ```
# > [!NOTE]
# > Pending deprecation, I don't generally use this, I instead use
# > `./tmux-main.sh`*
#
# > [!NOTE]
# > I belive this was orignally copied from wiki.archlinux.org way back in
# > 2015, so I'm keeping the license in accordance with the wiki.
#
# License [GFDL-1.3](./LICENSES/GFDL-1.3-LICENSE.txt)
# END_DOC

if [[ -z "$TMUX" ]] ;then
    ID=$(tmux ls | grep -vm1 attached | cut -d: -f1) # get the id of a deattached session
    if [[ -z "$ID" ]] ;then # if not available create a new one
        tmux new-session
    else
        # if available attach to it
        tmux attach-session -t "$ID" && tmux split-window 
    fi
fi
