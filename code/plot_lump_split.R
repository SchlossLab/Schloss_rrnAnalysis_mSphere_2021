#!/usr/bin/env Rscript --vanilla

library(tidyverse)
source('code/colors.R')

read_tsv("data/processed/lumped_split_rate.tsv",
				 col_types = cols(region = col_character(),
				 								 .default = col_double())) %>%
	select(-ends_with("iqr")) %>%
	pivot_longer(cols=c(split_rate, lump_rate), names_to="method", values_to="fraction") %>%
	mutate(method = factor(ifelse(method == "lump_rate",
												 "Fraction of ASVs or OTUs\nthat included sequences\nfrom multiple species",
												 "Fraction of genomes\nsplit into separate OTUs"),
											 levels=c("Fraction of genomes\nsplit into separate OTUs",
											 "Fraction of ASVs or OTUs\nthat included sequences\nfrom multiple species")
									 )
								 ) %>%
	ggplot(aes(x=threshold, y=fraction, color=region)) +
	geom_line(size=1) +
	facet_wrap(~method, nrow=2, strip.position = "left") +
	scale_x_continuous(
		breaks = c(0, 0.025, 0.05, 0.075, 0.1),
		labels=c("0", "2.5", "5", "7.5", "10")
		) +
	custom_color_scale() +
	labs(x="Distance theshold\nused to define OTUs (%)", y=NULL) +
	theme_classic() +
	theme(
		strip.placement="outside",
		strip.background =element_rect(color=NA),
		strip.text = element_text(size=11),
		legend.position = c(0.8, 0.9),
		legend.key.height = unit(0.4, "cm")
	)

ggsave("figures/lump_split.tiff", height =5, width =4, compression="lzw")
ggsave("figures/lump_split.pdf", height =5, width =4)
