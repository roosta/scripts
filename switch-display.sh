#!/bin/bash
#
# Copyright Daniel Berg <mail@roosta.sh>
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
# switch-display.sh
# =================
# Hyprland display switcher using dynamic monitor configs, switch between
# monitor layouts.
#
# Usage: ./switch-display.sh <config> [options]
#
# Configurations:
#   desk|mirror|tv|all    Switch to specified display configuration
#
# Examples:
#   ./switch-display.sh desk              # Switch to desk configuration
#
# Note: Make sure to create config files in $HOME/.config/hypr/monitors matching argument name, e.g., desk.conf

# Monitor rules
# -------------
# Enable hdr with this, adjust brightness/saturation for preference. 
# monitor = $center_monitor,preferred,1920x0,2,vrr, 3, bitdepth, 10, cm, hdr, sdrbrightness, 1.2, sdrsaturation, 0.98

CONFIG_DIR="$HOME/.config/hypr/monitors"
CURRENT_CONFIG="$CONFIG_DIR/current.conf"
LOG_FILE="$CONFIG_DIR/switch-display.log"

# Monitors
LEFT_DISPLAY="DP-2"
CENTER_DISPLAY="DP-1"
RIGHT_DISPLAY="HDMI-A-1"
TV_DISPLAY="HDMI-A-2"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a "$LOG_FILE"
}

# Looks for a variable in the config $primary_monitor, return monitor id
_get_primary_monitor() {
  if [ -f "$CURRENT_CONFIG" ]; then
    grep "\$primary_monitor =" "$CURRENT_CONFIG" | sed 's/.*= //'
  else
    echo ""
  fi
}

# check if a workspace exists
workspace_exists() {
  local workspace_id="$1"
  hyprctl workspaces -j | jq -r '.[].id' | grep -q "^$workspace_id$"
}

# move workspace if it exists
move_workspace_if_exists() {
  local workspace_id="$1"
  local monitor="$2"

  if workspace_exists "$workspace_id"; then
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

reload_waybar() {
  # killall -SIGUSR2 waybar
  systemctl --user restart waybar
}

# Get current mode by reading the symlink
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

# Desk layout, wait until all displays are ready before moving workspaces
switch_to_desk() {

  # layout, from left to right
  hyprctl keyword monitor "$LEFT_DISPLAY,preferred,0x0,2" 
  hyprctl keyword monitor "$CENTER_DISPLAY,preferred,1920x0,2,vrr,3"
  hyprctl keyword monitor "$RIGHT_DISPLAY,preferred,3840x0,2"
  hyprctl keyword monitor "$TV_DISPLAY,disable"

  wait_for_monitor "$LEFT_DISPLAY"
  wait_for_monitor "$CENTER_DISPLAY" 
  wait_for_monitor "$RIGHT_DISPLAY"

  # force workspaces to their assigment monitors after all monitors are available
  for i in {1..4}; do
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

switch_to_tv() {
  hyprctl keyword monitor "$LEFT_DISPLAY,disabled" 
  hyprctl keyword monitor "$CENTER_DISPLAY,disabled"
  hyprctl keyword monitor "$RIGHT_DISPLAY,disabled"
  hyprctl keyword monitor "$TV_DISPLAY,preferred,auto,2"

  wait_for_monitor "$TV_DISPLAY"

  workspaces=$(hyprctl workspaces -j | jq -r '.[].id')
  for ws in $workspaces; do
    hyprctl dispatch moveworkspacetomonitor "$ws" $TV_DISPLAY
  done
}

link_config() {
  local config
  case "$1" in 
    "desk"|"mirror"|"all")
      config="$CONFIG_DIR/desk.conf"
      ;;
    *)
      config="$CONFIG_DIR/$1.conf"
      ;;
  esac
  if [ ! -f "$config" ]; then
    log "ERROR: $config not found"
    return 1
  fi
  ln -sf "$config" "$CURRENT_CONFIG" || {
    log "ERROR: Failed to create $config symlink"; return 1; 
  }
}

case "$1" in
  "desk"|"tv"|"mirror"|"all")
    link_config "$1"
    ;;
  *)
    echo "Usage: $0 <config> [options]"
    echo ""
    echo "Configurations:"
    echo "  desk|mirror|tv|all    Switch to specified display configuration"
    echo ""
    echo "Examples:"
    echo "  $0 desk              # Switch to desk configuration"
    echo ""
    echo "Note: Make sure to create config files in $CONFIG_DIR matching argument name, e.g., desk.conf"
    exit 1
    ;;
esac

case "$1" in
  "desk")
    switch_to_desk
    ;;
  "tv")
    switch_to_tv
    ;;
esac

# vim: set ts=2 sw=2 tw=0 fdm=marker et :
