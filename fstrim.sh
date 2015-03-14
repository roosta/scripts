#!/bin/sh
#
#
#
#Run “fstrim” command
LOG=/var/log/trim.log
fstrim -v / >>$LOG
fstrim -v /home >>$LOG
echo “Time: $(date)” >>$LOG
exit 0
