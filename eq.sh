# terminator &
wid=$(wmctrl -lp|grep cava|tail -n 1|cut -d\  -f1)
ignw -s "$wid"
