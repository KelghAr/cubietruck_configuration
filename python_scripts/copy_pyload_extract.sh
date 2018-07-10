#!/bin/bash
targetPath="/home/kelghar/mount_point/share/pyload"
if [ -e "$targetPath/pyload_extract.py" ]
then
    echo "move file to bak"
    mv "$targetPath/pyload_extract.py" "$targetPath/pyload_extract.py.bak"
fi
echo "copy file"
cp "pyload_extract.py" "$targetPath/pyload_extract.py"
