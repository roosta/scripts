#!/usr/bin/env bash

total=$(wc -l < "$1")

if [[ $(( $2 - 10 )) -lt 1 ]]; then
  start=1
else
  start=$(( $2 - 10 ))
fi

if [[ $(( $2 + 10 )) -gt $total ]]; then
  end=$total
else
  end=$(( $2 + 10 ))
fi


sed -n "${start},${end}p" "$1" | rg -N --colors 'match:fg:green' --smart-case --pretty --context 10 "$3"
# asd=$(( $2 + 1))

# echo $start | cat
# file=$(echo "$1" | cut -d':' -f1)
# linum=$(echo "$1" | cut -d':' -f2)
# echo $start | cat
# echo $end | cat
# echo $1 | cat
# echo $2 | cat
# pandoc -s -f org -t plain "$1" 2> /dev/null | sed -n "${2}p"
# pandoc -s -f org -t html "$file" | w3m -T text/html +"$linum"
# emacsclient -nw +"$linum" "$file"

# pandoc -s -f org -t man "$*" | man -l -
