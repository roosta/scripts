# Starts a colorpicker and saves result to clipboard
# Requires wl-clipboard. Added sleep here because otherwise rofi will be open
# when hyprpicker "freeze" the screen
sleep .2s && hyprpicker -a "$@"
