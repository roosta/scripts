#!/bin/bash
# full system backup
# source: https://wiki.archlinux.org/index.php/Full_system_backup_with_tar

# Backup destination
backdest=/mnt/disk

# Labels for backup name
pc=$(hostname)
distro=arch
type=full
date=$(date "+%F")
backupfile="$backdest/$pc-$distro-$type-$date.tar.gz"

# Exclude file location
prog=${0##*/} # Program name from filename
excdir="/home/roosta/scripts"
exclude_file="$excdir/$prog-exc.txt"

# Check if chrooted prompt.
echo -n "First chroot from a LiveCD.  Are you ready to backup? (y/n): "
read executeback

# Check if exclude file exists
if [ ! -f $exclude_file ]; then
  echo -n "No exclude file exists, continue? (y/n): "
  read continue
  if [ $continue == "n" ]; then exit; fi
fi

if [ $executeback = "y" ]; then
  # -p and --xattrs store all permissions and extended attributes.
  # Without both of these, many programs will stop working!
  # It is safe to remove the verbose (-v) flag. If you are using a
  # slow terminal, this can greatly speed up the backup process.
  tar --exclude-from=$exclude_file --xattrs -czpvf $backupfile /
fi
