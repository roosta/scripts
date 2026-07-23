#!/usr/bin/env bash
# MIT License
#
# Copyright (c) 2025 Daniel Berg <mail@roosta.sh>
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
# ### [switch-display.sh](./switch-display.sh)
#
# Hyprland display switcher using dynamic monitor configs, switch between
# monitor layouts.
#
# This script is spesifific to my home setup. It uses symlinks to swap out
# config for `~/.config/hypr/monitors/current.lua`. These lua files are
# hyprland config files with settings spesific to that display layout.
# Remember to require them monitors/current.lua symlink in your main hyprland
# config:
#
# ```lua
# require("monitors/current.lua")
# ```
#
#     Usage: ./switch-display.sh <config> [options]
#
#     Configurations:
#       [all desk mirror exclusive tv] Switch to specified display configuration
#
#     Example (Switch to desk configuration):
#       ./switch-display.sh desk
#
#     Note: Make sure to create lua files in $HOME/.config/hypr/monitors
#     matching argument name, e.g., desk.lua
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC


CONFIG_DIR="$HOME/.config/hypr/monitors"
CURRENT_CONFIG="$CONFIG_DIR/current.lua"

declare -A CONFIG_FILES=(
  ["desk"]="desk.lua"
  ["mirror"]="mirror.lua"
  ["all"]="all.lua"
  ["tv"]="tv.lua"
  ["exclusive"]="exclusive.lua"
)

is_valid_config() {
  [[ -n "${CONFIG_FILES[$1]}" ]]
}

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S'): $1"
}

link_config() {
  local config_file="$CONFIG_DIR/${CONFIG_FILES[$1]}"
  local tmp_link="$CURRENT_CONFIG.tmp.$$"

  if [[ ! -f "$config_file" ]]; then
    log "ERROR: $config_file not found"
    return 1
  fi

  log "Linking config file $config_file"
  if ! ln -sf "$config_file" "$tmp_link"; then
    log "ERROR: Failed to create temporary symlink"
    return 1
  fi

  if ! mv -T "$tmp_link" "$CURRENT_CONFIG"; then
    log "ERROR: Failed to move symlink into place"
    rm -f "$tmp_link"
    return 1
  fi
}

# Disable autoreload when linking config
switch_config() {
  hyprctl eval 'hl.config({misc = {disable_autoreload = true}})'

  # The trap here works by firing on function return, kinda like a finally,
  # ensuring that the autoreload is turned back on no matter what
  trap 'hyprctl eval "hl.config({misc = {disable_autoreload = false}})"' RETURN

  link_config "$1" || return 1
  hyprctl reload
}

if ! is_valid_config "$1"; then
  echo "Usage: $0 <config> [options]"
  echo ""
  echo "Configurations:"
  echo "  [${!CONFIG_FILES[*]}] Switch to specified display configuration"
  echo ""
  echo "Example (Switch to desk configuration):"
  echo "  $0 desk"
  echo ""
  echo "Note: Make sure to create config files in $CONFIG_DIR matching argument name, e.g., desk.conf"
  exit 1
fi

switch_config "$1"

# vim: set ts=2 sw=2 tw=0 fdm=marker et :
