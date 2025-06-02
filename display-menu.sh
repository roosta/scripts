#!/usr/bin/env bash
# Define config and create menu with rofi-meni.sh, see that files header for
# details.
export ROFI_MENU_CONFIG="${XDG_CONFIG_HOME}/rofi-menu/display.yml"
exec "${HOME}/scripts/rofi-menu.sh" "$@"
