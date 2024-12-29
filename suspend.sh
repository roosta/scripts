#!/bin/bash
zenity --question \
  --text='Are you sure you want to suspend this machine?' \
  --title='Confirm' \
  --icon=dialog-warning-symbolic &&
  "$HOME/scripts/locker.sh" && systemctl suspend

