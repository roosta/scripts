#!/bin/bash
tmux new-window -a -d -n serve
tmux send-keys -t serve '~/src/i3wsr/target/release/i3wsr' C-m
