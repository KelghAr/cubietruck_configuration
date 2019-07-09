#!/bin/bash

if [ $(id -u) != "0" ]
then
echo "Please use sudo"
return 1
fi

source _backup_config/variables.config.sh
source _backup_config/functions.config.sh

run_rsync_backup() {
	#use rsync to backup the files in the "paths.list" but exclude those in "exclude.list"
	while read -r line
	do
	    echo $line
	    #find $line -name '*.db' -exec sh -c 'sqlite3 $1 .dump > $1.sqlite_dump'  _ {} \;
	    rsync -pRva --del --exclude-from=$PATHS_EXCLUDE $line $CONFIG_DIR
	done < "$PATHS_TO_BACKUP"
}

git_stuff() {
	cd $SCRIPT_HOME
	#notify git about the new configs
	git add -A
	git commit -m "`date --rfc-3339=seconds`"
	chown kelghar:kelghar $SCRIPT_HOME/.git/ -R
}

make_dir $CONFIG_DIR

echo "Make rsync backup"
run_rsync_backup

echo "Create metastore file"
rm $SCRIPT_HOME/.git_cache_meta
sh -e $SCRIPT_HOME/diverse_bash_scripts/git-cache-meta.sh --store

echo "Git stuff"
git_stuff

