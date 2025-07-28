#!/usr/bin/env bash
# MIT License
#
# Copyright (c) 2024 Daniel Berg <mail@roosta.sh>
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
# ### [torrent-done.sh](./torrent-done.sh)
#
# A simple script to extract a rar file inside a directory downloaded by
# Transmission. It uses environment variables passed by the transmission client
# to find and extract any rar files from a downloaded torrent into the folder
# they were found in.
#
# Requirements:
# - https://transmissionbt.com/
#
# Usage:
# Configure to run on torrent completion in your client. See `./media-clean.sh`
# for a way to clean up after this script.
#
# > [!NOTE]
# > I don't actually know where this snippet originated, its all over the web,
# > in gists and other script repos. I've seen other variants of this licensed
# > under MIT, so I'm assuming that's OK here to, but I'm not 100%. If anyone
# > knows, please let me know so I can add proper credit
#  
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC

find /"$TR_TORRENT_DIR"/"$TR_TORRENT_NAME" -name "*.rar" -execdir unrar e -o- "{}" \;
