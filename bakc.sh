#!/usr/bin/env bash
# MIT License
#
# Copyright 2016 Daniel Berg <mail@roosta.sh>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# BEGIN_DOC
# ### [bakc.sh](./bakc.sh)
#
# Quickly backup and timestamp a file mirroring its location in a target backup
# directory
#
# Usage: `bakc [OPTION] SOURCE`
#
#     OPTIONS:
#        -w         Save source file in working directory with .bak extension
#        -R         Remove file after backup
#        -h         Display this message
#
# Examples
#
# ```sh
# ./bakc.sh ~/src/bakc/bakc.sh
# # backed up /home/[user]/src/bakc/bakc.sh to /home/[user]/backup/home/[user]/src/bakc/bakc.sh~2017-02-12@21:20:12
# ```
#
# Includes the option of placing it in working dir and only appending a .bak file extension
#
# ```sh
# ./bakc.sh -w file.txt
# # Created test.txt.bak here (pwd)
# ```
#
# Also included is the option to remove source file after backup:
#
# ```sh
# ./bakc.sh -wR file.txt
# # Created file.txt.bak here (/home/[user]/[path]) removed 'file.txt'
# ```
#
# It takes a relative path, and/or multiple files and follow symlinks:
#
# ```sh
# ~/bakc.sh ~/.zprofile ~/.zshenv
# # backed up /home/[user]/.zshenv to /home/[user]/backup/home/[user]/.zshenv\~2017-02-12@22:01:40
# # backed up /home/[user]/.zprofile to /home/[user]/backup/home/[user]/.zprofile\~2017-02-12@22:01:40
# ```
#
# ```sh
# ~/bakc.sh -w ~/.zshenv ~/.zprofile
# # created /home/[user]/.zshenv.bak here (/home/[user]/src/bakc)
# # Created /home/[user]/.zprofile.bak here (/home/[user]/src/bakc)
# ```
#
# License [GPL-3.0](./LICENSES/GPL-3.0-LICENSE.txt)
# END_DOC

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

wflag=
Rflag=

BACKUP_PATH=~/backup
FILE_SUFFIX=$(date +"%Y-%m-%d@%T")

file_backup_long() {
  if [[ -f $1 || -d $1 ]]; then
    canon=$(readlink -f "${1}")
    # target_path=$(dirname ${canon})
    target_file=$(basename "${1}")
    destination=${BACKUP_PATH:?}$(dirname "${canon}")
    if [[ ! -d "$destination" ]]; then
      mkdir -p "$destination"
    fi
    cp -Lrx "${1}" "${destination}/${target_file}~${FILE_SUFFIX:?}"
    echo "backed up '${1}' to ${destination}/${target_file}~${FILE_SUFFIX:?}"
  else
    echo "failed to backup: ${1}. Not a valid file" >&2
  fi
}

file_backup_short() {
  if [[ -f $1 || -d $1 ]]; then
    cp -Lri "${1}" "$(basename "${1}").bak"
    echo "Created ${1}.bak here ($(pwd))"
  else
    echo "Not a valid file" >&2
    exit 1
  fi
}

file_remove() {
  if [[ -f $1 ]]; then
    rm -Iv --one-file-system "${1}"
  elif [[ -d $1 ]]; then
    rm -Irv --one-file-system "${1}"
  else
    echo "Failed to remove: ${1}. Check permissions" >&2
  fi
}

usage() {
	cat >&2 <<EOL
Usage: bakc [OPTION] SOURCE

options:
  -w         Save source file in working directory with .bak extension
  -R         Remove file after backup
  -h         Display this message
EOL
}

run() {
  if [[ $# -gt 0 ]]; then
    while [[ $# -ne 0 ]]; do
      if [[ -n $Rflag && -n $wflag ]]; then
        file_backup_short "$1"
        file_remove "$1"
      elif [[ -n $Rflag ]]; then
        file_backup_long "$1"
        file_remove "$1"
      elif [[ -n $wflag ]]; then
        file_backup_short "$1"
      else
        file_backup_long "$1"
      fi
      shift
    done
    exit 0
  else
    echo "Provide a file to backup" >&2
  fi
}

options=":hwR"
while getopts ${options} opt; do
  case $opt in
    h)
      usage
      exit 0
      ;;
    w)
      wflag=1
      ;;
    R)
      Rflag=1
      ;;
    \?)
      echo "Invalid option: -${OPTARG}" >&2
      exit 1
      ;;
    :)
      echo "Option -${OPTARG} requires an argument." >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))
run "$@"

