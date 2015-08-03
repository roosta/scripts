#!/bin/sh

# try to attach to existing tmux deattached session or start a new session
if [[ -z "$TMUX" ]] ;then
    ID="`tmux ls | grep -vm1 attached | cut -d: -f1`" # get the id of a deattached session
    if [[ -z "$ID" ]] ;then # if not available create a new one
        tmux new-session
    else
        # if available attach to it
        tmux attach-session -t "$ID" && tmux split-window 
    fi
fi
