#!/bin/bash

# Parse command line arguments
DEBUG_MODE=0
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -d|--debug) DEBUG_MODE=1 ;;
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
  shift
done

files=$(fd -e ts -e tsx --no-require-git . ~/.config/ags)

# Create the command based on debug mode
if [ $DEBUG_MODE -eq 1 ]; then
  entr ags inspect --instance astal <<< "$files"
else
  entr -r ags run --gtk4 <<< "$files"
fi
