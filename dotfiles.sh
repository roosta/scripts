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
# ### [dotfiles.sh](./dotfiles.sh)
#
# Scaffold various shell utils  needed for storing dotfiles like described here
# https://wiki.archlinux.org/title/Dotfiles.
# 
# > [!WARNING]
# > Work in progress
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

# https://wiki.archlinux.org/title/Dotfiles
mkdir -p .dotfiles-backup && \
  /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" checkout 2>&1 | \
  grep -E "\s+\." | awk {'print $1'} | \
  xargs -I{} mv {} .dotfiles-backup/{}
