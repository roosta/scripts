#!/bin/bash
pac=$(checkupdates | wc -l)
aur=$(cower -u | wc -l)

check=$((pac + aur))
if [[ "$check" != "0" ]]; then
  echo "%{F#FBB829}$pac/$aur%{F-}"
else
  echo "$pac/$aur"
fi

# spark $pac $aur 
