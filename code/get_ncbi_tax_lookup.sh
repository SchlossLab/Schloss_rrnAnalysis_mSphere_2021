#!/usr/bin/env bash

# author: Pat Schloss
# inputs:
# outputs: data/references/ncbi_names_lookup.tsv
#			data/references/ncbi_nodes_lookup.tsv
#			data/references/ncbi_merged_lookup.tsv
#

wget -P data/references/ -nc https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdmp.zip
unzip -n -d data/references/ data/references/taxdmp.zip

if [[ $? -eq 0 ]]
then
	mv data/references/names.dmp data/references/ncbi_names_lookup.tsv
  mv data/references/nodes.dmp data/references/ncbi_nodes_lookup.tsv
	mv data/references/merged.dmp data/references/ncbi_merged_lookup.tsv
	touch data/references/ncbi_*_lookup.tsv
	rm data/references/*dmp
else
	echo "FAIL: were not able to successfully extract $filename"
fi
