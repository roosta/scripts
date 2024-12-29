#!/bin/bash
zenity --question \
  --text='Are you sure you want to lock?' \
  --title='Confirm' \
  --icon=system-lock-screen-symbolic.svg &&
  "$HOME/scripts/locker.sh"

