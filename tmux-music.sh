#!/bin/bash
# Automate setting up mpd in a detached tmux session
if [ -d "$HOME/Private/mopidy" ]; then
    if [ ! $(tmux has-session -t mpd 2>/dev/null) ]; then
        tmux new-session -s mpd -n mopidy -d
        tmux send-keys -t mpd 'mopidy' C-m
    else
        echo "There is already a session called mpd"
    fi
else
    echo "~/Private is not mounted"
    exit 1
fi
