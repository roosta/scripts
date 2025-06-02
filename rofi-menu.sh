#!/usr/bin/env bash
#
# Copyright (c) 2025 Daniel Berg <mail@roosta.sh>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# rofi-menu.sh
# ================
# Script to create rofi menus based on a provided YAML config file
# (ROFI_MENU_CONFIG)
#
# Resources:
# - https://github.com/davatorium/rofi/wiki/Script-Launcher
# - https://github.com/davatorium/rofi/blob/next/doc/rofi-script.5.markdown
# 
# Config Format (YAML): 
#   items:
#     - script: ~/path/to/my/script.sh
#       description: Item description
#       icon: icon_name
#       args: ["optional", "arguments"]
#
# Usage:
# To create a menu create a script like this
#
# ```sh
# export ROFI_MENU_CONFIG="${XDG_CONFIG_HOME}/rofi-menu/config.yaml"
# exec "${HOME}/scripts/rofi-menu.sh" "$@"
# ```
#
# Then in rofi you'add your new script to a mode
# ```rasi
# modes: "run,mymode:~/scripts/script.sh";
# ```

# Arrays to store menu data
declare -a SCRIPTS
declare -a DESCRIPTIONS  
declare -a ICONS
declare -a SCRIPT_ARGS

# Check if yq is available
check_dependencies() {
  if ! command -v yq &> /dev/null; then
    echo "Error: 'yq' is required but not installed. Please install yq to parse YAML configs." >&2
    exit 1
  fi
}

# Check dependencies first
check_dependencies

# Determine config file
if [ -n "$ROFI_MENU_CONFIG" ]; then
  config_file="$ROFI_MENU_CONFIG"
else
  echo "Error: no ROFI_MENU_CONFIG file found, exiting..." >&2
  exit 1
fi

item_count=$(yq '.items | length' "$config_file" 2>/dev/null)

if [ -z "$item_count" ] || [ "$item_count" = 0 ]; then
  echo "Error: No menu items found in config file or invalid YAML format" >&2
  exit 1
fi

# Extract prompt name from config filename (handle .yaml and .yml extensions)
prompt_name=$(basename "$config_file" .yaml)
prompt_name=$(basename "$prompt_name" .yml)

# Format menu item for rofi display
# Separated by NULL character (\0)
format_menu_item() {
  local description="$1"
  local icon="$2"
  echo -en "${description}\0icon\x1f${icon}"
}

# Extract base text from rofi selection
get_selection_text() {
 echo "${1//x0icon\x1f.*/}"
}

# Run script associated with config, optionally parsing arguments
run_script() {
  local script="$1"
  local args="$2"

  if [ -f "$script" ]; then
    if [ -n "$args" ]; then
      setsid bash -c "$script $args" > /dev/null 2>&1 &
    else
      setsid "$script" > /dev/null 2>&1 &
    fi
  else
    echo "Error: ${script} not found or not executable" >&2
    exit 1
  fi
}

# Change prompt to config name
echo -en "\0prompt\x1f${prompt_name}\n"

# Parse config file with yq
while IFS=$'\t' read -r script description icon args; do

  # Handle literal variables in script path
  # tilde (~) and $HOME are parsed currently
  script="${script/#\~/$HOME}"
  script="${script/\$HOME/$HOME}"

  if [ -z "$script" ] || [ -z "$description" ] || [ -z "$icon" ]; then
    echo "Warning: Skipping item due to missing required fields (script, description, icon)" >&2
    continue
  fi
  SCRIPTS+=("$script")
  DESCRIPTIONS+=("$description")
  ICONS+=("$icon")
  SCRIPT_ARGS+=("${args//$'\t'/ }")
done < <(yq -r '.items[] | [.script, .description, .icon, .args[]?] | @tsv' "$config_file")

# exit if scripts array is empty
if [ ${#SCRIPTS[@]} -eq 0 ]; then
  echo "Error: No valid menu items found in config file" >&2
  exit 1
fi

# Handle input from rofi
if [ $# -gt 0 ]; then
  selection=$(get_selection_text "$1")

  # Find matching description and run corresponding script
  for i in "${!DESCRIPTIONS[@]}"; do
    if [ "${DESCRIPTIONS[$i]}" = "$selection" ]; then
      run_script "${SCRIPTS[$i]}" "${SCRIPT_ARGS[$i]}"
      exit 0
    fi
  done
fi

# Print null separated menu items for rofi
for i in "${!DESCRIPTIONS[@]}"; do
  format_menu_item "${DESCRIPTIONS[$i]}" "${ICONS[$i]}"
  echo
done

# vim: set ts=2 sw=2 tw=0 fdm=marker et :
