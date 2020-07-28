#!/usr/bin/env bash

# author: Pat Schloss
# inputs: Name of the file extracted from the archive (without the path)
# outputs: The appropriate rrnDB file into data/raw/
#
#

target=$1

filename=`echo $target | sed "s/.*\///"`
path=`echo $target | sed -E "s/(.*\/).*/\1/"`

wget -P "$path" -nc https://rrndb.umms.med.umich.edu/static/download/"$filename".zip
unzip -n -d "$path" "$target".zip

if [[ $? -eq 0 ]]
then
	touch "$target"
else
	echo "FAIL: were not able to successfully extract $filename"
fi
