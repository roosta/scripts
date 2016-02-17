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

# define displays
tv=HDMI-1
primary=DVI-I-1
secondary=VGA-1

# define sinks
sink_desk=alsa_output.pci-0000_00_1b.0.analog-stereo
sink_tv=alsa_output.pci-0000_01_00.1.hdmi-surround-extra1

switch_display () {
  (( $# == 1 )) || usage
  case "$1" in
    "desk")
      xrandr --output ${tv} --off
      xrandr --output ${primary} --primary --mode 1920x1080 --pos 0x0 --rotate normal \
             --output ${secondary} --mode 1920x1080 --left-of ${primary} --rotate normal
      switch_sink $sink_desk
      #notify "desk" $sink_desk
      leave 0
      ;;
    "tv")
      if (xrandr | grep "$tv disconnected"); then
        printf "Display %s is not connected\n" $tv
        leave 1
      else
        xrandr --output ${primary} --off \
               --output ${secondary} --off
        xrandr --output ${tv} --primary --mode 1920x1080 --pos 0x0 --rotate normal
        switch_sink $sink_tv
        #notify "TV" $sink_tv
        leave 0
      fi
      ;;
    "all")
      #xrandr --output ${secondary} --mode 1920x1080 --pos 0x0 --rotate normal \
             #--output ${primary} --primary --mode 1920x1080 --pos 1920x0 --rotate normal \
             #--output ${tv} --primary --mode 1920x1080 --pos 3840x0 --rotate normal
      #switch_sink $sink_tv
      #notify "All of them" $sink_desk
      printf "All three displays layout currently disabled until xrandr crtc issue is resolved" >&2
      leave 1
      ;;
    *)
      printf "invalid argument: %s\n" $1 >&2
      usage
      leave 1
  esac
}

leave() {
  unset tv
  unset primary
  unset secondary
  unset sink_tv
  unset sink_desk
  unset desk_layout
  unset couch_layout
  unset all_layout

  # restart i3 to to setup workspaces for a different layout.
  #sleep 1; i3-msg reload

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


#xrandr --output $primary --auto --pos 0x0 --primary \
  #--output $secondary --auto --left-of $primary \
  #--output $tv --auto --right-of $primary

#xrandr --output $primary --primary --auto --pos 0x0 \
  #--output $secondary --auto --left-of $primary \
  #--output $tv --off

#xrandr --output $tv --primary --auto --pos 0x0 \
  #--output $primary --off \
  #--output $secondary --off

