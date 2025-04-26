#!/bin/bash

# Parse command line arguments
DEBUG_MODE=0
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -d|--debug) DEBUG_MODE=1 ;;
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
  shift
done

CONFIG_FILES=(
  "$HOME/.config/waybar/config.jsonc"
  "$HOME/.config/waybar/modules.jsonc"
  "$HOME/.config/waybar/style.css"
)

# Create the command based on debug mode
if [ $DEBUG_MODE -eq 1 ]; then
  printf '%s\n' "${CONFIG_FILES[@]}" | entr -r env GTK_DEBUG=interactive waybar
else
  printf '%s\n' "${CONFIG_FILES[@]}" | entr -r waybar
fi
