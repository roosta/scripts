#!/bin/bash
# source: https://unix.stackexchange.com/questions/80473/how-do-i-run-a-shell-command-from-tmux-conf/80529#80529
# Automate setting up tmux dev session
if ! tmux has-session -t main 2>/dev/null; then
  tmux new-session -s main -n dev -d
  tmux split-window -h -d -t dev
  tmux new-window -a -n work -d
  # tmux new-window -a -n log -d
  # tmux new-window -a -n serve -d
fi
tmux attach -t main
