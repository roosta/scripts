#!/usr/bin/env bash
# MIT License
#
# Copyright (c) 2016 Daniel Berg <mail@roosta.sh>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# BEGIN_DOC
# ### [git-update.sh](./git-update.sh)
#
# Script to walk a list of repositories and either pull or clone, depending on
# state. It is done in parallel, and takes a destination and a flat text file
# with git repo urls to sync separated by newlines. Used in my dotfiles, when I
# need to keep repos up to date with a job.
#
# Requirements:
# - https://www.gnu.org/software/parallel/
# - https://git-scm.com/
#
# Usage: `git-update.sh DEST REPO_FILE.txt`
#
# ```sh
# ./git-update.sh ~/src mydependencies.txt
# ```
# 
# License [MIT](./LICENSES/MIT-LICENSE.txt)
# END_DOC
error_msg() {
  echo "missing argument(s)"
  exit 1
}

git_clone() {
  local repo="$1"
  local out
  out=$(git clone "$repo" 2>&1)
  echo "$out"
}
export -f git_clone

git_pull() {
  local dest="$1"
  cd "$dest" && git pull && cd - || return
}
export -f git_pull

collect_clone() {
  local file="$1"
  local tmp
  local result=""

  while read -r repo; do

    # ignore blank lines
    if [ "$repo" != "" ]; then

      tmp=$(sem -j 4 git_clone "$repo" 2>&1)
      result+="${tmp},"
    fi

  done <"$file"
  echo "$result"
}

update_repos() {
  local repos="$1"
  IFS=,
  for out in $repos; do
    if [[ $out =~ fatal ]]; then
      dest=$(echo "$out" | awk '{print substr($4, 2, length($4) - 2)}')
      sem -j 4 git_pull "$dest"
    else
      echo "$out"
    fi
  done
  sem --wait
}

 # echo -e "\033[0;33mupdating $dest...\033[0m"
# take two args. Parent folder and repositories text file.
# loop over each repo in text file, attempting to clone
main () {
  (( $# == 2 )) || error_msg

  local out
  local path="$1"
  local repo_file="$2"
  local clone_status
  local dest

  cd "$path" || exit

  if [[ -f "$2" ]]; then
    clone_status=$(collect_clone "$repo_file")
    update_repos "$clone_status"
  else
    error_msg
  fi
}

main "${@}"
# git_pull
