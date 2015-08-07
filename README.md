# bash-scripts

information:
----
collection of personal bash scripts, probably not very useful for anyone other than me but I never know so I include some explanations for the various scripts. 

bakc.sh
---
Backup script to speed up the process of backing up system files, appending a date-time and a .bak extension and placing it in my backup dir in home with both hostname and source path. Also includes the option of placing it in working dir and only appending a .bak. 

takes the options: -w, h currently and default behavior is to add it to current users backup dir

```shell
$ cd /tests
$ bakc -w test.file 
# result:
# ./test.file.bak

$ bakc test.file
# result:
# ~/.backup/[hostname]/tests/test.file-2015-03-17_10-28-01.bak

```

chdisp.sh
---
Script that changes active displays and moves sound sources to relevant sink
Seeing as this is a rather personal script, and only adhere to my setup it needs some tweaking to be usable to anyone else currenty
Uncertain if I'll make it less coupled to my own setup.


fstrim.sh
---
a short fstrim script to run and log fstrim, and include home partition. I didn't make this, but keep it here since its useful. I'd link source but I can't recall where I got it.


