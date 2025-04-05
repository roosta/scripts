#!/bin/bash
zenity --question \
  --text='Are you sure you want to log out?' \
  --title='Confirm' \
  --icon=system-log-out-symbolic &&
  uwsm stop

