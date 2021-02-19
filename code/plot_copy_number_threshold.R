#!/usr/bin/env Rscript --vanilla

library(tidyverse)
library(ggtext)
source("code/colors.R")

read_tsv("data/processed/thresholds_for_single_otu.tsv") %>%
	filter(n_genomes > 100) %>%
	ggplot(aes(x=n_rrns, y=threshold, color=region)) +
	geom_line(size=1) +
	custom_color_scale() +
	scale_x_continuous(breaks=seq(1,9,2), labels=seq(1,9,2)) +
	scale_y_continuous(breaks=seq(0,0.06,0.02), labels=seq(0,6,2), limits =c(0,0.06)) +
	labs(x="Number of copies of *rrn* operon",
			 y="Distance threshold where ASVs from\n95% of species had one OTU (%)") +
	theme_classic() +
	theme(
		legend.position = c(0.8, 0.2),
		legend.key.height = unit(0.4, "cm"),
		axis.title.x = element_markdown(),
		axis.title.y = element_text(margin=margin(t=0, r=10, b=0, l=0))
	)

ggsave("figures/copy_number_threshold_plot.pdf", width=5, height=5)
ggsave("figures/copy_number_threshold_plot.tiff", width=5, height=5)
