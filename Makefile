.SECONDARY:
.SECONDEXPANSION:

REGIONS=v4 v34 v45 v19
THRESHOLDS=001 002 003 004 005 008 01 015 02 025 03 04 05

print-% :
	@echo '$*=$($*)'

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

data/references/ncbi_names_lookup.tsv data/references/ncbi_nodes_lookup.tsv : \
		code/get_ncbi_tax_lookup.sh
	code/get_ncbi_tax_lookup.sh

data/references/genome_id_taxonomy.tsv : code/get_genome_id_taxonomy.R\
		data/raw/rrnDB-5.6.tsv\
		data/references/ncbi_nodes_lookup.tsv\
		data/references/ncbi_names_lookup.tsv\
		data/references/ncbi_merged_lookup.tsv
	code/get_genome_id_taxonomy.R

data/raw/rrnDB-5.6_16S_rRNA.align : code/align_sequences.sh\
											data/references/silva_seed/silva.seed_v138.align\
											data/raw/rrnDB-5.6_16S_rRNA.fasta\
											code/mothur/mothur
	code/align_sequences.sh


data/%/rrnDB.align data/%/rrnDB.bad.accnos : code/extract_region.sh\
											data/raw/rrnDB-5.6_16S_rRNA.align\
											code/mothur/mothur
	code/extract_region.sh $@


data/%/rrnDB.unique.align data/%/rrnDB.count_table : code/get_unique_seqs.sh\
											data/%/rrnDB.align\
											code/mothur/mothur
	$< $@


ESV_TIBBLES=$(foreach R,$(REGIONS),data/$(R)/rrnDB.esv.count_tibble)

$(ESV_TIBBLES) : code/get_esvs.R\
		$$(dir $$@)rrnDB.count_table
	$^ $@


data/%/rrnDB.unique.dist : code/get_distances.sh data/%/rrnDB.unique.align\
		code/mothur/mothur
	$< $@

ASV_TIBBLES=$(foreach R,$(REGIONS),$(foreach T,$(THRESHOLDS),data/$(R)/rrnDB.$T.count_tibble))

$(ASV_TIBBLES) : code/get_asvs.sh code/convert_shared_to_tibble.R\
		$$(dir $$@)rrnDB.unique.dist $$(dir $$@)rrnDB.count_table\
		code/mothur/mothur
	$< $@

EASV_TIBBLES=$(ESV_TIBBLES) $(ASV_TIBBLES)

data/processed/rrnDB.easv.count_tibble : code/combine_count_tibble_files.R\
		$(EASV_TIBBLES)
	$^


README.md : README.Rmd
	R -e "library(rmarkdown); render('README.Rmd')"

%.md : %.Rmd\
		data/references/genome_id_taxonomy.tsv\
		data/processed/rrnDB.easv.count_tibble
	R -e "library(rmarkdown); render('$<')"


.PHONY:
exploratory : \
		exploratory/2020-09-09-genome-sens-spec.md\
		exploratory/2020-09-29-taxa-representation.md\
		exploratory/2020-10-05-rrn-copy-number.md\
		exploratory/2020-10-15-esv-species-coverage.md\
		exploratory/2020-10-21-esv-taxa-overlap.md\
		exploratory/2020-11-02-dominance-commonness-of-esvs.md\
		exploratory/2020-11-24-threshold-to-drop-n-asvs.md
