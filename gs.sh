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
# Drafted august 2026 based on LLM suggestion (claude-opus-5)
# reviewed and edited by Daniel Berg <mail@roosta.sh>
#
# BEGIN_DOC
# ### [gs.sh](./gs.sh)
#
# Gamescope launch command was getting pretty verbose and hard to keep track of,
# this script sets the options I need. Script need to be on `PATH` to work as a
# launch option i.e `~/.local/bin`
#
# You can optionally enable HDR by setting `GS_HDR=1`, and also set `GS_ITM=1`
# to tone-map SDR content.
#
# Additionally this includes a `LD_PRELOAD` fix, where I would get frame drops
# some time into a game when using gamescope, see this issue for more details:
#
# -  https://github.com/ValveSoftware/Source-1-Games/issues/5785
#
# Requirements:
# - gamescope
# - steam
#
# Usage:
# Set in game launch options
# ```sh
# gs %command%                   # SDR
# GS_HDR=1 gs %command%          # native HDR
# GS_HDR=1 GS_ITM=1 gs %command% # SDR game, tone-mapped up
# ```
#
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

set -euo pipefail

gs_args=(
  -W 3840 -H 2160
  --nested-refresh 120
  --fullscreen
  --adaptive-sync
  --force-grab-cursor
  --mangoapp
)

# LD_PRELOAD is cleared for gamescope, restored for the game
game_env=(LD_PRELOAD="${LD_PRELOAD:-}")

if [[ ${GS_HDR:-0} == 1 ]]; then
  gs_args+=(--hdr-enabled)
  game_env+=(DXVK_HDR=1 PROTON_ENABLE_HDR=1)

    # inverse tone mapping: fake HDR for SDR-only games
    if [[ ${GS_ITM:-0} == 1 ]]; then
      gs_args+=(--hdr-itm-enable --hdr-itm-target-nits "${GS_ITM_NITS:-1000}")
    fi
fi

exec env -u LD_PRELOAD gamescope "${gs_args[@]}" -- env "${game_env[@]}" "$@"
