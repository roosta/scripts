#!/bin/bash

# This script requires
#
# - https://github.com/lolilolicon/xrectsel
# - recordmydesktop
# - mplayer
# - imagemagick
# - gifsicle
#
# Author: Mathias Bjerke <mathbje@gmail.com>

RAW_FILE=/tmp/out.ogv
SCREENSHOT_DIR=/tmp/screenshots
GIF_FILE=/tmp/out.gif
OPTIMIZED_GIF_FILE=/tmp/optimized.gif

rm $RAW_FILE
rm $SCREENSHOT_DIR/*
rm $GIF_FILE

echo "Select area to record..."
echo ""

ARG=$(xrectsel "-x %x -y %y --width=%w --height=%h") || exit -1

echo "Start recording in"
for i in 3 2 1
do
	echo "$i..."
	sleep 1;
done

recordmydesktop ${ARG} --no-sound -o $RAW_FILE

mkdir -p $SCREENSHOT_DIR
mplayer -ao null $RAW_FILE -vo jpeg:outdir=$SCREENSHOT_DIR

convert $SCREENSHOT_DIR/* $GIF_FILE

convert $GIF_FILE -fuzz 5% -layers Optimize $OPTIMIZED_GIF_FILE
#gifsicle -O2 $GIF_FILE -o $OPTIMIZED_GIF_FILE

firefox-developer $OPTIMIZED_GIF_FILE
