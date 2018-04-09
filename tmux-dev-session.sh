#!/bin/bash
# source: https://unix.stackexchange.com/questions/80473/how-do-i-run-a-shell-command-from-tmux-conf/80529#80529
# Automate setting up tmux dev session
if ! tmux has-session -t dev 2>/dev/null; then
  tmux new-session -s dev -n main -d
  tmux split-window -h -d -t main
  tmux new-window -a -n serve -d
fi
tmux attach -t dev
