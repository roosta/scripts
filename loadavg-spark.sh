echo "$(cat /proc/loadavg | cut -d ' ' -f 1-3) $(egrep -c '^processor' /proc/cpuinfo)00 0" | sed 's/\(0\.\|0\.0\|\.\)//g' | spark | tail -n 1 | cut -b 1-9
