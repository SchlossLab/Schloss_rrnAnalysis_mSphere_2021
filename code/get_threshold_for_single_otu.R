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


get_threshold_for_single_otu <- function(prob = 0.95){

		metadata %>%
		group_by(species) %>% # Get one genome per species
		slice_sample(n=1) %>%
		ungroup() %>%
		inner_join(., asv, by=c("genome_id" = "genome")) %>%
		group_by(region, threshold, genome_id) %>%
		summarize(n_rrns = sum(count), n_easvs = n(), .groups="drop") %>%
		group_by(region, threshold, n_rrns) %>%
		summarize(upper_bound = quantile(n_easvs, prob=prob),
							n_genomes = n(),
							.groups="drop") %>%
		filter(upper_bound == 1) %>%
		group_by(region, n_rrns) %>%
		summarize(threshold = min(threshold), n_genomes = median(n_genomes), .groups="drop")

}

plan(multicore)

future_map_dfr(1:100,
				~get_threshold_for_single_otu(),
				.options = furrr_options(seed = 19760620)
				) %>%
	group_by(region, n_rrns) %>%
	summarize(threshold = median(threshold),
						iqr = IQR(threshold),
						n_genomes = median(n_genomes),
						.groups="drop") %>%
	write_tsv("data/processed/thresholds_for_single_otu.tsv")		
