#!/usr/bin/env Rscript --vanilla

library(tidyverse)
library(knitr)
library(here)

metadata <- read_tsv(here("data/references/genome_id_taxonomy.tsv"),
										 col_types = cols(.default = col_character())) %>%
	mutate(strain = if_else(scientific_name == species,
													NA_character_,
													scientific_name)) %>%
	select(-scientific_name)

esv <- read_tsv(here("data/processed/rrnDB.easv.count_tibble"),
								col_types = cols(.default = col_character(),
																 count = col_integer())) %>%
	filter(threshold == "esv") %>%
	select(-threshold)

metadata_esv <- inner_join(metadata, esv, by=c("genome_id" = "genome"))

region_labels <- c("V1-V9", "V4", "V3-V4", "V4-V5")
names(region_labels) <- c("v19", "v4", "v34", "v45")

species_esvs <- metadata_esv %>%
	select(genome_id, species, region, easv, count) %>%
	group_by(region, species) %>%
	summarize(n_genomes = n_distinct(genome_id),
						n_esvs = n_distinct(easv),
						n_rrns = sum(count) / n_genomes,
						esv_rate = n_esvs/n_rrns,
						.groups="drop") %>%
	mutate(region = region_labels[region])

facet_label <- species_esvs %>%
	distinct(region) %>%
	mutate(x = 1, y=100)
	

species_esvs %>%
	ggplot(aes(x=n_genomes, y=esv_rate)) +
	geom_point(alpha=0.2) +
	geom_smooth(se=FALSE) +
	geom_text(data=facet_label, aes(label=region, x=x, y=y), hjust=0, fontface=2) +
	facet_wrap(facet="region",
						 nrow=4,
						 strip.position = "top",
						 scales="fixed",
						 labeller=labeller(region = region_labels)) +
	scale_x_log10()+
	scale_y_log10(breaks=c(0.1, 1, 10, 100), labels = c("0.1", "1", "10", "100")) +
	labs(x="Number of genomes",
			 y="Number of ASVs per rrn copy") +
	theme_classic() +
	theme(
		strip.text = element_blank()
	)

ggsave("figures/esv_rate.tiff", width=3.5, height=8, compression="lzw")
ggsave("figures/esv_rate.pdf", width=3.5, height=8)
