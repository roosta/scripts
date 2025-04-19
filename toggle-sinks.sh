#!/bin/bash

# Toggles between two sinks using pactl, takes two arguments, which are the
# sinks you wish to toggle between. Using on pipewire, pipewire-pulse. To list
# sinks use `pactl list sinks short`
#
# Usage:
# ./toggle-sinks.sh 'alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.stereo-game' 'alsa_output.pci-0000_00_1b.0.analog-stereo'

# Get the currently active sink
CURRENT_SINK=$(pactl get-default-sink)

# Toggle between sinks
if [ "$CURRENT_SINK" = "$1" ]; then
    pactl set-default-sink "$2"
else
    pactl set-default-sink "$1"
fi

# Move all currently playing streams to the new sink
SINK=$(pactl get-default-sink)
pactl list short sink-inputs | while read -r stream; do
    stream_id=$(cut -f1 <<< "$stream")
    pactl move-sink-input "$stream_id" "$SINK"
done
