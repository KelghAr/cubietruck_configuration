if [ $(id -u) != "0" ]
then
echo "Please use sudo"
exit
fi

if [ -d configs ]
then
	rm -r configs
fi
mkdir configs
# TODO git clone!

KELGHAR_HOME=/home/kelghar
SCRIPT_HOME="`dirname \"$0\"`"
SCRIPT_HOME="`( cd \"$SCRIPT_HOME\" && pwd )`"
CONFIG_DIR=$SCRIPT_HOME/configs

echo "Saving Bind9 Config"
mkdir $CONFIG_DIR/bind9
cd /etc/bind
cp -p db.home db.home.inv named.conf.local named.conf.options $CONFIG_DIR/bind9

echo "Saving Nginx Config"
mkdir $CONFIG_DIR/nginx
cd /etc/nginx/sites-available
cp -p couchdb_conf pyload_conf seafile_conf transmission_conf webmin_conf website_conf syncFF_conf $CONFIG_DIR/nginx

echo "Saving Samba Config"
mkdir $CONFIG_DIR/samba
cd /etc/samba/configs
cp -p smb_andromeda.conf $CONFIG_DIR/samba

echo "Saving SSH Config"
mkdir $CONFIG_DIR/ssh
cd $KELGHAR_HOME/.ssh
cp -p authorized_keys config $CONFIG_DIR/ssh

echo "Saving Tmux Config"
mkdir $CONFIG_DIR/tmux
cp -p $KELGHAR_HOME/.tmux.conf $CONFIG_DIR/tmux/tmux.conf

echo "Saving IpTables"
mkdir $CONFIG_DIR/iptables
iptables-save > $CONFIG_DIR/iptables/iptables.andromeda

echo "Save bash aliases"
mkdir $CONFIG_DIR/bash
cp -p $KELGHAR_HOME/.bash_aliases $CONFIG_DIR/bash/bash_aliases

echo "Saving pyload config"
mkdir $CONFIG_DIR/pyload
cd $KELGHAR_HOME/.pyload
cp -p pyload.conf SJ.txt $CONFIG_DIR/pyload

echo "Saving transmission config"
mkdir $CONFIG_DIR/transmission
cd /etc/transmission-daemon
cp -p /etc/transmission-daemon/settings.json $CONFIG_DIR/transmission

echo "Saving Crontab"
mkdir $CONFIG_DIR/crontab
su - kelghar -c "crontab -l > $KELGHAR_HOME/crontab_config"
cp -p $KELGHAR_HOME/crontab_config $CONFIG_DIR/crontab/
rm $KELGHAR_HOME/crontab_config

echo "Saving baikal"
mkdir $CONFIG_DIR/baikal
cd /var/www/baikal
cp -p --parents `find * -regex .*config.*` $CONFIG_DIR/baikal
cp -p --parents Specific/db/db.sqlite $CONFIG_DIR/baikal
cd $CONFIG_DIR

echo "Saving FireFox Sync Server config"
mkdir $CONFIG_DIR/ffsync
cd $SCRIPT_HOME/..
cp -p $SCRIPT_HOME/../syncserver/syncserver.ini $CONFIG_DIR/ffsync

echo "Create metastore file"
cd $CONFIG_DIR/..
./metastore -s -f metastore_file
