#!/usr/bin/env Rscript --vanilla

library(tidyverse)
library(here)
library(knitr)

sensitivity_specificity <- read_tsv(here("data/processed/rrnDB.roc.tsv"),
																		col_types = cols(.default = col_double(),
																										 region = col_character()
																		)) %>%
	mutate(sensitivity = true_pos / (true_pos + false_neg),
				 specificity = true_neg / (true_neg + false_pos)) %>%
	group_by(region, threshold) %>%
	summarize(sensitivity = median(sensitivity),
						specificity = median(specificity),
						.groups="drop") %>%
	select(region, threshold, sensitivity, specificity)


three <- sensitivity_specificity %>%
	filter(threshold == 0.03) %>%
	select(region, sensitivity, specificity)


balance <- sensitivity_specificity %>%
	mutate(diff=abs(sensitivity - specificity)) %>%
	group_by(region) %>%
	summarize(min_diff = min(diff),
						threshold = threshold[which.min(diff)],
						sensitivity = sensitivity[which.min(diff)],
						specificity = specificity[which.min(diff)],
						.groups="drop"
	) %>%
	select(region, sensitivity, specificity)

distance <- sensitivity_specificity %>%
	mutate(distance = sqrt((specificity - 1)^2 + (sensitivity - 1)^2)) %>%
	group_by(region) %>%
	summarize(min_distance = min(distance),
						threshold = threshold[which.min(distance)],
						sensitivity = sensitivity[which.min(distance)],
						specificity = specificity[which.min(distance)],
						.groups="drop"
	) %>%
	select(region, sensitivity, specificity)

annotation <- bind_rows(three = three, balance=balance, distance=distance,
												.id="method") %>%
	mutate(xend = case_when(method == "three" ~ 0.015,
													method == "balance" ~ 0.04,
													method == "distance" ~ 0.025),
				 yend = case_when(method == "three" ~ 0.925,
	 											method == "balance" ~ 0.975,
	 											method == "distance" ~ 0.950),
				 pretty = case_when(method == "three" ~ "3% distance\nthreshold",
				 								 method == "balance" ~ "Equal sensitivity &\nspecificity",
				 								 method == "distance" ~ "Closest to optimal\nclassification")
	)



sensitivity_specificity %>%
	ggplot(aes(x=1-specificity, y=sensitivity, color=region)) + 
	geom_abline(intercept=1, slope=-1, color="gray") +
	geom_line() +
	geom_segment(data=annotation, aes(x=1-specificity, y=sensitivity, xend=xend, yend=yend)) +
	geom_label(data=annotation, aes(label=pretty, x=xend, y=yend), color="black") +
	coord_cartesian(ylim=c(0.9, 1)) +
	scale_color_manual(name = NULL,
										 breaks = c("v19", "v34", "v4", "v45"),
										 values = c("black", "blue", "green", "red"),
										 labels = c("V1-V9", "V3-V4", "V4", "V4-V5")) +
		labs(x="1-Specificity", y="Sensitivity") +
	theme_classic() +
	theme(
		legend.position = c(0.9, 0.2),
		legend.key.size = unit(0.4, "cm")
	)

ggsave("figures/roc_curve.tiff", width=6, height=6, compression="lzw")
ggsave("figures/roc_curve.pdf", width=6, height=6)
