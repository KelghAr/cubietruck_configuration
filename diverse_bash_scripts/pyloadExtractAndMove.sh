#!/bin/sh

if [ -z "$1" ];
then
echo "Please add password!"
return 1
fi

EXTRACT_DIR="./extracted"
RM_FILE=$EXTRACT_DIR/"remove.py"
PASSWORD=$1

if [ ! -d $EXTRACT_DIR ]; then
mkdir $EXTRACT_DIR
fi

if [ ! -e $RM_FILE ]; then
touch $RM_FILE
echo 'import sys' > $RM_FILE
echo 'from send2trash import send2trash' >> $RM_FILE
echo 'send2trash(sys.argv[1])' >> $RM_FILE
fi

RM_FILE=$(realpath $RM_FILE)

find . -regex '.*part0*1.rar' -not -path './jj/*' -exec 7z e '-x!**/*.nfo' '-x!**/*sample*' -o$EXTRACT_DIR -p$PASSWORD {} \;

find . -regex '.*part.*rar' -not -path './jj/*' -execdir python $RM_FILE $(basename {}) \;
find . -depth -empty -type d -exec rmdir "{}" \;

rm $RM_FILE
