#!/usr/bin/env Rscript --vanilla

# name: get_genome_id_taxonomy.R
#
# input: 
# 	- data/raw/rrnDB-5.6.tsv
#		- data/references/sp_spp_lookup.tsv
#		- data/raw/rrnDB-5.6_pantaxa_stats_NCBI.tsv
# output: tsv containing the genome id along with taxonomic information
# 				data/references/genome_id_taxonomy.tsv

library(tidyverse)


	
metadata <- read_tsv("data/raw/rrnDB-5.6.tsv") %>%
		rename(genome_id = `Data source record id`, 
					 subspecies_id = `NCBI tax id`,
					 rdp = `RDP taxonomic lineage`,
					 scientific_name = `NCBI scientific name`
					 ) %>%
		select(genome_id, subspecies_id, rdp, scientific_name)

sp_spp_lookup <- read_tsv("data/references/sp_spp_lookup.tsv",
				 col_names=c("domain", "species_id", "subspecies_id"))

makeup_tax <- tibble(
	taxid = c(299583, 328813, 412965, 693153),
	species = c("Francisella orientalis", "Alistipes onderdonkii",
							"Candidatus Vesicomyosocius okutanii", "Vibrio atlanticus"))

tax <- read_tsv("data/raw/rrnDB-5.6_pantaxa_stats_NCBI.tsv") %>%
	filter(rank == "species") %>%
	rename(species = name) %>%
	select(taxid, species) %>%
	bind_rows(., makeup_tax)

test <- inner_join(metadata, sp_spp_lookup, by="subspecies_id") %>%
	select(genome_id, rdp, scientific_name, species_id) %>%
	anti_join(., tax, by=c("species_id" = "taxid")) %>%
	count(species_id) %>%
	nrow(.) == 0

stopifnot(test)


inner_join(metadata, sp_spp_lookup, by="subspecies_id") %>%
	select(genome_id, rdp, scientific_name, species_id) %>%
	inner_join(., tax, by=c("species_id" = "taxid")) %>%
	select(genome_id, rdp, species, scientific_name) %>% 
	write_tsv("data/references/genome_id_taxonomy.tsv")
	
