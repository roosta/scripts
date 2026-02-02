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
# config for `~/.config/hypr/monitors/current.conf`. These conf files are
# just hyprland config files with settings spesific to that display layout.
# Remember to source the symlink in your main hyprland config:
#
# ```hyprland
# source = ~/.config/hypr/monitors/current.conf
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
#     Note: Make sure to create config files in $HOME/.config/hypr/monitors matching argument name, e.g., desk.conf
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC


CONFIG_DIR="$HOME/.config/hypr/monitors"
CURRENT_CONFIG="$CONFIG_DIR/current.conf"

declare -A CONFIG_FILES=(
  ["desk"]="desk.conf"
  ["mirror"]="mirror.conf"
  ["all"]="all.conf"
  ["tv"]="tv.conf"
  ["single"]="single.conf"
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

# Looks for a variable in the config $primary_monitor, return monitor id
get_var() {
  if [ -f "$CURRENT_CONFIG" ]; then
    grep "\$$1 =" "$CURRENT_CONFIG" | sed 's/.*= //'
  else
    echo ""
  fi
}


# Monitors
# Assume each config defines these variables
LEFT_DISPLAY=$(get_var "left_monitor")
CENTER_DISPLAY=$(get_var "center_monitor")
RIGHT_DISPLAY=$(get_var "right_monitor")
TV_DISPLAY=$(get_var "tv_monitor")

workspace_exists() {
  local workspace_id="$1"
  hyprctl workspaces -j | jq -r '.[].id' | grep -q "^$workspace_id$"
}

move_workspace_if_exists() {
  local workspace_id="$1"
  local monitor="$2"

  if workspace_exists "$workspace_id"; then
    log "Moving workspace $workspace_id to monitor $monitor"
    hyprctl dispatch moveworkspacetomonitor "$workspace_id" "$monitor"
  fi
}

# Wait for a monitor to be available before performing operations on workspaces
# This fixes hyprland moving ws to monitors it's not bound to due to the
# different wakeup times for displays
wait_for_monitor() {
  local monitor_name="$1"
  local timeout=10
  local count=0

  while [ $count -lt $timeout ]; do
    if hyprctl monitors -j | jq -r '.[].name' | grep -q "^$monitor_name$"; then
      log "Monitor $monitor_name is ready"
      return 0
    fi
    sleep 0.5
    ((count++))
  done

  log "WARNING: Monitor $monitor_name not ready after ${timeout}s"
  return 1
}

_get_current_mode() {
  if [ -L "$CURRENT_CONFIG" ]; then
    local target
    target=$(readlink "$CURRENT_CONFIG")

    local basename
    basename=$(basename "$target")

    # Remove the .conf suffix to get the mode name
    if [[ "$basename" == *.conf ]]; then
      echo "${basename%.conf}"
    else
      echo "unknown"
    fi
  else
    echo "none"
  fi
}

# spread workspaces across multiple monitors
spread_workspaces() {

  wait_for_monitor "$LEFT_DISPLAY"
  wait_for_monitor "$CENTER_DISPLAY"
  wait_for_monitor "$RIGHT_DISPLAY"

  # arrange workspaces two my desk screen layout. Force hyprland to
  # respect my monitor ws assignments by placing them manually.
  for i in {1..10}; do
    move_workspace_if_exists "$i" "$CENTER_DISPLAY"
  done
  for i in {11..14}; do
    move_workspace_if_exists "$i" "$LEFT_DISPLAY"
  done
  for i in {15..18}; do
    move_workspace_if_exists "$i" "$CENTER_DISPLAY"
  done
  for i in {19..22}; do
    move_workspace_if_exists "$i" "$RIGHT_DISPLAY"
  done
}

# Collects workspaces to a single target monitor $1
collect_workspaces() {
  local monitor="$1"
  wait_for_monitor "$1"
  workspaces=$(hyprctl workspaces -j | jq -r '.[].id')
  for ws in $workspaces; do
    hyprctl dispatch moveworkspacetomonitor "$ws" "$monitor"
  done
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
  hyprctl reload
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
set_primary_monitor
hyprctl reload config-only

# vim: set ts=2 sw=2 tw=0 fdm=marker et :
