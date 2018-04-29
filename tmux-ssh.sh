#!/bin/bash
if [ -z "$1" ]; then
  echo "No port number argument"
  exit 1
else
  if ! tmux has-session -t ssh 2>/dev/null; then
    tmux new-session -s ssh -n ngrok -d
    tmux send-keys -t ssh "ngrok tcp $1" C-m
  else
    echo "There is already an SSH session"
    exit 1
  fi
fi
