#!/bin/bash
zenity --question \
  --text='Are you sure you want to suspend this machine?' \
  --title='Suspend' \
  --icon=dialog-warning-symbolic &&
  "$HOME/scripts/locker.sh" && systemctl suspend

