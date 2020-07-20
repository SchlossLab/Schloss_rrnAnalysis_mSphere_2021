#!/usr/bin/env bash

# author: Pat Schloss
# inputs: Name of the file extracted from the archive (without the path)
# outputs: The appropriate rrnDB file into data/raw/
#
#

archive=$1

wget -P data/raw/ -nc https://rrndb.umms.med.umich.edu/static/download/"$archive".zip
unzip -n -d data/raw/ data/raw/"$archive".zip
