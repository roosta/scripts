#!/bin/bash
zenity --question \
  --text='Are you sure you want to shut down?' \
  --title='Shutdown' \
  --icon=system-shutdown-symbolic &&
  shutdown now

