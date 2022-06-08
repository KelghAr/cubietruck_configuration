#!/bin/bash

if [ $(id -u) != "0" ]; then
    echo "Please use sudo"
    exit
fi

target=/media/backup/
today=$(date +%Y-%m-%d)

device=$(find /dev/disk/by-id/ -lname '*sdd')

echo $device

if [[ $device == *"usb-Generic"* ]]; then  
  mkdir -p $target
  mount /dev/sdd1 $target
  rsync -avrR --delete --files-from="backup_paths.list" / "${target}${today}/"
  #ln -nsf "${target}${today}" "${ziel}last"
  umount $target
  exit
fi

echo device is no sd card
