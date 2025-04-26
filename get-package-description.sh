#!/usr/bin/env bash
# Quckly grab a package description and put in clipboard
paru -Qi "$1"|rg Description|awk -F ':' '{print $2}'|wl-copy
