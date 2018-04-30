#!/bin/bash
if tmux has-session -t main 2>/dev/null; then
  tmux new-window -a -n update
  tmux setw -t update monitor-silence 300 
  tmux send-keys -t main 'yay -Syu' C-m
else 
  echo "Found no session called 'main'"
  exit 1
fi
