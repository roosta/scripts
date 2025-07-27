#!/usr/bin/env bash
# MIT License
#
# Copyright (c) 2025 Daniel Berg <mail@roosta.sh>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the “Software”), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# BEGIN_DOC
# ### [get-package-description.sh](./get-package-description.sh)
#
# Quckly grab a package description and put in clipboard
#
# Requirements: 
#
# - https://pacman.archlinux.page/
# - https://github.com/bugaevc/wl-clipboard
#
# Usage:
# ```sh
# ./get-package-description.sh [PACKAGE]
# ```
#
# For example, here's a `nvim` command that will get description for whats in the
# `"` register:
# ```vim
# :lua vim.cmd('! ~/scripts/get-package-description.sh ' .. vim.fn.shellescape(vim.fn.getreg('"')))
# ```
#
# License [MIT](./LICENSE)
# END_DOC

# Quckly grab a package description and put in clipboard
paru -Qi "$1"|rg Description|awk -F ':' '{print $2}'|wl-copy
