#!/bin/bash
# $1 = device $2 = name
_open () {
  dest="$HOME/mnt/$2"
  if [[ ! -d "$dest" ]]; then
    mkdir -p "$dest"
  fi
  sudo cryptsetup --type luks open "$1" "$2" && sudo mount -t ext4 "/dev/mapper/$2" "$HOME/mnt/$2"
}

_close () {
  sudo umount "$HOME/mnt/$1" && sudo cryptsetup close "$1"
}

usage() {
	cat >&2 <<EOL

Usage: crypthelper command ARGS

commands:
  open:             open device by passing these args [DEVICE] [NAME]
  close:            close device by passing [NAME]

Example:
  crypthelper open /dev/sdh1 my-encrypted-device-name # gets mountet in ~/mnt/[name]
  crypthelper close my-encrypted-device-name # gets mountet in ~/mnt/[name]
EOL
	exit 1
}

run () {
  (( $# >= 1 )) || usage
  case "$1" in
    "open")
      _open "${@:2}"
      ;;
    "close")
      _close "${@:2}"
      ;;
    *)
      usage
  esac
}

run "${@}"
