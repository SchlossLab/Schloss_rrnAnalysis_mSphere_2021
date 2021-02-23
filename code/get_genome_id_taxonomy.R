#!/usr/bin/env Rscript --vanilla

# name: get_genome_id_taxonomy.R
#
# input: 
# 	- data/raw/rrnDB-5.7.tsv
#		- data/references/sp_spp_lookup.tsv
#		- data/raw/rrnDB-5.7_pantaxa_stats_NCBI.tsv
# output: tsv containing the genome id along with taxonomic information
# 				data/references/genome_id_taxonomy.tsv

library(tidyverse)

merged <- read_delim("data/references/ncbi_merged_lookup.tsv", delim="|",
										 trim_ws=TRUE,
										 col_names=c("old_tax_id","new_tax_id", "blank")) %>%
	select(-blank)

	
metadata <- read_tsv("data/raw/rrnDB-5.7.tsv") %>%
		rename(genome_id = `Data source record id`, 
					 tax_id = `NCBI tax id`,
					 rdp = `RDP taxonomic lineage`,
					 scientific_name = `NCBI scientific name`
					 ) %>%
		filter(!is.na(rdp)) %>%
		select(genome_id, tax_id, scientific_name) %>% left_join(., merged, by=c("tax_id"="old_tax_id")) %>%
	mutate(tax_id = ifelse(!is.na(new_tax_id), new_tax_id, tax_id)) %>%
	select(-new_tax_id)

nodes <- read_delim("data/references/ncbi_nodes_lookup.tsv", delim="|",
						trim_ws=TRUE,
						 col_names=c("tax_id",
						 	"parent tax_id",
						 	"rank",
						 	"embl code", "division id", "inherited div flag", "genetic code id",
						 	"inherited GC  flag", "mitochondrial","inherited MGC flag",
						 	"GenBank hidden flag","hidden subtree root flag", "comments",
						 	"blank")
						 ) %>%
		rename(parent_tax_id = `parent tax_id`) %>%
		select(tax_id, parent_tax_id, rank)

names <- read_delim("data/references/ncbi_names_lookup.tsv", delim="|",
							trim_ws=TRUE,
							col_names=c("tax_id",
								"name_txt",
								"unique name",
								"name class",
								"blank")) %>%
					filter(`name class` == "scientific name") %>%
					select(tax_id, name_txt)


tree <- inner_join(nodes, metadata, by=c("tax_id"="tax_id")) %>%
	unite(tr_a, tax_id, rank, sep="_") %>%
	inner_join(nodes, ., by=c("tax_id" = "parent_tax_id")) %>%
	unite(tr_b, tax_id, rank, sep="_") %>%
	inner_join(nodes, ., by=c("tax_id" = "parent_tax_id")) %>%
	unite(tr_c, tax_id, rank, sep="_") %>%
	inner_join(nodes, ., by=c("tax_id" = "parent_tax_id")) %>%
	unite(tr_d, tax_id, rank, sep="_") %>%
	inner_join(nodes, ., by=c("tax_id" = "parent_tax_id")) %>%
	unite(tr_e, tax_id, rank, sep="_") %>%
	inner_join(nodes, ., by=c("tax_id" = "parent_tax_id")) %>%
	unite(tr_f, tax_id, rank, sep="_") %>%
	inner_join(nodes, ., by=c("tax_id" = "parent_tax_id")) %>%
	unite(tr_g, tax_id, rank, sep="_") %>%
	inner_join(nodes, ., by=c("tax_id" = "parent_tax_id")) %>%
	unite(tr_h, tax_id, rank, sep="_") %>%
	inner_join(nodes, ., by=c("tax_id" = "parent_tax_id")) %>%
	unite(tr_i, tax_id, rank, sep="_") %>%
	inner_join(nodes, ., by=c("tax_id" = "parent_tax_id")) %>%
	unite(tr_j, tax_id, rank, sep="_") %>%
	inner_join(nodes, ., by=c("tax_id" = "parent_tax_id")) %>%
	unite(tr_k, tax_id, rank, sep="_") %>%
	inner_join(nodes, ., by=c("tax_id" = "parent_tax_id")) %>%
	unite(tr_l, tax_id, rank, sep="_") %>%
	inner_join(nodes, ., by=c("tax_id" = "parent_tax_id")) %>%
	unite(tr_m, tax_id, rank, sep="_") 


test_a <- tree %>% count(parent_tax_id) %>% nrow
stopifnot(test_a == 1)

test_b <- anti_join(metadata, tree, by="genome_id") %>% nrow
stopifnot(test_b == 0)

tree %>%
	select(-parent_tax_id) %>%
	pivot_longer(cols=starts_with("tr_"), names_to="tr", values_to="id_rank") %>%
	select(-tr) %>%
	separate(id_rank, into=c("tax_id", "rank"), sep="_", convert=TRUE) %>%
	filter(rank %in% c("superkingdom", "phylum", "class", "order",
										 "family", "genus", "species")) %>%
	inner_join(., names, by="tax_id") %>%
	select(-tax_id) %>%
	pivot_wider(names_from=rank, values_from=name_txt) %>%
	rename(kingdom = superkingdom) %>%
	select(genome_id, scientific_name, kingdom, phylum, class,
				 order, family, genus, species) %>%
	write_tsv("data/references/genome_id_taxonomy.tsv")
