#!/usr/bin/env Rscript --vanilla

library(tidyverse)
source('code/colors.R')

read_tsv("data/processed/lumped_split_rate.tsv",
				 col_types = cols(region = col_character(),
				 								 .default = col_double())) %>%
	select(region, threshold, lump_rate) %>%
	ggplot(aes(x=threshold, y=lump_rate, color=region)) +
	geom_line(size=1) +
	scale_x_continuous(
		breaks = seq(0,0.1,0.02),
		labels = seq(0,10,2)
		) +
	scale_y_continuous(
		breaks = seq(0,0.5,0.1),
		labels = seq(0,50,10)
		) +
	custom_color_scale() +
	labs(
		x="Distance theshold\nused to define OTUs (%)",
		y="Percentage of ASVs or OTUs that included\nsequences from multiple species") +
	theme_classic() +
	theme(
		legend.position = c(0.8, 0.2),
		legend.key.height = unit(0.4, "cm")
	)

ggsave("figures/lump_split.tiff", height =5, width =5, compression="lzw")
ggsave("figures/lump_split.pdf", height =5, width =5)
