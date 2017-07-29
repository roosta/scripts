#!/bin/bash
if tmux has-session -t dev 2>/dev/null; then
  tmux new-window -a -n update
  tmux setw -t update monitor-silence 300 
  tmux send-keys -t dev 'pacaur -Syu' C-m
fi
