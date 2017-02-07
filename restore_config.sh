#!/bin/bash

if [ $(id -u) != "0" ]
then
echo "Please use sudo"
return 1
fi

source _backup_config/variables.config.sh
source _backup_config/functions.config.sh

# Define functions
add_groups_and_user() {
	groupadd -g 2222 vmail
	adduser --disabled-login --disabled-password --ingroup vmail --uid 2222 --home /home/vmail vmail
}

restore_install() {
	bash $SCRIPT_HOME/_apt-get_backup/restore_apt.sh
}


run_rsync_restore() {
	rsync -avzI "$CONFIG_DIR" /
}

get_ohMyZsh() {
	su - kelghar -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'
	chsh -s /bin/zsh
}

restore_mail() {

}

restore_mysql() {
	
}

echo "Restore install"
restore_install

echo "Shutting down SERVICES_TO_STOP"
start_stop_services stop

apply_or_create_metadata a

add_groups_and_user

run_rsync_restore

get_ohMyZsh



#TODO: Folder restoren
#TODO: restore mail