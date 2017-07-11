#!/bin/bash
# source: https://unix.stackexchange.com/questions/80473/how-do-i-run-a-shell-command-from-tmux-conf/80529#80529
if ! tmux has-session -t dev 2>/dev/null; then
  tmux new-session -s dev -n main -d
  tmux split-window -h -d -t main
  tmux new-window -a -n serve -d  
  tmux new-window -a -n update -d  
  tmux setw -t update monitor-silence 30 
  # tmux select-window -t 0:main

  # tmux send-keys -t development 'cd /var/www/htdocs/' C-m
  # tmux send-keys -t development 'vim' C-m
  # tmux send-keys -t development:0.1 'cd /var/www/htdocs/' C-m
  # tmux new-window -n console -t development
  # tmux send-keys -t development:1 'cd /var/www/htdocs/' C-m
  # tmux select-window -t development:0
fi
tmux attach -t dev
