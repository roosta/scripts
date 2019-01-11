#!/bin/bash

# Strict mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# This script requires
#
# - recordmydesktop
# - ffmpeg
# - (gifsicle)
# - (imagemagick)
#
# Mathias Bjerke <mathbje@gmail.com>, Daniel Berg <mail@roosta.sh>

RAW_FILE=/tmp/out.ogv
GIF_FILE=/tmp/out.gif
OPTIMIZED_GIF_FILE=/tmp/optimized.gif

[ -e $RAW_FILE ] && rm $RAW_FILE
[ -e $GIF_FILE ] && rm $GIF_FILE

echo "Select window to record..."
echo ""

# https://askubuntu.com/questions/153451/how-can-i-get-the-value-of-window-id
ARG=$(xwininfo -display :0 | grep 'id: 0x' | grep -Eo '0x[a-z0-9]+') || exit

echo "Start recording in"
for i in 3 2 1
do
	echo "$i..."
	sleep 1;
done

recordmydesktop --windowid "$ARG" --no-sound -o "$RAW_FILE"

# I have to stop the recording which cause the last few frames to be not part of
# the video Use ffprobe to get duration of RAW_FILE, it returns a floating point
# number. Trim away everything after decimal point (math/floor)
DURATION=$(ffprobe -v 0 -show_entries format=duration -of compact=p=0:nk=1 $RAW_FILE|cut -d'.' -f1)

# Substract one second from DURATION
TRIMMED_DURATION=$((DURATION-1))

# Use ffmpeg to convert to GIF. Filter-complex is there to generatate a palette from from the source video
# ffmpeg's color handling isn't great for GIF unless this is used. See link below for details
# https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
ffmpeg -t $TRIMMED_DURATION -i $RAW_FILE -filter_complex "[0:v] split [a][b];[a] palettegen [p];[b][p] paletteuse" $GIF_FILE

# Imagemagick (optimization)
# convert $GIF_FILE -fuzz 5% -layers Optimize $OPTIMIZED_GIF_FILE

# Gifsicle (optimization)
gifsicle -O2 $GIF_FILE -o $OPTIMIZED_GIF_FILE

# Review gif
firefox-developer-edition $OPTIMIZED_GIF_FILE

# I needed to set a higher FPS once when I was capturing fast action. Keep for posterity.
# ffmpeg -t $TRIMMED_DURATION -i $RAW_FILE -filter_complex "[0:v] fps=30,split [a][b];[a] palettegen [p];[b][p] paletteuse" $GIF_FILE
# recordmydesktop --no-cursor --fps 30 --windowid "$ARG" --no-sound -o "$RAW_FILE"
