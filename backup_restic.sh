#!/bin/bash
#This will run Restic backups and remove snapshots according to a policy
export RESTIC_REPOSITORY=rclone:googledrive:backup_andromeda
export RESTIC_PASSWORD_FILE=/home/kelghar/.restic/passwd
BACKUP_BASEPATH=/home/kelghar/mount_point/share
# need to securely provide password: https://restic.readthedocs.io/en/latest/faq.html#how-can-i-specify-encryption-passwords-automatically

#Define a timestamp function
timestamp() {
date "+%b %d %Y %T %Z"
}

# insert timestamp into log
printf "\n\n"
echo "-------------------------------------------------------------------------------" | tee -a /home/kelghar/.restic/logs/restic.log
echo "$(timestamp): backup_restic.sh started" | tee -a /home/kelghar/.restic/logs/restic.log

# Run Backups
restic backup $BACKUP_BASEPATH/_syncthing/private $BACKUP_BASEPATH/_syncthing/security-essentials $BACKUP_BASEPATH/_conny/data | tee -a /home/kelghar/.restic/logs/restic.log
restic backup --files-from _create_backup/backup_paths.list | tee -a /home/kelghar/.restic/logs/restic.log

# Remove snapshots according to policy
# If run cron more frequently, might add --keep-hourly 24
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --keep-yearly 7  | tee -a /home/kelghar/.restic/logs/restic.log

# Remove unneeded data from the repository
restic prune

# Check the repository for errors
restic check | tee -a /home/kelghar/.restic/logs/restic.log

# insert timestamp into log
printf "\n\n"
echo "-------------------------------------------------------------------------------" | tee -a /home/kelghar/.restic/logs/restic.log
echo "$(timestamp): backup_restic.sh finished" | tee -a /home/kelghar/.restic/logs/restic.log
