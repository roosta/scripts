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
#       [all desk mirror single tv] Switch to specified display configuration
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
  ["single"]="single.lua"
)

declare -A SWITCH_FUNCTIONS=(
  ["desk"]="spread_workspaces"
  ["all"]="spread_workspaces"
  ["mirror"]="spread_workspaces"
  ["tv"]="switch_to_tv"
  ["single"]="switch_to_single"
)

is_valid_config() {
  [[ -n "${CONFIG_FILES[$1]}" ]]
}

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S'): $1"
}

# Require in monitors.lua to get defined outputs
get_var() {
  local key="$1"
  local monitors_file="$CONFIG_DIR/monitors.lua"
  if [ -f "$monitors_file" ]; then
    lua -e "local m = dofile('$monitors_file'); print(m['$key'] or '')"
  else
    echo ""
  fi
}

# Monitors
# Assume each config defines these variables
LEFT_DISPLAY=$(get_var "left")
CENTER_DISPLAY=$(get_var "center")
RIGHT_DISPLAY=$(get_var "right")
TV_DISPLAY=$(get_var "tv")
TOP_DISPLAY=$(get_var "top")

workspace_exists() {
  local workspace_id="$1"
  hyprctl workspaces -j | jq -r '.[].id' | grep -q "^$workspace_id$"
}

_get_current_mode() {
  if [ -L "$CURRENT_CONFIG" ]; then
    local target
    target=$(readlink "$CURRENT_CONFIG")

    local basename
    basename=$(basename "$target")

    # Remove the .conf suffix to get the mode name
    if [[ "$basename" == *.lua ]]; then
      echo "${basename%.lua}"
    else
      echo "unknown"
    fi
  else
    echo "none"
  fi
}

# Build a lua string of workspace move commands to be passed to eval
move_workspaces() {
  local -n _pairs=$1
  local lua_cmds=()

  for pair in "${_pairs[@]}"; do
    local ws="${pair%%=*}"
    local mon="${pair#*=}"
    if workspace_exists "$ws"; then
      lua_cmds+=("hl.dispatch(hl.dsp.workspace.move({ workspace = \"$ws\", monitor = \"$mon\" }))")
    fi
  done

  if [ ${#lua_cmds[@]} -gt 0 ]; then
    local script
    printf -v script '%s; ' "${lua_cmds[@]}"
    hyprctl eval "$script"
  fi
}

# spread workspaces across multiple monitors
spread_workspaces() {
  local pairs=()

  for i in {1..10};  do pairs+=("$i=$CENTER_DISPLAY"); done
  for i in {11..14}; do pairs+=("$i=$LEFT_DISPLAY");   done
  for i in {15..18}; do pairs+=("$i=$TOP_DISPLAY");    done
  for i in {19..22}; do pairs+=("$i=$RIGHT_DISPLAY");  done

  log "Executing batch move move of workspaces..."
  move_workspaces pairs
}

# Collects workspaces to a single target monitor $1
collect_workspaces() {
  local monitor="$1"
  local workspaces
  workspaces=$(hyprctl workspaces -j | jq -r '.[].id')

  local pairs=()
  for ws in $workspaces; do
    pairs+=("$ws=$monitor")
  done

  move_workspaces pairs
}

# Just for xorg, need it so that some games will open on correct monitor
set_primary_monitor() {
  local primary
  primary=$(get_var "primary_monitor")
  log "Setting xorg primary display to $primary"
  xrandr --output "$primary" --primary
}

link_config() {
  local config_file="$CONFIG_DIR/${CONFIG_FILES[$1]}"

  if [[ ! -f "$config_file" ]]; then
    log "ERROR: $config_file not found"
    return 1
  fi

  log "Linking config file $config_file"
  ln -sf "$config_file" "$CURRENT_CONFIG" || {
    log "ERROR: Failed to create $config_file symlink"
      return 1
    }
  # hyprctl reload
}

switch_layout() {
  local switch_func="${SWITCH_FUNCTIONS[$1]}"
  if [[ -n "$switch_func" ]]; then
    "$switch_func"
  fi
}

switch_to_tv() {
  collect_workspaces "$TV_DISPLAY"
  /bin/bash "$HOME"/scripts/switch-audio.sh tv
}

switch_to_single() {
  collect_workspaces "$CENTER_DISPLAY"
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

link_config "$1"
switch_layout "$1"

# vim: set ts=2 sw=2 tw=0 fdm=marker et :
