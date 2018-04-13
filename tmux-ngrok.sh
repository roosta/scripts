#!/bin/bash
if ! tmux has-session -t ngrok 2>/dev/null; then
  tmux new-session -s nrok -n ssh -d
  tmux send-keys -t ngrok "ngrok tcp $1" C-m
fi
