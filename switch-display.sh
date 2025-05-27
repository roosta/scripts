#!/bin/bash
# switch-display.sh
# =================
# Hyprland display switcher using dynamic monitor configs, toggle between
# monitor layouts.
# Usage: ./switch-display.sh [desk|mirror|tv|toggle]
#
# Author: Daniel Berg <mail@roosta.sh>

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

# Reload hyprland config to apply changes
log "Reloading hyprland config..."
reload_waybar
hyprctl reload

# vim: set ts=2 sw=2 tw=0 fdm=marker et :
