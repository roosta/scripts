#!/bin/bash
# Used in window manager to instead of starting a new session on term
# shortcut it attach to an existing session and split the window.
# If none exist create a new one. This is a modified version of this:
# https://wiki.archlinux.org/index.php/Tmux#Start_tmux_in_urxvt
urxvtc -e bash -c "tmux -q has-session && exec tmux split-window -h \;
                   attach-session -d || exec tmux new-session -n$USER -s$USER@$HOSTNAME"

