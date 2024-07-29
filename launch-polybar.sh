#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# launch bars based on hostname
host_name=$(hostname)
case "$host_name" in
  "garkbit")
    polybar garkbit-primary -r &
    polybar garkbit-secondary -r &
    polybar garkbit-tertiary -r &
    polybar garkbit-quaternary -r &
    ;;
  "allitnil")
    polybar allitnil -r &
    ;;
esac
