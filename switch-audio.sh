#!/bin/bash

# Toggles between two sinks using pactl, takes two arguments, which are the
# sinks you wish to toggle between. Using on pipewire, pipewire-pulse. To list
# sinks use `pactl list sinks short`
#
# Usage: ./switch-audio.sh [headphones|speakers|media|toggle]
#   headphones: Activate headphones
#   speakers: Activate speakers
#   media: Activate media speakers
#   toggle: Toggle between speakers and headphones

# Author: Daniel Berg <mail@roosta.sh>
 
# Configure this to match your own sinks
# i.e `pactl list sinks short`
HEADPHONES="alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.stereo-game"
SPEAKERS="alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink"
MEDIA="alsa_output.pci-0000_03_00.1.hdmi-stereo-extra3"

# Get the currently active sink
CURRENT_SINK=$(pactl get-default-sink)

# Moves playing audio to new target sink
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

activate_media() {
  pactl set-default-sink "$MEDIA"
}

# Toggle between sinks

# Parse arguments and execute accordingly
case "$1" in
  "headphones")
    activate_headphones
    ;;
  "speakers")
    activate_speakers
    ;;
  "media")
    activate_media
    ;;
  "toggle")
    toggle_sinks
    ;;
  *)
    echo "Usage: $0 [headphones|speakers|media|toggle]"
    echo "  headphones: Activate headphones"
    echo "  speakers: Activate speakers"
    echo "  media: Activate media speakers"
    echo "  toggle: Toggle between speakers and headphones"
    exit 1
    ;;
esac

# finally move any playing audio to new sink
move_sinks
