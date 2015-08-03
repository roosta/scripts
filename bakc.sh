#!/bin/sh
# copy file to either current (-w||--working-dir) or
# backup directory in home(.backup) with directory structure of
# source file. (~/Backup/[PWD]/FILE)
# Append dateformatted date and .bak to file (FILENAME.DATE.bak)
#
# TODO: Add support for multiple files

backupdir=~/.test
dateformat="%Y%m%d.%H%M"


filecopy() {
 if [[ -f $1 ]]; then
   PATH=${backupdir}/$(dirname ${1})
   if [[ ! -d "$PATH" ]]; then
    mkdir -p "$PATH"
   fi
   cp -v "$1" "${backupdir}/${1}.$(date +"$dateformat").bak"
 fi
}

while getopts ":hw:" opt; do
  case $opt in
    -h)
      echo "Help placeholder" >&2
      exit 0
      ;;
    -w)
      #if [[ -f $OPTARG ]]; then
        #cp $OPTARG "./${OPTARG}.bak"
        echo "$OPTARG"
      #else 
        #echo "Not a valid file" >&2
        #exit 1
      #fi
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
