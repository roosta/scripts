#!/bin/bash
pattern='sd[b-z][1-9]$'
coproc inotifywait --monitor --event create,delete --format '%e %w%f' /dev

while read -r -u "${COPROC[0]}" event file; do
  if [[ $file =~ $pattern ]]; then
    case $event in
      CREATE)
        echo "Settling..."; sleep 1
        udisksctl mount --block-device $file --no-user-interaction
        ;;
      DELETE)
        ;;
    esac
  fi
done
