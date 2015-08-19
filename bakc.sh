#!/bin/sh
# backup directory in home(.backup) with directory structure of
# source file. (~/.backup/[PATH]/FILE)
# Append dateformatted date and .bak to file (FILENAME.DATE.bak)
# TODO: verbose
# TODO: choose to follow symlinks
# TODO: conf file?

# user vars
backupdir=~/.backup
fdate="%Y-%m-%d_%H-%M-%S"

filecopy() {
  if [[ -f $1 ]]; then
    canon=$(readlink -f ${1})
    path=${backupdir}$(dirname ${canon})
    if [[ ! -d "$path" ]]; then
      mkdir -p "$path"
    fi
      cp "$1" "${path}/${1}-$(date +"$fdate").bak"  
      echo "backed up '${1}' to ${path}"
  else
    echo "failed to backup: ${1}. Not a valid file" >&2
  fi
}

while getopts ":hw:" opt; do
  case $opt in
    h)
      echo "Help placeholder" >&2
      exit 0
      ;;
    w)
      if [[ -f $OPTARG ]]; then
        cp $OPTARG "./${OPTARG}.bak"
      else 
        echo "Not a valid file" >&2
        exit 1
      fi
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done


while [[ $# -ne 0 ]]; do
  filecopy $1
  shift
done  
exit 0
