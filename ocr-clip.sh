#!/bin/bash
# Author: Mathias Bjerke <mathbje@gmail.com>
# Dependencies: tesseract-ocr imagemagick gnome-screenshot xclip
# ====================================
# Select some text on screen, and attempt to OCR it.
# Takes language as param, ie "./ocr-clip.sh eng"

# strict mode
set -euo pipefail

SCR="/tmp/screenshot-ocr-clip"

gnome-screenshot -a -f $SCR.png

mogrify -modulate 100,0 -resize 400% $SCR.png

tesseract $SCR.png $SCR -l "$1"

xclip -selection clipboard < $SCR.txt

echo "------------"
cat $SCR.txt
echo "------------"

exit
