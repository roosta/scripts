#!/bin/bash
zenity --question \
  --text='Are you sure you want to reboot?' \
  --title='Reboot' \
  --icon=system-reboot-symbolic &&
  reboot

