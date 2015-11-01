#!/bin/bash
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Description:
# ---------------
# partially automate changing of screen layout and corresponding audio sink.
# I made this to easily switch screen layouts between my tv -which has a seperate audio setup-
# and my desk. As it largly differs from person to person what their setup looks like this isn't a super
# versatile script but it gets updated now and again in an effort to improve and make it less specialized.
# Author:
# ---------------
# Daniel Berg <mail@roosta.sh>
# Updated 2015-09-02
# sources:
# Arch wiki on xrandr and pulse audio
# http://www.freedesktop.org/wiki/Software/PulseAudio/FAQ/#index40h3

# TODO: Good grief, refactor this!!

# define displays
television=HDMI-0
primary_display=DVI-I-1
secondary_display=DVI-D-0

# define sinks
sink_desk=alsa_output.pci-0000_00_1b.0.analog-stereo
sink_tv=alsa_output.pci-0000_01_00.1.hdmi-surround-extra1

desk_metamode="DVI-I-1: nvidia-auto-select +1920+0, DVI-D-0: nvidia-auto-select +0+0 { ForceFullCompositionPipeline = on }"
couch_metamode="HDMI-0: nvidia-auto-select +0+0 { ForceFullCompositionPipeline = on }"
all_metamode="DVI-I-1: nvidia-auto-select +1920+0, DVI-D-0: nvidia-auto-select +0+0, HDMI-0: nvidia-auto-select +3840+0 { ForceFullCompositionPipeline = on }"


switch_display () {
  (( $# == 1 )) || usage
  case "$1" in
    "desk")
      nvidia-settings --assign CurrentMetaMode="$desk_metamode"
      switch_sink $sink_desk
      notify "desk" $sink_desk
      leave 0
      ;;
    "tv")
      if (xrandr | grep "$television disconnected"); then
        printf "Display %s is not connected\n" $television
        leave 1
      else
        nvidia-settings --assign CurrentMetaMode="$couch_metamode"
        switch_sink $sink_tv
        notify "TV" $sink_tv
        leave 0
      fi
      ;;
    "all")
      nvidia-settings --assign CurrentMetaMode="$all_metamode"
      switch_sink $sink_desk
      notify "All of them" $sink_desk
      leave 0
      ;;
    *)
      printf "invalid argument: %s\n" $1 >&2
      usage
      leave 1
  esac
}

leave() {
  unset television
  unset primary_display
  unset secondary_display
  unset sink_tv
  unset sink_desk
  unset desk_metamode
  unset couch_metamode
  unset all_metamode
  exit $1
}

usage() {
  cat << EOF

    Im a placeholder!

EOF
}

# set new default sink and move all streams.
# trimmed down version of paswitch found here:
# http://www.freedesktop.org/wiki/Software/PulseAudio/FAQ/#index40h3
switch_sink() {

  # switch default sound card to next
  pacmd "set-default-sink $1"

  # $inputs: A list of currently playing inputs
  inputs=$(pacmd list-sink-inputs | awk '$1 == "index:" {print $2}')
  for INPUT in $inputs; do # Move all current inputs to the new default sound card
    pacmd move-sink-input $INPUT $1
  done
}

notify () {
  notify-send "Active screen layout set to $1 \nDefault sound-card changed to $2"
}

switch_display "${@}"


#xrandr --output $primary_display --auto --pos 0x0 --primary \
  #--output $secondary_display --auto --left-of $primary_display \
  #--output $television --auto --right-of $primary_display

#xrandr --output $primary_display --primary --auto --pos 0x0 \
  #--output $secondary_display --auto --left-of $primary_display \
  #--output $television --off

#xrandr --output $television --primary --auto --pos 0x0 \
  #--output $primary_display --off \
  #--output $secondary_display --off

