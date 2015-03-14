#!/bin/bash

# display's desired sink
sink='alsa_output.pci-0000_01_00.1.hdmi-surround-extra1'

# Change monitor focus
xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DVI-I-1 --off --output DVI-I-0 --off --output DP-1 --off --output DP-0 --off

# change the default sink to match current monitor setup
pacmd "set-default-sink $sink"

# move all inputs to the new sink
for app in $(pacmd list-sink-inputs | sed -n -e 's/index:[[:space:]]\([[:digit:]]\)/\1/p');
do
  pacmd "move-sink-input $app $sink"
done
