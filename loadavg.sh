loadavg=$(< /proc/loadavg cut -d\  -f1-3)
echo $loadavg
