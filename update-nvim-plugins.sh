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
# Drafted September 2025 based on LLM suggestion (claude-3.7-sonnet)
# reviewed and edited by Daniel Berg <mail@roosta.sh>
#
# BEGIN_DOC
# ### [update-nvim-plugins.sh](./update-nvim-plugins.sh)
#
# Syncs nvim plugins and commits changed lockfile to dotfiles.
#
# Requirements:
# - https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git
# - https://github.com/folke/lazy.nvim
# 
# Usage:
# ```bash
# ./update-nvim-plugins.sh
# ```
# 
# License [GPL-3.0](./LICENSES/GPL-3.0-LICENSE.txt)
# END_DOC
#
# shellcheck disable=SC2001

NVIM_CONFIG_DIR="${XDG_CONFIG_HOME}/nvim"
LOCKFILE="$NVIM_CONFIG_DIR/lazy-lock.json"

cd "$NVIM_CONFIG_DIR" || exit 1

dotfiles() {
  GIT_DIR="$HOME/.dotfiles" GIT_WORK_TREE="$HOME" git "$@"
}

if [ -f "$LOCKFILE" ]; then
  cp "$LOCKFILE" "$LOCKFILE.bak"
fi

# Update plugins
nvim --headless "+Lazy! sync" +qa

if ! diff -q "$LOCKFILE" "$LOCKFILE.bak" &>/dev/null; then

  # Get updated plugins to add to commit message 
  UPDATED_PLUGINS=$(diff \
    --changed-group-format='%>' \
    --unchanged-group-format='' "$LOCKFILE.bak" "$LOCKFILE" | 
      grep -o '"[^"]*": {' | 
      sed 's/": {//' | 
      tr -d '"')

  # Commit changes
  dotfiles add "$LOCKFILE"
  dotfiles commit \
    -m "nvim/lazy: update plugins" \
    -m "Updated plugins:" \
    -m "$(echo "$UPDATED_PLUGINS" | sed 's/^/- /')"

  echo "Plugins updated and changes committed."
else
  echo "No plugin updates available."
fi

# rm -f "$LOCKFILE.bak"
