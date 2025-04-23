#!/usr/bin/env bash

# rofi-menu
# ================
# Custom menu for rofi, a few actions I use on the daily, see its corresponding
# scripts for what program is used, i.e ./screenshot.sh or ./colorpicker.sh

readonly SCRIPTS_DIR="${HOME}/scripts"

# Define menu structure. Icon is defined after the pipe, make sure you have it
# installed via an icon pack or similar
declare -A MENU_ITEMS=(
  ["screenshot"]="Take a screenshot|viewimage"
  ["colorpicker"]="Pick a color|applications-graphics-symbolic"
  ["monitor"]="Start monitor|process-stop-symbolic"
)

# Format menu item for rofi display
format_menu_item() {
  local text="${1%|*}"
  local icon="${1#*|}"
  echo -en "${text}\0icon\x1f${icon}"
}

# Extract base text from rofi selection
get_selection_text() {
 echo "${1//x0icon\x1f.*/}"
}

# Generic handler function
run_script() {
  local script_name="$1"
  local script_path="${SCRIPTS_DIR}/${script_name}.sh"

  # Using full path for security
  if [ -x "$script_path" ]; then
    # Close rofi on script execution, by detaching script process
    setsid "$script_path" > /dev/null 2>&1 &
  else
    echo "Error: ${script_name} script not found or not executable" >&2
    exit 1
  fi
}

# Handle input from rofi
if [ $# -gt 0 ]; then
  selection=$(get_selection_text "$1")
  # Find the matching action by comparing display text
  for key in "${!MENU_ITEMS[@]}"; do
    if [ "${MENU_ITEMS[$key]%|*}" = "$selection" ]; then
      run_script "$key"
      exit 0
    fi
  done
fi

# Change prompt to "Actions menu"
echo -en "\0prompt\x1factions\n"

# Print menu items
for item in "${MENU_ITEMS[@]}"; do
  format_menu_item "$item"
  echo
done
