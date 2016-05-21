#!/usr/bin/zsh
if [ -z ${TMUX+x} ]; then
  echo "var is unset";
else
  echo "Tmux is running";
fi
