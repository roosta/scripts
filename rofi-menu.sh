#!/usr/bin/env bash
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
# rofi-menu.sh
# ================
# Script to create rofi menus based on a provided config file
# (ROFI_MENU_CONFIG)
#
# Resources:
# - https://github.com/davatorium/rofi/wiki/Script-Launcher
# - https://github.com/davatorium/rofi/blob/next/doc/rofi-script.5.markdown
# 
# Config Format: 
#   script_name|description|icon
#
# Usage:
# To create a menu create a script like this
#
# ```sh
# export ROFI_MENU_CONFIG="${XDG_CONFIG_HOME}/rofi-menu/config.conf"
# exec "${HOME}/scripts/rofi-menu.sh" "$@"
# ```
#
# Then in rofi you'add your new script to a mode
# ```rasi
# modes: "run,mymode:~/scripts/script.sh";
# ```

readonly SCRIPTS_DIR="${HOME}/scripts"
# readonly CONFIG_DIR="${XDG_CONFIG_HOME}/rofi-menu"

# Arrays to store menu data
declare -a SCRIPT_NAMES
declare -a DESCRIPTIONS  
declare -a ICONS

# Load menu items from config file
load_config() {
  local config_file="$1"

  if [ ! -f "$config_file" ]; then
    echo "Error: Config file '$config_file' not found" >&2
    exit 1
  fi

  local line_count=0
  while IFS='|' read -r script_name description icon; do
    # Skip empty lines and comments
    [[ -z "$script_name" || "$script_name" =~ ^[[:space:]]*# ]] && continue

    SCRIPT_NAMES+=("$script_name")
    DESCRIPTIONS+=("$description")
    ICONS+=("$icon")
    ((line_count++))
  done < "$config_file"

  if [ $line_count -eq 0 ]; then
    echo "Error: No menu items found in config file" >&2
    exit 1
  fi
}

# Determine config file
if [ -n "$ROFI_MENU_CONFIG" ]; then
  config_file="$ROFI_MENU_CONFIG"
else
  echo "Error: no ROFI_MENU_CONFIG file found, exiting..." >&2
  exit 1
fi

# Extract prompt name from config filename
prompt_name=$(basename "$config_file" .conf)

# Load the configuration
load_config "$config_file"

# Format menu item for rofi display
# Separated by NULL character (\0)
# 
format_menu_item() {
  local description="$1"
  local icon="$2"
  echo -en "${description}\0icon\x1f${icon}"
}

# Extract base text from rofi selection
get_selection_text() {
 echo "${1//x0icon\x1f.*/}"
}

# Generic handler function
run_script() {
  local script_name="$1"
  local script_path="${SCRIPTS_DIR}/${script_name}.sh"

  if [ -x "$script_path" ]; then
    # this ensures rofi closes on script execution
    setsid "$script_path" > /dev/null 2>&1 &
  else
    echo "Error: ${script_name} script not found or not executable" >&2
    exit 1
  fi
}
# Handle input from rofi
if [ $# -gt 0 ]; then
  selection=$(get_selection_text "$1")

  # Find matching description and run corresponding script
  for i in "${!DESCRIPTIONS[@]}"; do
    if [ "${DESCRIPTIONS[$i]}" = "$selection" ]; then
      run_script "${SCRIPT_NAMES[$i]}"
      exit 0
    fi
  done
fi

# Change prompt to config name
echo -en "\0prompt\x1f${prompt_name}\n"

# Print menu items
for i in "${!DESCRIPTIONS[@]}"; do
  format_menu_item "${DESCRIPTIONS[$i]}" "${ICONS[$i]}"
  echo
done
