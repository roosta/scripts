#!/usr/bin/env bash
# UNLICENSE
#
# This is free and unencumbered software released into the public domain.
# 
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
# 
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 
# For more information, please refer to <https://unlicense.org/>
#
# BEGIN_DOC
# ### [updates-arch-combined.sh](./updates-arch-combined.sh)
#
# Requirements:
# - https://gitlab.archlinux.org/pacman/pacman-contrib
#
# Usage:
# This is normally used in a bar, in polybar for example
#
# ```ini
# [module/updates-arch-combined]
#  type = custom/script
#  exec = ~/scripts/updates-arch-combined.sh
#  interval = 600
# ```
#
# Source: https://github.com/polybar/polybar-scripts
#
# License [UNLICENSE](./LICENSES/UNLICENSE.txt)
# END_DOC

if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
  updates_arch=0
fi

if ! updates_aur=$(paru -Qum 2> /dev/null | wc -l); then
  updates_aur=0
fi

updates=$(("$updates_arch" + "$updates_aur"))

if [ "$updates" -gt 0 ]; then
  echo %{F#FBB829}$updates_arch/$updates_aur%{F-}
else
  echo "$updates_arch/$updates_aur"
fi
