#!/bin/bash

# method takes argument defining which screens and sinks to enable/diable
switch_display () {
  case "$1" in
    "desk")
      sink='alsa_output.pci-0000_00_1b.0.analog-stereo'
      xrandr --output DVI-D-0 --off --output HDMI-0 --off --output DVI-I-1 --mode 1920x1080 --pos 0x0 --rotate normal --output DVI-I-0 --off --output DP-1 --off --output DP-0 --off
      pacmd set-default-sink "$sink"
      ;;
    "tv")
      sink='alsa_output.pci-0000_01_00.1.hdmi-surround-extra1'
      xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DVI-I-1 --off --output DVI-I-0 --off --output DP-1 --off --output DP-0 --off
      pacmd set-default-sink "$sink"
      ;;
    "both")
      sink='alsa_output.pci-0000_00_1b.0.analog-stereo'
      xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 1920x0 --rotate normal --output DVI-I-1 --mode 1920x1080 --pos 0x0 --rotate normal --output DVI-I-0 --off --output DP-1 --off --output DP-0 --off
      pacmd set-default-sink "$sink"
      ;;
    "?")
      echo "Unknown option $1"
      ;;
    ":")
      echo "No argument value for option switch display function"
      ;;
      *)
      echo "Unknown error while processing options"
    ;;
  esac

  # move all inputs to the new sink
  for app in $(pacmd list-sink-inputs | sed -n -e 's/index:[[:space:]]\([[:digit:]]\)/\1/p');
  do
    pacmd "move-sink-input $app $sink"
  done
}

getopts "dtb" optname
case "$optname" in
  "d")
  echo "Changing display to desk..."
  switch_display "desk"
  ;;
  "t")
  echo "Changing display to tv..."
  switch_display "tv"
  ;;
  "b")
  echo "extending to both displays... "
  switch_display "both"
  ;;
  "?")
  echo "Unknown option $OPTARG"
  ;;
  ":")
  echo "No argument value for option $OPTARG"
  ;;
  *)
  echo "Unknown error while processing options"
  ;;
esac
