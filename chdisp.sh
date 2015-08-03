#!/bin/bash

# method takes argument defining which screens and sinks to enable/diable
switch_display () {
  case "$1" in
    "desk")
      sink='1'
      xrandr --output DVI-D-0 --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-0 --off --output DVI-I-1 --mode 1920x1080 --pos 1920x0 --rotate normal --output DVI-I-0 --off --output DP-1 --off --output DP-0 --off 
      switch_sink $sink
      ;;
    "tv")
      sink='0'
      xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DVI-I-1 --off --output DVI-I-0 --off --output DP-1 --off --output DP-0 --off
      switch_sink $sink
      ;;
    "all")
      sink='1'
      xrandr --output DVI-D-0 --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-0 --mode 1920x1080 --pos 3840x0 --rotate normal --output DVI-I-1 --mode 1920x1080 --pos 1920x0 --rotate normal --output DVI-I-0 --off --output DP-1 --off --output DP-0 --off
      switch_sink $sink
      ;;
  esac

  # move all inputs to the new sink
  for app in $(pacmd list-sink-inputs | sed -n -e 's/index:[[:space:]]\([[:digit:]]\)/\1/p');
  do
    pacmd "move-sink-input $app $sink"
  done
}

switch_sink () {

  # switch default sound card to next
  pacmd "set-default-sink $1" 

  # $inputs: A list of currently playing inputs
  inputs=$(pacmd list-sink-inputs | awk '$1 == "index:" {print $2}')
  for INPUT in $inputs; do # Move all current inputs to the new default sound card
    pacmd move-sink-input $INPUT $1
  done
  # $nextscdec: The device.description of the new default sound card
  # NOTE: This is the most likely thing to break in future, the awk lines may need playing around with
  nextscdesc=$(pacmd list-sinks | awk '$1 == "device.description" {print substr($0,5+length($1 $2))}' \
                           | sed 's|"||g' | awk -F"," 'NR==v1{print$0}' v1=$((nextind+1)))
  notify-send "Default sound-card changed to $nextscdesc"
  exit
}

getopts "dta" optname
case "$optname" in
  "d")
    notify-send "Changing display to desk..."
    switch_display "desk"
  ;;
  "t")
    notify-send "Changing display to tv..."
    switch_display "tv"
  ;;
  "a")
    notify-send "extending to both displays... "
    switch_display "all"
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
