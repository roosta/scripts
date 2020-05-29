#!/bin/bash
# Dependencies: tesseract-ocr imagemagick gnome-screenshot xclip
# Author: Mathias Bjerke <mathbje@gmail.com>

SCR="/tmp/screenshot-ocr-clip"

gnome-screenshot -a -f $SCR.png

mogrify -modulate 100,0 -resize 400% $SCR.png

tesseract $SCR.png $SCR -l nor
cat $SCR.txt | xclip -selection clipboard

echo "------------"
cat $SCR.txt
echo "------------"

exit
