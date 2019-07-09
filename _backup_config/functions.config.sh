#!/usr/bin/env bash

make_dir() {
	if [ ! -d $1 ]
	then
	  mkdir $1
	fi
}

# Stop Services defined in SERVICES_TO_STOP
start_stop_services() {
	for s in "${SERVICES_TO_STOP[@]}"
	do
	  service $s $1
	done
}
