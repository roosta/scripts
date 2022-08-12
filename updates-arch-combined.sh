#!/bin/sh
# https://github.com/polybar/polybar-scripts

if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
  updates_arch=0
fi

if ! updates_aur=$(paru -Qum 2> /dev/null | wc -l); then
  updates_aur=0
fi

updates=$(("$updates_arch" + "$updates_aur"))

if [ "$updates" -gt 0 ]; then
  echo %{F#FBB829}$updates_arch/$updates_aur%{F-}
else
  echo "$updates_arch/$updates_aur"
fi
