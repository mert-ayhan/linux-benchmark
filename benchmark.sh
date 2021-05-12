#! /bin/bash

if ! [ -x "$(command -v mpstat)" ]; then
  echo 'error: sysstat is not installed.' >&2
  exit 1
fi

if [ $# -ne 2 ]; then
  echo "usage: ./benchmark.sh [file_name] [seconds]"
else
  printf "Bencmark Started!\nData will be logged to ${1} every ${2} seconds.\n"
  echo
  echo "Date,Memory,Disk,CPU" >> $1
  echo "Date,Memory,Disk,CPU"
  end=$((SECONDS+3600))
  while [ $SECONDS -lt $end ]; do
  CURRENTDATE=`date +"%Y-%m-%d %T"`
  MEMORY=$(free | awk 'FNR == 2 {print ($3/$2)*100"%"}')
  DISK=$(df -h | awk '$NF=="/"{printf "%s,", $5}')
  CPU=$(mpstat 1 1 | awk '/^Average/ {print 100-$NF"%"}')
  echo $CURRENTDATE$MEMORY$DISK$CPU >> $1
  echo $CURRENTDATE$MEMORY$DISK$CPU
  sleep $2
  done
fi
