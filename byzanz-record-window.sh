#!/bin/bash

# https://gist.github.com/seyfer/8b25289a66c168eb7f2a
# http://askubuntu.com/questions/107726/how-to-create-animated-gif-images-of-a-screencast#answer-201018

# 1. Run byzanz-record-window 30 -c output.gif
# 2. Go to the window (alt-tab) you want to capture. Click on it.
# 3. Wait 10 seconds (hard-coded in $DELAY), in which you prepare for recording.
# 4. After the beep (defined in the beep function), byzanz will start.
# 5. After 30 seconds (that's the meaning of 30 in step 1), byzanz ends. A beep will be broadcast again.

# Delay before starting
DELAY=3
GIF_FILE=/tmp/out.gif
OPTIMIZED_GIF_FILE=/tmp/optimized.gif

[ -e $GIF_FILE ] && rm $GIF_FILE

echo "Select window to record..."
echo ""

XWININFO=$(xwininfo)
read -r X < <(awk -F: '/Absolute upper-left X/{print $2}' <<< "$XWININFO")
read -r Y < <(awk -F: '/Absolute upper-left Y/{print $2}' <<< "$XWININFO")
read -r W < <(awk -F: '/Width/{print $2}' <<< "$XWININFO")
read -r H < <(awk -F: '/Height/{print $2}' <<< "$XWININFO")

echo Delaying $DELAY seconds. After that, byzanz will start
for (( i=DELAY; i>0; --i )) ; do
    echo "$i"
    sleep 1
done

# Record
byzanz-record --verbose --duration=60 --delay=0 --x="$X" --y="$Y" --width="$W" --height="$H" "$GIF_FILE"

# Gifsicle (optimization)
gifsicle -O2 $GIF_FILE -o $OPTIMIZED_GIF_FILE

# Review gif
firefox $OPTIMIZED_GIF_FILE

