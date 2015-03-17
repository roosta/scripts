# bash-scripts

information:
----
collection of personal bash scripts, probably not very useful for anyone other than me but I never know so I include some explanations for the various scripts. 

chdisp-tv/desk/both.sh: 
----
Collection of scripts using xrandr  and pacmd to change active monitor and audio sink to either my desk, TV or both.  Had a number of issues previously with my monitor setup and needed a quick way of changing the active one with a keyboard shortcut

chdisp.sh
---
Collection of the methods developed in the above scripts. Single script call with opts to choose display. Note that changing sink isn't fool proof, and fails sometimes. Since I've recently managed to fix several issues with my setup these remain unmaintaned for the forseeable future.

bakc.sh
---
Backup script to speed up the prosess of backing up system files, appending a date-time and a .bak extension and placing it in my backup dir in home with both hostname and source path. Also includes the option of placing it in pwd and only appending a .bak ext. If one already exist it will overwrite.

takes the options: -w|--working-dir, h|--help currently and default behaviour is to add it to current users backup dir

```shell
$ cd /tests
$ bakc --working-dir test.file 
# result:
# ./test.file.bak

$ bakc test.file
# result:
# ~/Backup/[hostname]/tests/test.file.2015-03-17.bak

```

#####TODO:

- [ ] add support for multiple files
- [ ] add root support
- [ ] fill out --help
- [ ] comment code

fstrim.sh
---
a short fstrim script to run and log fstrim, and include home partition. I didn't make this, but keep it here since its useful. I'd link source but I can't recall where I got it.

source-change.sh
---
Originial script that I based the chdisp*.sh scripts off of. I'll dig out the link from my bookmarks so I can credit the creator of this and fstrim.

