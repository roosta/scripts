#!/bin/bash
# source: https://unix.stackexchange.com/questions/80473/how-do-i-run-a-shell-command-from-tmux-conf/80529#80529
# Automate setting up tmux dev session
if ! tmux has-session -t work 2>/dev/null; then
  tmux new-session -s work -n dev -d
  tmux split-window -h -d -t dev
  tmux new-window -a -n log -d
  tmux new-window -a -n serve
  tmux send-keys -t serve 'cd ~/datomic/datomic-pro-0.9.5544' C-m
  tmux send-keys -t serve 'bin/transactor config/dev-transactor.properties' C-m
  tmux split-window -h -t serve
  tmux send-keys -t serve 'cd ~/datomic/datomic-pro-0.9.5544' C-m
  tmux send-keys -t serve 'bin/console -p 3333 dev datomic:dev://localhost:4334/' C-m
  tmux select-window -t dev
fi
tmux attach -t work
