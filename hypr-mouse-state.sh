#!/bin/bash
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
# ### [hypr-mouse-state.sh](./hypr-mouse-state.sh)
#
# Handle the different states `mouse:275` (first side button on my setup)
# I use this for various conflicting things, this handles toggling on and off
# the various modes.
#
# Requirements:
# - https://github.com/hyprwm/Hyprland
#
# Usage:
#
# ```hyprlang
# exec = ~/scripts/hypr-mouse-state.sh sync
# bind = $main_mod SHIFT,mouse:275,exec,~/scripts/hypr-mouse-state.sh menu
# bind = $main_mod ALT,mouse:275,exec,~/scripts/hypr-mouse-state.sh alt
# ```
#
# `sync` checks the state file and sets the mode accordingly
# Calling the script multiple times will toggle the passed mode on and off
# 
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

STATE_FILE="/tmp/hypr-mouse-state"

get_state() {
  if [ -f "$STATE_FILE" ]; then
    cat "$STATE_FILE"
  else
    echo "menu"
  fi
}

disable() {
  hyprctl keyword unbind ",mouse:275"
  echo "disabled" > "$STATE_FILE"
  notify-send --icon media-playback-paused "Mouse Mode Disabled" "Mouse now acts normally"
}

enable_menu() {
  state=$(get_state)
  if [ "$state" = "menu" ]; then
    disable
  else
    hyprctl keyword bind ",mouse:275,global,:media-menu"
    notify-send --icon input-mouse "Media Menu" "Enabled media menu (kando)"
    echo "menu" > "$STATE_FILE"
  fi
}

enable_alt() {
  state=$(get_state)
  if [ "$state" = "alt" ]; then
    disable
  else
    echo "alt" > "$STATE_FILE"
    hyprctl keyword bind ",mouse:275,sendshortcut,,ALT_L"
    notify-send --icon preferences-desktop-keyboard "Alt Mode" "Enabled alt mode"
  fi
}

case "${1:-sync}" in
  menu)
    enable_menu
    ;;
  disable)
    disable
    ;;
  alt)
    enable_alt
    ;;
  sync)
    state=$(get_state)
    case "$state" in
      menu)
        hyprctl keyword bind ",mouse:275,global,:media-menu"
        ;;
      disabled)
        hyprctl keyword unbind ",mouse:275"
        ;;
      alt)
        hyprctl keyword bind ",mouse:275,sendshortcut,,ALT_L"
        ;;
    esac
    ;;
  *)
    echo "Usage: $0 {menu|alt|sync}"
    echo "Tracks state via $STATE_FILE, will toggle on and off mode if script is fired repeatedly"
    exit 1
    ;;
esac
