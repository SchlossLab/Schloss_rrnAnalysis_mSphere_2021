# README

Obtained files from the [rrnDB](https://rrndb.umms.med.umich.edu/static/download/), version 5.6, released in 2019

We automated downloading and extracting the rrnDB files with wget and unzip

```
wget -P data/raw/ -nc https://rrndb.umms.med.umich.edu/static/download/rrnDB-5.6.tsv.zip
unzip -n -d data/raw/ data/raw/rrnDB-5.6.tsv.zip

wget -nc -P data/raw/ https://rrndb.umms.med.umich.edu/static/download/rrnDB-5.6_16S_rRNA.fasta.zip
unzip -n -d data/raw/ data/raw/rrnDB-5.6_16S_rRNA.fasta.zip

wget -nc -P data/raw/ https://rrndb.umms.med.umich.edu/static/download/rrnDB-5.6_pantaxa_stats_NCBI.tsv.zip
unzip -n -d data/raw/ data/raw/rrnDB-5.6_pantaxa_stats_NCBI.tsv.zip

wget -nc -P data/raw/ https://rrndb.umms.med.umich.edu/static/download/rrnDB-5.6_pantaxa_stats_RDP.tsv.zip
unzip -n -d data/raw/ data/raw/rrnDB-5.6_pantaxa_stats_RDP.tsv.zip
```
