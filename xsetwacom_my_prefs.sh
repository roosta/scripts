#!/bin/bash
#
# CONFIGURATION

# Set this to your (stylus) device. Find it by running:
# xsetwacom --list devices
STYLUS='Wacom Intuos4 6x9 Pen stylus'
ERASER='Wacom Intuos4 6x9 Pen eraser'
CURSOR='Wacom Intuos4 6x9 Pen cursor'

# These numbers are specific for each device. Get them by running:
# xsetwacom --set "Your device name here" ResetArea
# xsetwacom --get "Your device name here" Area
AREAX=44704
AREAY=27940
WIDTH=1920
HEIGHT=1080
SCREEN=3840x2160+1920+0

# END OF CONFIGURATION


# New values respecint aspect ratio:
RATIOAREAY=$(( AREAX * HEIGHT / WIDTH ))
RATIOAREAX=$(( AREAY * WIDTH / HEIGHT ))

if [ "$AREAY" -gt "$RATIOAREAY" ]; then
	NEWAREAX="$AREAX"
	NEWAREAY="$RATIOAREAY"
else
	NEWAREAX="$RATIOAREAX"
	NEWAREAY="$AREAY"
fi

xsetwacom --set "$STYLUS" Area 0 0 "$NEWAREAX" "$NEWAREAY"
xsetwacom --set "$STYLUS" MapToOutput "$SCREEN"

xsetwacom --set "$ERASER" Area 0 0 "$NEWAREAX" "$NEWAREAY"
xsetwacom --set "$ERASER" MapToOutput "$SCREEN"

xsetwacom --set "$CURSOR" Area 0 0 "$NEWAREAX" "$NEWAREAY"
xsetwacom --set "$CURSOR" MapToOutput "$SCREEN"

# $ xsetwacom --list devices
# Wacom Graphire4 6x8 stylus      	id: 9	type: STYLUS
# Wacom Graphire4 6x8 eraser      	id: 10	type: ERASER
# Wacom Graphire4 6x8 cursor      	id: 11	type: CURSOR
# Wacom Graphire4 6x8 pad         	id: 12	type: PAD

# Button mappings only apply to the "pad" device.
# The wheel on Graphire4 acts as mouse buttons 4 and 5 (as a mouse wheel)
# The buttons on Graphire4 act as mouse buttons 8 and 9

# Default Area: 0 0 16704 12064
# ResetArea
#
# Other potentially useful parameters:
# * Mode: absolute or relative
# * Rotate: none, cw, ccw, half
# * MapToOutput: "next" (but is buggy), "desktop", or a name from xrandr
