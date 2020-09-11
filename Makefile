# Rule
# target : prerequisite1 prerequisite2 prerequisite3
#	(tab)recipe

code/mothur/mothur : code/install_mothur.sh
	code/install_mothur.sh

data/references/silva_seed/silva.seed_v138.align : code/get_silva_seed.sh
	code/get_silva_seed.sh

data/raw/rrnDB-5.6_16S_rRNA.fasta : code/get_rrndb_files.sh
	code/get_rrndb_files.sh $@

data/raw/rrnDB-5.6.tsv : code/get_rrndb_files.sh
	code/get_rrndb_files.sh $@

data/raw/rrnDB-5.6_pantaxa_stats_NCBI.tsv : code/get_rrndb_files.sh
	code/get_rrndb_files.sh $@

data/raw/rrnDB-5.6_pantaxa_stats_RDP.tsv : code/get_rrndb_files.sh
	code/get_rrndb_files.sh $@

data/raw/rrnDB-5.6_16S_rRNA.align : code/align_sequences.sh\
											data/references/silva_seed/silva.seed_v138.align\
											data/raw/rrnDB-5.6_16S_rRNA.fasta\
											code/mothur/mothur
	code/align_sequences.sh


data/%/rrnDB.align data/%/rrnDB.bad.accnos : code/extract_region.sh\
											data/raw/rrnDB-5.6_16S_rRNA.align\
											code/mothur/mothur
	code/extract_region.sh $@


data/%/rrnDB.unique.align data/%/rrnDB.count_tibble : code/count_unique_seqs.sh\
											code/convert_count_table_to_tibble.R\
											data/%/rrnDB.align\
											code/mothur/mothur
	code/count_unique_seqs.sh $@


README.md : README.Rmd
	R -e "library(rmarkdown); render('README.Rmd')"



exploratory/2020-09-09-genome-sens-spec.md : exploratory/2020-09-09-genome-sens-spec.Rmd\
		data/v19/rrnDB.count_tibble data/v4/rrnDB.count_tibble
	R -e "library(rmarkdown); render('exploratory/2020-09-09-genome-sens-spec.Rmd')"
