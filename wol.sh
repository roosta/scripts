#!/bin/bash

# definition of MAC addresses
monster=01:12:46:82:ab:4f
chronic=00:3a:53:21:bc:30
powerless=1a:32:41:02:29:92
ghost=01:1a:d2:56:6b:e6

while [ "$input1" != quit ]; do
echo "Which PC to wake?"
echo "p) powerless"
echo "m) monster"
echo "c) chronic"
echo "g) ghost"
echo "b) wake monster, wait 40sec, then wake chronic"
echo "q) quit and take no action"
read input1
  if [ $input1 == p ]; then
  /usr/bin/wol $powerless
  exit 1
fi

if [ $input1 == m ]; then
  /usr/bin/wol $monster
  exit 1
fi

if [ $input1 == c ]; then
  /usr/bin/wol $chronic
  exit 1
fi

# this line requires an IP address in /etc/hosts for ghost
# and should use wol over the internet provided that port 9
# is forwarded to ghost on ghost's router

if [ $input1 == g ]; then
  /usr/bin/wol -v -h -p 9 ghost $ghost
  exit 1
fi

if [ $input1 == b ]; then
  /usr/bin/wol $monster
  echo "monster sent, now waiting for 40sec then waking chronic"
  sleep 40
  /usr/bin/wol $chronic
  exit 1
fi

if [ $input1 == Q ] || [ $input1 == q ]; then
echo "later!"
exit 1
fi

done
echo  "this is the (quit) end!! c-ya!"
