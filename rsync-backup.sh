rsync -aAX --info=progress2 --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found", \
   "/home/*/dropbox", "/home/*/.local/share/Trash/*", "/home/roosta/.cache"} / /mnt/data
