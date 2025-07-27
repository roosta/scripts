#!/usr/bin/env bash
# MIT License
#
# Copyright (c) 2017 Daniel Berg <mail@roosta.sh>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# BEGIN_DOC
# ### [crypthelper.sh](./crypthelper.sh)
#
# Script to simplify opening and mounting dm-crypt encrypted partitions. Really
# not terribly useful I just kept forgetting how to do it, so I wrote this.
#
# Requirements:
# - https://gitlab.com/cryptsetup/cryptsetup/
#
# Usage: `./cryptsetup.sh [CMD]`
#
#     commands:
#       open:             open device by passing these args [DEVICE] [NAME]
#       close:            close device by passing [NAME]
#     
#     Example:
#       crypthelper open /dev/sdh1 my-encrypted-device-name # gets mountet in ~/mnt/[name]
#       crypthelper close my-encrypted-device-name
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

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
  crypthelper close my-encrypted-device-name
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
