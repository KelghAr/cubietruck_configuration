#!/bin/bash

NEW_USER='selfoss_user'
NEW_PASSWORD='selfoss_password'
NEW_DATABASE='selfoss_database'

mysql -uroot -p -e "create database $NEW_DATABASE;"
mysql -uroot -p -e "create user '$NEW_USER'@'localhost' identified by '$NEW_PASSWORD';"
mysql -uroot -p -e "grant all privileges on $NEW_DATABASE.* to '$NEW_USER'@'localhost';"
mysql -uroot -p -e "FLUSH PRIVILEGES;"

