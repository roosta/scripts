#!/bin/bash
# Script used with polybar to print pacman and AUR package updates that are
# available. Requires auracle.
# https://aur.archlinux.org/packages/auracle-git/
# Author: Daniel Berg <mail@roosta.sh>
pac=$(checkupdates | wc -l)
aur=$(auracle sync | wc -l)

check=$((pac + aur))
if [[ "$check" != "0" ]]; then
  echo "%{F#FBB829}$pac/$aur%{F-}"
else
  echo "$pac/$aur"
fi