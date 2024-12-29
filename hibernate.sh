#!/bin/bash
zenity --question \
  --text='Are you sure you want to hibernate this machine?' \
  --title='Confirm' \
  --icon=dialog-warning-symbolic &&
  "$HOME/scripts/locker.sh" && systemctl hibernate

