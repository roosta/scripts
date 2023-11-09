#!/bin/bash
tmux new-window -a -d -n serve
tmux send-keys -t serve 'cd ~/src/i3wsr && cargo run' C-m
