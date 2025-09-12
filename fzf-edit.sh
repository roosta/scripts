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
# ### [fzf-edit.sh](./fzf-edit.sh)
#
# Quicky find and edit files using fzf and fd
# 
# Requirements:
# - https://github.com/sharkdp/fd
# - https://github.com/junegunn/fzf
#
# Usage:
# ```bash
# ./fzf-edit.sh              # Fuzzy find files in current directory and open in $EDITOR
# ./fzf-edit <file> ..       # Open specified file(s) in $EDITOR
# ./fzf-edit <multiple args> # Pass all arguments to $EDITOR
# ```
#
# >[!TIP]
# > Using zsh I symlink this to `$fpath`, add it as a zle widget, and bind it
# > to a shortcut, as well as have it autoloaded.
#
# License [GPL-3.0](./LICENSES/GPL-3.0-LICENSE.txt)
# END_DOC

function fzf_edit() {
  if [ "$#" -eq 0 ]; then
    local files
    files=$(fd --type file --color=always --strip-cwd-prefix)
    fzf \
      --ansi \
      --preview-window 'right:60%' --multi \
      --bind "enter:execute(echo -en '\033]0;${EDITOR:-nvim} {}\a')+become(${EDITOR:-nvim} {+})" \
      --preview 'bat --color=always --style=numbers {}' <<< "$files"
  else
    ${EDITOR:-nvim} "$@"
  fi
}

fzf_edit "$@"
