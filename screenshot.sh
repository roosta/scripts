# Capture screenshot of wayland region selected by slurp, anotate with swappy
# Requires grim, slurp, and swappy/satty
grim -g "$(slurp)" - | satty -f -
