#!/usr/bin/env bash

make_dir() {
	if [ ! -d $1 ]
	then
	  mkdir $1
	fi
}

#"a" for apply and "s" for save
apply_or_create_metadata() {
	METASTORE_FILE="$SCRIPT_HOME/metastore_file"
	if [ -f $METASTORE_FILE ] && ["$1" -eq "s"]
	then
		rm $METASTORE_FILE
	fi
	cd $SCRIPT_HOME

	#apply metastore rights
	./metastore -$1 -f metastore_file
}

# Stop Services defined in SERVICES_TO_STOP
start_stop_services() {
	for s in "${SERVICES_TO_STOP[@]}"
	do
	  service $s $1
	done
}
