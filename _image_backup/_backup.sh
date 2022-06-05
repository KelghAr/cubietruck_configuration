#!/bin/sh

if [ $UID -ne 0 ]; then       # or `id -u`
    exec sudo -- "$0" "$@"
fi

target=/media/backup/
today=$(date +%Y-%m-%d)

device=find /dev/disk/by-id/ -lname '*sdb'

if [[ $device == *"SD_MMC"* ]]; then  
  mkdir -p $target
  mount /dev/sdb $target
  #rsync -avR --delete -files-from=:backup_paths.list  "${target}${today}/" --link-dest="${target}last/"
  #ln -nsf "${target}${today}" "${ziel}last"
fi

echo device is no sd card