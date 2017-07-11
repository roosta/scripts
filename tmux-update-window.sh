#!/bin/bash
if tmux has-session -t dev 2>/dev/null; then
  tmux new-window -a -n update -d  
  tmux setw -t update monitor-silence 30 
fi
