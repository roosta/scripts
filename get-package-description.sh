#!/usr/bin/env bash
# Quckly grab a package description and put in clipboard
# For example, here's a nvim command that will get description for whats in the
# " register: lua vim.cmd('! ~/scripts/get-package-description.sh ' .. vim.fn.shellescape(vim.fn.getreg('"')))
paru -Qi "$1"|rg Description|awk -F ':' '{print $2}'|wl-copy
