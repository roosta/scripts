# Start alacritty with custom font size and btop as a command. Start it on
# workspace 15, and go back to the previously active workspace.
# Requires: sway, alacritty, and btop.
swaymsg "workspace number 15; exec alacritty -o 'font.size=16' -e btop; workspace back_and_forth"
