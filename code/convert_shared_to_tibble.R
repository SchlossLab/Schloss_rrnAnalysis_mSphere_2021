#!/usr/bin/env Rscript --vanilla

# file: convert_shared_to_tibble.R
# input: shared file generated in mothur
# output: tidy version of shared file

library(tidyverse)
library(data.table)

args <- commandArgs(trailingOnly=TRUE)

input_file <- args[1]
output_file <- args[2]

# read_tsv(input_file) %>%
# 	select(-label, -numOtus) %>%
# 	rename(genome = Group) %>%
# 	pivot_longer(-genome, names_to="asv", values_to="count") %>%
# 	filter(count != 0) %>%
#		write_tsv(output_file)


fread(input_file, drop=c("label", "numOtus")) %>%
	setnames("Group", "genome") %>%
	melt(id.vars="genome", variable.name="asv", value.name="count") %>%
	.[count != 0] %>%
	write_tsv(output_file)
