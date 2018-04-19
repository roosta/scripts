#!/bin/bash
# Prints current download or upload in kb/s
# syntax is:
# rxtx [rx / tx] [interface] 
# ie: $ rxtx rx brige0
# Source: https://gist.github.com/joemiller/4069513

case $1 in
  "tx")
    T1=$(cat "/sys/class/net/$2/statistics/tx_bytes")
    sleep 1
    T2=$(cat "/sys/class/net/$2/statistics/tx_bytes")
    TBPS=$((T2 - T1))
    TKBPS=$((TBPS / 1024))
    echo $TKBPS
    ;;
  "rx")
    R1=$(cat "/sys/class/net/$2/statistics/rx_bytes")
    sleep 1
    R2=$(cat "/sys/class/net/$2/statistics/rx_bytes")
    RBPS=$((R2 - R1))
    RKBPS=$((RBPS / 1024))
    echo $RKBPS
    ;;
esac
