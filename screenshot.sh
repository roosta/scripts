# Capture screenshot of wayland region selected by slurp, anotate with swappy
# Requires grim, slurp, and swappy
grim -g "$(slurp)" - | swappy -f -
