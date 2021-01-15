#!/usr/bin/env Rscript --vanilla


library(tidyverse)
library(furrr)

metadata <- read_tsv("data/references/genome_id_taxonomy.tsv",
										 col_types = cols(.default = col_character())) %>%
	select(genome_id, species)

asv <- read_tsv("data/processed/rrnDB.easv.count_tibble",
								 col_types = cols(.default = col_character(),
								 								 count = col_integer())) %>%
	mutate(threshold = recode(threshold, "esv" = "0.000"),
				 threshold = as.numeric(threshold))


get_rate_of_splitting <- function(){
	
	metadata %>% 
		group_by(species) %>% # Get one genome per species
		slice_sample(n=1) %>%
		ungroup() %>%
		inner_join(., asv, by=c("genome_id" = "genome")) %>%
		group_by(region, threshold, genome_id) %>%
		summarize(n_asvs = n_distinct(easv),
							is_split = n_asvs > 1, .groups="drop") %>%
		group_by(region, threshold) %>%
		summarize(f_split = sum(is_split) / n(), .groups="drop")
}

get_rate_of_lumping <- function(){
	
	metadata %>% 
		group_by(species) %>% # Get one genome per species
		slice_sample(n=1) %>%
		ungroup() %>%
		inner_join(., asv, by=c("genome_id" = "genome")) %>%
		group_by(region, threshold, easv) %>%
		summarize(n_genomes = n_distinct(genome_id),
							is_lumped = n_genomes > 1, .groups="drop")  %>%
		group_by(region, threshold) %>%
		summarize(f_lumped = sum(is_lumped)/n(), .groups="drop")
}

plan(multicore)

rate_of_splitting <- future_map_dfr(1:100,
																		~get_rate_of_splitting(),
																		.options = furrr_options(seed = 19760620)
																		) %>%
	group_by(region, threshold) %>%
	summarize(split_rate = median(f_split), split_iqr = IQR(f_split), .groups="drop")


rate_of_lumping <- future_map_dfr(1:100,
																	~get_rate_of_lumping(),
																	.options = furrr_options(seed = 19760620)
																	) %>%
	group_by(region, threshold) %>%
	summarize(lump_rate = median(f_lumped), lump_iqr = IQR(f_lumped), .groups="drop")


inner_join(rate_of_splitting, rate_of_lumping,
					 by=c("region", "threshold")) %>%
	write_tsv("data/processed/lumped_split_rate.tsv")


