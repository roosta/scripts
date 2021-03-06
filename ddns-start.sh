#!/bin/sh
#
# Author: Daniel Berg (roosta) <mail@roosta.sh>
# 2015-06-21
# -------
# Uniweb dynDNS update script for asus routers running asuswrt-merlin custom firmware
# Supported asus models:  RT-AC56U, RT-N66U, RT-AC66U, RT-AC68U, RT-AC68P, RT-AC87U, RT-AC3200
# Sources:
# -------
# https://github.com/RMerl/asuswrt-merlin
# http://support.uniweb.no/hc/no/articles/200121582-Hvordan-sette-opp-dynamisk-DNS-dynDNS-
# https://github.com/RMerl/asuswrt-merlin/wiki/Custom-DDNS
# http://pastebin.com/p2pjTyY7
# -------
# Notice: script not using ssl

# User info
USERNAME="yourdomain.org"
PASSWORD="password"
HOSTNAME="host.yourdomain.org"

logger -t "$(basename "$0")" "started [$*]"

# check if IP have changed since last run
if [ "$(cat /jffs/data/prev_ip.txt)" = "$1" ]; then
  /sbin/ddns_custom_updated 1
  logger -t "$(basename "$0")" "ip is not changed."
  exit 0
fi


# get public ip
MYIP=$(curl -s  dns.uniweb.no/checkip.php | sed 's/^.*: \([^<]*\).*$/\1/')

case $(curl -s --user $USERNAME:$PASSWORD "http://dns.uniweb.no/DynDNSServer/?hostname=$HOSTNAME&myip=$MYIP") in
  NoCHG*)
     /sbin/ddns_custom_updated 1
     logger -t "$(basename "$0")" "No change"
  ;;
  IPCHG*)
    /sbin/ddns_custom_updated 1
    logger -t "$(basename "$0")" "Change successfull"
  ;;
  WFPW*)
    /sbin/ddns_custom_updated 0
    logger -t "$(basename "$0")" "Wrong password!"
   ;;
  *)
    /sbin/ddns_custom_updated 0
    logger -t "$(basename "$0")" "Host Client error"
  ;;
esac
