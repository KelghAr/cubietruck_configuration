#!/usr/bin/env bash

# COMMON
KELGHAR_HOME=/home/kelghar
SCRIPT_HOME=`readlink -f $0`
SCRIPT_HOME=$(dirname $SCRIPT_HOME)
cd $SCRIPT_HOME
CONFIG_DIR="$SCRIPT_HOME/andromeda_backup"

# BACKUP
BACKUP_UTILS="$SCRIPT_HOME/_create_backup"
PATHS_TO_BACKUP="$BACKUP_UTILS/backup_paths.list"
PATHS_EXCLUDE="$BACKUP_UTILS/backup_exclude.list"

# RESTORE
RESTORE_UTILS="$SCRIPT_HOME/_restore_backup"
PATHS_EXCLUDE="$RESTORE_UTILS/restore_exclude.list"

