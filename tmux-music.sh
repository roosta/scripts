#!/bin/bash
# Automate setting up mpd in a detached tmux session
if ! tmux has-session -t mpd 2>/dev/null; then
  tmux new-session -s mpd -n mopidy -d
  tmux send-keys -t mpd 'mopidy' C-m
fi
