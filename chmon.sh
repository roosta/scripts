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
# ------------
# partially automate changing of screen layout and corresponding audio sink.
# Made to easily switch screen layouts between my tv -which has a seperate audio setup-
# and my desk. As it differs from setup to setup what their layout is this isn't a very
# versatile script but it gets updated now and again in an effort to improve and make it less specialized.
# Author:
# -------
# Daniel Berg <mail@roosta.sh>
# Updated 2015-09-02
# sources:
# Arch wiki on xrandr and pulse audio
# http://www.freedesktop.org/wiki/Software/PulseAudio/FAQ/#index40h3

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# TODO: Good grief, refactor this!!

# define displays
tv=HDMI-0
output0=DVI-I-1
output1=DVI-D-0

# define sinks
sink_desk=alsa_output.pci-0000_00_1b.0.analog-stereo
sink_tv=alsa_output.pci-0000_01_00.1.hdmi-surround-extra1

# Try ForceFullCompositionPipeline to solve tearing issues.
# ^^ experiencing no issues with most apps although compton is sometimes acting up and needs a restart.
#    Lethal League's performance seems affcted but no other game so far.
# !! use xrandr instead of this is undesierable
desk_layout="DVI-I-1: nvidia-auto-select +1920+0 { ForceFullCompositionPipeline = on }, DVI-D-0: nvidia-auto-select +0+0"
couch_layout="HDMI-0: nvidia-auto-select +0+0 { ForceFullCompositionPipeline = on }"
all_layout="DVI-I-1: nvidia-auto-select +1920+0 { ForceFullCompositionPipeline = on }, DVI-D-0: nvidia-auto-select +0+0, HDMI-0: nvidia-auto-select +3840+0"


switch_display () {
  (( $# == 1 )) || usage
  case "$1" in
    "desk")
      xrandr --output $output0 --primary
      nvidia-settings --assign CurrentMetaMode="$desk_layout"
      switch_sink $sink_desk
      #notify "desk" $sink_desk
      leave 0
      ;;
    "tv")
      if (xrandr | grep "$tv disconnected"); then
        printf "Display %s is not connected\n" $tv
        leave 1
      else
        xrandr --output $tv --primary
        nvidia-settings --assign CurrentMetaMode="$couch_layout"
        switch_sink $sink_tv
        #notify "TV" $sink_tv
        leave 0
      fi
      ;;
    "all")
      nvidia-settings --assign CurrentMetaMode="$all_layout"
      switch_sink $sink_desk
      #notify "All of them" $sink_desk
      leave 0
      ;;
    *)
      printf "invalid argument: %s\n" $1 >&2
      usage
      leave 1
  esac
}

leave() {
  unset tv
  unset output0
  unset output1
  unset sink_tv
  unset sink_desk
  unset desk_layout
  unset couch_layout
  unset all_layout

  # restart i3 to to setup workspaces for a different layout.
  sleep 1; i3-msg restart

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


#xrandr --output $output0 --auto --pos 0x0 --primary \
  #--output $output1 --auto --left-of $output0 \
  #--output $tv --auto --right-of $output0

#xrandr --output $output0 --primary --auto --pos 0x0 \
  #--output $output1 --auto --left-of $output0 \
  #--output $tv --off

#xrandr --output $tv --primary --auto --pos 0x0 \
  #--output $output0 --off \
  #--output $output1 --off

