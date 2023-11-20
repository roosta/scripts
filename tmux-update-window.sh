#!/bin/bash
tmux new-window -a -n update
tmux setw -t update monitor-silence 300
tmux send-keys -t update 'paru -Syyu --sudoloop' C-m
