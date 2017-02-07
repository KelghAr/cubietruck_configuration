#!/bin/bash

if [ $(id -u) != "0" ]
then
echo "Please use sudo"
return 1
fi

SCRIPT_HOME=`readlink -f $0`
SCRIPT_HOME=$(dirname $SCRIPT_HOME)
cd $SCRIPT_HOME

rm $SCRIPT_HOME/apt.keys
rm $SCRIPT_HOME/installed_packages.list
dpkg --get-selections > $SCRIPT_HOME/installed_packages.list
apt-key exportall > $SCRIPT_HOME/apt.keys

