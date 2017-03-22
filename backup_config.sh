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

backup_mysql() {
	while IFS=';' read -ra line
	do
		mysqldump -u${line[1]} -p${line[2]} ${line[0]} > $PATH_TO_HIDE/${line[0]}.sql
	done < "$DATABASES_TO_BACKUP"
}

save_crontab() {
	su - kelghar -c "crontab -l > $KELGHAR_HOME/crontab_config"
	mv $KELGHAR_HOME/crontab_config $CONFIG_DIR/	
}

make_dir $CONFIG_DIR


echo "Apply metastore file"
apply_or_create_metadata a

#echo "Stop services"
#shutting down SERVICES_TO_STOP
#start_stop_services stop

echo "Make rsync backup"
run_rsync_backup

echo "Saving Crontab"
save_crontab

echo "Create metastore file"
apply_or_create_metadata s

#echo "Start services again"
#start_stop_services start

echo "Git stuff"
git_stuff

#echo "Backup mysql"
#backup_mysql

#echo "Backup mail"
#bash $SCRIPT_HOME/_mail_backup/backup_mail.sh
