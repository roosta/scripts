#!/usr/bin/env bash

# rofi-menu
# ================
# Custom menu for rofi, a few actions I use on the daily, see its corresponding
# scripts for what program is used, i.e ./screenshot.sh or ./colorpicker.sh

readonly SCRIPTS_DIR="${HOME}/scripts"
readonly CONFIG_DIR="${XDG_CONFIG_HOME}/rofi-menu"

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

# Show usage information
show_usage() {
  echo "Usage: $0 <config_file> [selection]"
  echo "  config_file: Path to config file with format: script_name|description|icon"
  echo "  name of config file will be the name of the menu."
  exit 1
}

# Determine config file
if [ -n "$ROFI_MENU_CONFIG" ]; then
  config_file="$ROFI_MENU_CONFIG"
else
  config_file="${CONFIG_DIR}/actions.conf"
fi

# Extract prompt name from config filename
prompt_name=$(basename "$config_file" .conf)

# Load the configuration
load_config "$config_file"

# Format menu item for rofi display
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
