#!/bin/bash
zenity --question \
  --text='Are you sure you want to reboot?' \
  --title='Confirm' \
  --icon=system-reboot-symbolic &&
  reboot

