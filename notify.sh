#!/bin/bash
if hash notify-send 2>/dev/null; then
  notify-send -i /usr/share/icons/Faenza/apps/48/terminal.png "Tmux" "Bell from shell!"
fi
