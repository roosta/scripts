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
# Commit changed lock file to dotfiles. Pass --sync to also update using
# lazy.nvim, otherwise it will commit a dirty lock file.
#
# Requirements:
# - https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git
# - https://github.com/folke/lazy.nvim
# 
# Usage:
# ```bash
# ./update-nvim-plugins.sh [--sync]
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

# Optional: Update plugins if --sync flag is provided
if [[ "$1" == "--sync" ]]; then
  echo "Syncing plugins..."
  nvim --headless "+Lazy! sync" +qa
fi

# Get relative path from home directory for git operations
LOCKFILE_REL="${LOCKFILE#"$HOME"/}"

# Check if lockfile exists and is tracked in git
if [[ -f "$LOCKFILE" ]] && dotfiles show "HEAD:$LOCKFILE_REL" > /dev/null 2>&1; then
  COMMITTED_LOCKFILE=$(dotfiles show "HEAD:$LOCKFILE_REL")
  if ! echo "$COMMITTED_LOCKFILE" | diff -q - "$LOCKFILE" &>/dev/null; then
    UPDATED_PLUGINS=$(echo "$COMMITTED_LOCKFILE" | diff \
      --changed-group-format='%>' \
      --unchanged-group-format='' - "$LOCKFILE" | 
      grep -o '"[^"]*": {' | 
      sed 's/": {//' | 
      tr -d '"')

    # Commit changes
    dotfiles add "$LOCKFILE"
    dotfiles commit \
      -m "nvim/lazy: update plugins" \
      -m "Updated plugins:" \
      -m "$(echo "$UPDATED_PLUGINS" | sed 's/^/- /')"

    echo "Plugin changes committed to dotfiles."
  else
    echo "No plugin updates to commit."
  fi
elif [[ -f "$LOCKFILE" ]]; then
  # First time adding lockfile
  echo "Adding lockfile to dotfiles for the first time."
  dotfiles add "$LOCKFILE"
  dotfiles commit -m "nvim/lazy: add initial lockfile"
else
  echo "Lockfile not found at $LOCKFILE"
  exit 1
fi
