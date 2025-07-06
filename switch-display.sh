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

# switch-display.sh
# =================
# Hyprland display switcher using dynamic monitor configs, toggle between
# monitor layouts.
#
# Usage: ./switch-display.sh <config> [options]
#
# Configurations:
#   desk|mirror|tv|all    Switch to specified display configuration
#   toggle <conf1> <conf2> Toggle between two configurations
#
# Examples:
#   ./switch-display.sh desk              # Switch to desk configuration
#   ./switch-display.sh toggle desk tv    # Toggle between desk and tv configurations
#
# Note: Make sure to create config files in $HOME/.config/hypr/monitors matching argument name, e.g., desk.conf

CONFIG_DIR="$HOME/.config/hypr/monitors"
CURRENT_CONFIG="$CONFIG_DIR/current.conf"
LOG_FILE="$CONFIG_DIR/switch-display.log"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a "$LOG_FILE"
}

get_primary_monitor() {
  if [ -f "$CURRENT_CONFIG" ]; then
    grep "\$primary_monitor =" "$CURRENT_CONFIG" | sed 's/.*= //'
  else
    echo ""
  fi
}

reload_waybar() {
  killall -SIGUSR2 waybar
  # systemctl --user restart waybar
}

# Get current mode by reading the symlink
get_current_mode() {
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

switch_config() {
  local config
  config="$CONFIG_DIR/$1.conf"
  if [ ! -f "$config" ]; then
    log "ERROR: $config not found"
    return 1
  fi
  ln -sf "$config" "$CURRENT_CONFIG" || {
    log "ERROR: Failed to create $config symlink"; return 1; 
  }
  hyprctl reload
}

# TODO: error on toggle without extra args
case "$1" in
  "desk"|"tv"|"mirror"|"all")
    switch_config "$1"
    ;;
  "toggle")
    current_mode=$(get_current_mode)
    if [ "$current_mode" = "$2" ]; then
      switch_config "$3"
    else
      switch_config "$2"
    fi
    ;;
  *)
    echo "Usage: $0 <config> [options]"
    echo ""
    echo "Configurations:"
    echo "  desk|mirror|tv|all    Switch to specified display configuration"
    echo "  toggle <conf1> <conf2> Toggle between two configurations"
    echo ""
    echo "Examples:"
    echo "  $0 desk              # Switch to desk configuration"
    echo "  $0 toggle desk tv    # Toggle between desk and tv configurations"
    echo ""
    echo "Note: Make sure to create config files in $CONFIG_DIR matching argument name, e.g., desk.conf"
    exit 1
    ;;
esac

# vim: set ts=2 sw=2 tw=0 fdm=marker et :
