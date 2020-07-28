#!/usr/bin/env bash

# author: Pat Schloss
# input: none
# outputs: mothur installed in code/mothur
#
# The zip archive contains a director called "mothur" so we can extract it directly
# to code/

wget -P code/mothur/ -nc https://github.com/mothur/mothur/releases/download/v1.44.2/Mothur.OSX-10.14.zip
unzip -n -d code/ code/mothur/Mothur.OSX-10.14.zip

if [[ $? -eq 0 ]]
then
	touch code/mothur/mothur
else
	echo "FAIL: were not able to successfully install mothur"
fi
