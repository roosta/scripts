#!/usr/bin/env bash
file=$(echo "$1" | cut -d':' -f1)
linum=$(echo "$match" | cut -d':' -f2)
pandoc -s -f org -t man "$file" | man -l -
