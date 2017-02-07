if [ $(id -u) != "0" ]
then
echo "Please use sudo"
exit
fi

if [ ! -d /home/kelghar ]
then
echo "Please add user kelghar"
exit
fi

KELGHAR_HOME=/home/kelghar
SCRIPT_HOME="`dirname \"$0\"`"
SCRIPT_HOME="`( cd \"$SCRIPT_HOME\" && pwd )`"
CONFIG_DIR=$SCRIPT_HOME/configs
PYTHON_DIR=$SCRIPT_HOME/python_scripts

./metastore -a -f metastore_file

git config --global user.email "kelghar@andromeda.home"
git config --global user.name "kelghar"

apt-get update
apt-get upgrade -y
apt-get install -y \
  bind9 \
  cryptsetup \
  git-core \
  make \
  ncurses-term \
  nginx \
  openssl \
  php5-common \
  php5-fpm \
  php5-mcrypt \
  php5-sqlite \
  python \
  python-configparser \
  python-crypto \
  python-dev \
  python-pip \
  python-pycurl \
  python-virtualenv \
  samba \
  samba-common \
  tmux \
  transmission-daemon \
  virtualenv

pip install Send2Trash

if [ ! -d $KELGHAR_HOME/mount_point ]
then
mkdir $KELGHAR_HOME/mount_point
mkdir $KELGHAR_HOME/mount_point/share
chown kelghar:kelghar $KELGHAR_HOME/mount_point/ -R
fi

if [ ! -f $KELGHAR_HOME/seafile-server_4.2.2_pi.tar.gz ]
then
wget https://bitbucket.org/haiwen/seafile/downloads/seafile-server_4.2.2_pi.tar.gz -P $KELGHAR_HOME
fi

echo "Stopping services"
service nginx stop
service transmission-daemon stop
service smbd stop
service bind9 stop

echo "Installing pyload"
if [ ! -f $KELGHAR_HOME/pyload-v0.4.9-all.deb ]
then
wget http://download.pyload.org/pyload-v0.4.9-all.deb -P $KELGHAR_HOME
fi
dpkg -i $KELGHAR_HOME/pyload-v0.4.9-all.deb

if [ ! -d $KELGHAR_HOME/.pyload ]
then
mkdir $KELGHAR_HOME/.pyload
chown kelghar:kelghar $KELGHAR_HOME/.pyload
chmod 755 $KELGHAR_HOME/.pyload
exit
fi
cp -p $CONFIG_DIR/pyload/* $KELGHAR_HOME/.pyload/

echo "Adding aliases"
cp -p $CONFIG_DIR/bash/bash_aliases $KELGHAR_HOME/.bash_aliases

echo "Restoring Tmux"
cp -p $CONFIG_DIR/tmux/tmux.conf $KELGHAR_HOME/.tmux.conf
cp -p $SCRIPT_HOME/tmux-mem-cpu-load /usr/local/bin/

echo "Restoring Bind9"
cp -p $CONFIG_DIR/bind9/* /etc/bind

echo "Restoring Nginx"
cp -p $CONFIG_DIR/nginx/* /etc/nginx/sites-available
cp -rs /etc/nginx/sites-available/* /etc/nginx/sites-enabled/
sh $SCRIPT_HOME/cert/create_cert_files.sh

echo "Restoring Samba"
SAMBA_PERSONAL=/etc/samba/configs
if [ -d $SAMBA_PERSONAL ]
then
rm -r $SAMBA_PERSONAL
fi
mkdir $SAMBA_PERSONAL
cp -p $CONFIG_DIR/samba/* $SAMBA_PERSONAL
python $PYTHON_DIR/include_smb_config.py
smbpasswd -a kelghar

echo "Restoring SSH"
if [ ! -d $KELGHAR_HOME/.ssh ]
then
mkdir $KELGHAR_HOME/.ssh
chown kelghar:kelghar $KELGHAR_HOME/.ssh
chmod 600 $KELGHAR_HOME/.ssh
fi
cp -p $CONFIG_DIR/ssh/* $KELGHAR_HOME/.ssh

echo "Restoring transmission"
cp -p $CONFIG_DIR/transmission/settings.json /etc/transmission-daemon/settings.json

echo "Installing FireFox Sync Server"
# I assume that the "git" folder is in /home/kelghar/git
cd $SCRIPT_HOME/..
git clone https://github.com/mozilla-services/syncserver
cd syncserver
make build
cp -p $CONFIG_DIR/ffsync/* $SCRIPT_HOME/../syncserver
cp -p $SCRIPT_HOME/permanent_configs/syncserver /etc/init.d/
update-rc.d syncserver defaults

echo "Restoring Scripts"
cp -p tc_mount.sh $KELGHAR_HOME/

echo "Restoring baikal"
cd /var/www
wget http://baikal-server.com/get/baikal-regular-0.2.7.tgz
tar -xzf baikal-regular-0.2.7.tgz
mv baikal-regular baikal
rm baikal-regular-0.2.7.tgz
cp -pr $CONFIG_DIR/baikal/* /var/www/baikal

echo "Restore environment"
cat $SCRIPT_HOME/permanent_configs/interfaces.andromeda > /etc/network/interfaces
echo "domain home" > /etc/resolv.conf
echo "search home" >> /etc/resolv.conf
echo "nameserver 192.168.2.42" >> /etc/resolv.conf
echo "127.0.0.1   localhost" > /etc/hosts
echo "192.168.2.42 andromeda.home andromeda" >> /etc/hosts
echo "andromeda" > /etc/hostname

echo "Restart some Services"
service bind9 start
service nginx start
service ssh reload
service smbd start
service transmission-daemon start
service syncserver start

echo "Restore finished, reboot advised"
