#!/bin/bash

# Switches between audio sink (output) presets using pactl
#
# Usage: ./switch-audio.sh [headphones|speakers|tv|toggle]
#   headphones: Activate headphones
#   speakers: Activate speakers
#   tv: Activate tv speakers
#   toggle: Toggle between speakers and headphones

# Author: Daniel Berg <mail@roosta.sh>
 
# `pactl list sinks short`
HEADPHONES="alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.stereo-game"
SPEAKERS="alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink"
TV="alsa_output.pci-0000_03_00.1.hdmi-stereo-extra3"

# get the currently active sink
CURRENT_SINK=$(pactl get-default-sink)

move_sinks() {
  SINK=$(pactl get-default-sink)
  pactl list short sink-inputs | while read -r stream; do
    stream_id=$(cut -f1 <<< "$stream")
    pactl move-sink-input "$stream_id" "$SINK"
  done
}

# Toggle function I use for a button in waybar
toggle_sinks() {
  if [ "$CURRENT_SINK" = "$SPEAKERS" ]; then
    pactl set-default-sink "$HEADPHONES"
  else
    pactl set-default-sink "$SPEAKERS"
  fi
}

activate_headphones() {
  pactl set-default-sink "$HEADPHONES"
}

activate_speakers() {
  pactl set-default-sink "$SPEAKERS"
}

activate_tv() {
  pactl set-default-sink "$TV"
}

# Handle args
case "$1" in
  "headphones")
    activate_headphones
    ;;
  "speakers")
    activate_speakers
    ;;
  "tv")
    activate_tv
    ;;
  "toggle")
    toggle_sinks
    ;;
  *)
    echo "Usage: $0 [headphones|speakers|tv|toggle]"
    echo "  headphones: Activate headphones"
    echo "  speakers: Activate speakers"
    echo "  tv: Activate tv speakers"
    echo "  toggle: Toggle between speakers and headphones"
    exit 1
    ;;
esac

# finally move any playing audio to new sink
move_sinks
