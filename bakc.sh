#!/bin/bash
#
# copy file to either pwd (-w||--working-dir) or
# backup directory in home(Backup) with hostname and directory structure of
# source file. (~/Backup/[HOSTNAME]/[PWD]/FILE)
# Append ISO formatted date and .bak to file (FILENAME.DATE.bak)
#
# TODO: Add support for multiple files
# TODO: add root support

bakpath=~/tests/$(hostname)$(pwd)

# test for arguments

# only filename provided run default behaviour
if [[ $# -gt 0 && -f "$1" ]]; then
  if [[ ! -d ${bakpath} ]]; then
    mkdir -p "${bakpath}"
  fi
  cp "$1" "${bakpath}/${1}.$(date -I).bak"
elif [[  $# -gt 0 ]]; then
  while [[ $# ]]; do
    case "$1" in
      -h|--help)
        echo "Help placeholder"
        exit 0
        ;;
      -w|--working-dir)
        shift
        if test $# -gt 0; then
          cp "${1}" "./${1}.bak"
        else
          echo "no file specified"
          exit 1
        fi
        shift
        ;;
      *)
        break
        ;;
    esac
  done
fi
