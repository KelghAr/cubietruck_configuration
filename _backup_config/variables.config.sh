#!/usr/bin/env bash

# COMMON
KELGHAR_HOME=/home/kelghar
SCRIPT_HOME=`readlink -f $0`
SCRIPT_HOME=$(dirname $SCRIPT_HOME)
cd $SCRIPT_HOME
CONFIG_DIR="$SCRIPT_HOME/andromeda_backup"
SERVICES_TO_STOP=( nginx transmission-daemon samba dovecot bind9 postfix )

# BACKUP
BACKUP_UTILS="$SCRIPT_HOME/_create_backup"
PATHS_TO_BACKUP="$BACKUP_UTILS/backup_paths.list"
PATHS_TO_TAR="$BACKUP_UTILS/backup_paths_to_tar.list"
PATHS_EXCLUDE="$BACKUP_UTILS/backup_exclude.list"
DATABASES_TO_BACKUP="$BACKUP_UTILS/databases_backup.list"
PATH_TO_HIDE="$KELGHAR_HOME/mount_point/share/_hide/database_backup"

# RESTORE
RESTORE_UTILS="$SCRIPT_HOME/_restore_backup"
PATHS_EXCLUDE="$RESTORE_UTILS/restore_exclude.list"

