#!/bin/bash
# https://github.com/kalq/dotfiles/blob/macbook/scripts/bin/dropdown_terminal.sh
# https://www.reddit.com/r/unixporn/comments/60qw8z/bspwm_bite_my_shiny_metal_ass/

terminal="st"

if [ -z $(xdotool search --classname "dropdown") ]; then
    bspc rule -a $terminal:dropdown state=floating hidden=on border=off sticky=on

    # Use of xtoolwait is recommended instead of the until-loop.
    # One or the other is needed to wait for the terminal to be
    # mapped to a window before continuing the script.
    # xtoolwait, as the name implies, does not work with wayland.
    #xtoolwait "$terminal" -c "$terminal" -n dropdown
    ($terminal -c $terminal -n dropdown &); until [ $(bspc query -N -n .hidden | tail -n1) ]; do :; done

    # find the newest hidden terminal
    wid=$(bspc query -N -n .hidden | tail -n1)

    width=$(bspc query -T -m | grep -oE "[0-9]{0,4}" | sed -n '16 p')
    height=$(bspc query -T -m | grep -oE "[0-9]{0,4}" | sed -n '17 p')

    xdotool windowmove $wid 0 0
    xdotool windowsize $wid $(expr $width) $(expr $height / 3)

    compton-trans -w $wid -o 90

    # Reveal the terminal once all the geometric changes are complete
    bspc node $wid -g hidden=off -f

    bspc rule -r $terminal:dropdown
else
    wid=$(printf "0x%x" $(xdotool search --classname "dropdown"))

    # toggle visibility of dropdown menu
    bspc node $wid -g hidden -f
fi
