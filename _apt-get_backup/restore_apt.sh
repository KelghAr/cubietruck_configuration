#!/bin/bash

if [ $(id -u) != "0" ]
then
echo "Please use sudo"
return 1
fi

SCRIPT_HOME=`readlink -f $0`
SCRIPT_HOME=$(dirname $SCRIPT_HOME)
cd $SCRIPT_HOME

apt-key add $SCRIPT_HOME/apt.keys
apt-get update
apt-get install dselect
dselect update
dpkg --set-selections < $SCRIPT_HOME/installed_packages.list
apt-get dselect-upgrade -y
