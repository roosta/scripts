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
# Usage: ./switch-display.sh [desk|mirror|tv|toggle]
# Make sure to create config files:
#   $HOME/.config/hypr/monitors/desk.conf
#   $HOME/.config/hypr/monitors/tv.conf
#   $HOME/.config/hypr/monitors/mirror.conf

CONFIG_DIR="$HOME/.config/hypr/monitors"
CURRENT_CONFIG="$CONFIG_DIR/current.conf"
DESK_CONFIG="$CONFIG_DIR/desk.conf"
TV_CONFIG="$CONFIG_DIR/tv.conf"
MIRROR_CONFIG="$CONFIG_DIR/mirror.conf"
LOG_FILE="$HOME/.config/hypr/monitors/switch-display.log"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a "$LOG_FILE"
}

reload_waybar() {
  killall -SIGUSR2 waybar
  # systemctl --user restart waybar
}

# Get current mode by reading the symlink
get_current_mode() {
  if [ -L "$CURRENT_CONFIG" ]; then
    local target;
    target=$(readlink "$CURRENT_CONFIG")
    case "$target" in
      *desk.conf)
        echo "desk"
        ;;
      *tv.conf)
        echo "tv"
        ;;
      *mirror.conf)
        echo "mirror"
        ;;
      *)
        echo "unknown"
        ;;
    esac
  else
    echo "none"
  fi
}

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

activate_desk() {
  if [ ! -f "$DESK_CONFIG" ]; then
    log "ERROR: Desk config file not found: $DESK_CONFIG"
    return 1
  fi

  # Remove existing symlink/file and create new symlink
  rm -f "$CURRENT_CONFIG"
  ln -sf "$DESK_CONFIG" "$CURRENT_CONFIG" || { log "ERROR: Failed to create desk symlink"; return 1; }
}

activate_tv() {
  if [ ! -f "$TV_CONFIG" ]; then
    log "ERROR: tv config file not found: $TV_CONFIG"
    return 1
  fi

  # Remove existing symlink/file and create new symlink
  rm -f "$CURRENT_CONFIG"
  ln -sf "$TV_CONFIG" "$CURRENT_CONFIG" || { log "ERROR: Failed to create tv symlink"; return 1; }
}

activate_mirror() {
  if [ ! -f "$MIRROR_CONFIG" ]; then
    log "ERROR: mirror config file not found: $TV_CONFIG"
    return 1
  fi

  # Remove existing symlink/file and create new symlink
  rm -f "$CURRENT_CONFIG"
  ln -sf "$MIRROR_CONFIG" "$CURRENT_CONFIG" || { log "ERROR: Failed to create mirror symlink"; return 1; }
}

case "$1" in
  "desk")
    activate_desk
    ;;
  "tv")
    activate_tv
    ;;
  "mirror")
    activate_mirror
    ;;
  "toggle")
    current_mode=$(get_current_mode)
    if [ "$current_mode" = "tv" ]; then
      activate_desk
    else
      activate_tv
    fi
    ;;
  *)
    echo "Usage: $0 [desk|mirror|tv|toggle]"
    echo "Make sure to create config files:"
    echo "  $DESK_CONFIG"
    echo "  $TV_CONFIG"
    echo "  $MIRROR_CONFIG"
    exit 1
    ;;
esac

# Reload hyprland and waybar
# TODO: do binary check for waybar
reload_waybar
hyprctl reload

# vim: set ts=2 sw=2 tw=0 fdm=marker et :
