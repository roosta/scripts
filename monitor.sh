# System monitor
# Start btop in a kitty window
# Requires: kitty & btop
kitty btop

# Start alacritty with custom font size and btop as a command. Start it on
# workspace 15, and go back to the previously active workspace.
# Requires: sway, kitty, and btop.
# swaymsg "workspace number 15; exec kitty -o 'font_size=16' btop; workspace back_and_forth"
