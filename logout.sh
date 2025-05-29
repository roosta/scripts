#!/bin/bash
zenity --question \
  --text='Are you sure you want to log out?' \
  --title='Logout' \
  --icon=system-log-out-symbolic &&
  uwsm stop

