.SECONDEXPANSION:

REGIONS=v4 v34 v45 v19
THRESHOLDS= 0025 005 0075 01 0125 015 0175 02 0225 025 0275 03 0325 035 0375 04 0425 045 0475 05 0525 055 0575 06 0625 065 0675 07 0725 075 0775 08 0825 085 0875 09 0925 095 0975 10

print-% :
	@echo '$*=$($*)'

# Rule
# target : prerequisite1 prerequisite2 prerequisite3
#	(tab)recipe

code/mothur/mothur : code/install_mothur.sh
	code/install_mothur.sh

data/references/silva_seed/silva.seed_v138.align : code/get_silva_seed.sh
	code/get_silva_seed.sh

data/raw/rrnDB-5.7_16S_rRNA.fasta : code/get_rrndb_files.sh
	code/get_rrndb_files.sh $@

data/raw/rrnDB-5.7.tsv : code/get_rrndb_files.sh
	code/get_rrndb_files.sh $@

data/raw/rrnDB-5.7_pantaxa_stats_NCBI.tsv : code/get_rrndb_files.sh
	code/get_rrndb_files.sh $@

data/raw/rrnDB-5.7_pantaxa_stats_RDP.tsv : code/get_rrndb_files.sh
	code/get_rrndb_files.sh $@

data/references/ncbi_names_lookup.tsv data/references/ncbi_nodes_lookup.tsv : \
		code/get_ncbi_tax_lookup.sh
	code/get_ncbi_tax_lookup.sh

data/references/genome_id_taxonomy.tsv : code/get_genome_id_taxonomy.R\
		data/raw/rrnDB-5.7.tsv\
		data/references/ncbi_nodes_lookup.tsv\
		data/references/ncbi_names_lookup.tsv\
		data/references/ncbi_merged_lookup.tsv
	code/get_genome_id_taxonomy.R

data/raw/rrnDB-5.7_16S_rRNA.align : code/align_sequences.sh\
											data/references/silva_seed/silva.seed_v138.align\
											data/raw/rrnDB-5.7_16S_rRNA.fasta\
											code/mothur/mothur
	code/align_sequences.sh


data/%/rrnDB.align data/%/rrnDB.bad.accnos : code/extract_region.sh\
											data/raw/rrnDB-5.7_16S_rRNA.align\
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

data/processed/rrnDB.roc.tsv : code/get_roc_data.R\
		data/references/genome_id_taxonomy.tsv\
		data/processed/rrnDB.easv.count_tibble
	$^

data/processed/thresholds_for_single_otu.tsv : code/get_threshold_for_single_otu.R\
		data/references/genome_id_taxonomy.tsv\
		data/processed/rrnDB.easv.count_tibble
	$<

data/processed/lumped_split_rate.tsv : code/get_lump_split_rates.R\
		data/references/genome_id_taxonomy.tsv\
		data/processed/rrnDB.easv.count_tibble
	$<


README.md : README.Rmd
	R -e "library(rmarkdown); render('README.Rmd')"


exploratory/2020-12-21-roc-curve.md : exploratory/2020-12-21-roc-curve.Rmd\
		data/processed/rrnDB.roc.tsv
	R -e "library(rmarkdown); render('$<')"


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
		exploratory/2020-11-24-threshold-to-drop-n-asvs.md\
		exploratory/2020-11-30-lumping-and-splitting.md\
		exploratory/2020-12-21-roc-curve.md


figures/esv_rate.pdf figures/esv_rate.tiff : code/plot_esv_rate.R\
		data/references/genome_id_taxonomy.tsv\
		data/processed/rrnDB.easv.count_tibble
	./code/plot_esv_rate.R

figures/lump_split.pdf figures/lump_split.tiff: code/plot_lump_split.R\
		code/colors.R\
		data/processed/lumped_split_rate.tsv
	./code/plot_lump_split.R

figures/copy_number_threshold_plot.pdf figures/copy_number_threshold_plot.tiff: code/plot_copy_number_threshold.R\
		code/colors.R\
		data/processed/thresholds_for_single_otu.tsv
	./code/plot_copy_number_threshold.R

submission/figure_1.tiff : figures/copy_number_threshold_plot.tiff
	convert -compress lzw $< $@

submission/figure_2.tiff : figures/lump_split.tiff
	convert -compress lzw $< $@

submission/figure_s1.tiff : figures/esv_rate.tiff
	convert -compress lzw $< $@

submission/manuscript.pdf submission/manuscript.docx : submission/manuscript.Rmd\
		data/references/genome_id_taxonomy.tsv\
		data/processed/rrnDB.easv.count_tibble\
		data/processed/thresholds_for_single_otu.tsv\
		data/processed/lumped_split_rate.tsv\
		submission/figure_1.tiff\
		submission/figure_2.tiff\
		submission/figure_s1.tiff\
		figures/esv_rate.pdf\
		figures/lump_split.pdf\
		figures/copy_number_threshold_plot.pdf\
		submission/asm.csl\
		submission/references.bib
	R -e 'library(rmarkdown);render("submission/manuscript.Rmd", output_format="all")'
