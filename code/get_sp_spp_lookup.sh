#!/usr/bin/env bash

# author: Pat Schloss
# inputs:
# outputs: data/references/sp_spp_lookup.tsv
#
#

wget -P data/references/ -nc https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxcat.zip
unzip -n -d data/references/ data/references/taxcat.zip

if [[ $? -eq 0 ]]
then
	mv data/references/categories.dmp data/references/sp_spp_lookup.tsv
else
	echo "FAIL: were not able to successfully extract $filename"
fi
