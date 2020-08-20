#!/usr/bin/env Rscript --vanilla

# name: convert_count_table_to_tibble.R
#
# input: mothur-formatted count file
# output: tidy data frame with asv, genome, count as columns
# note: we expect input to be in order of input , output



library(tidyverse)

args <- commandArgs(trailingOnly=TRUE)

input_file <- args[1]
output_file <- args[2]

read_tsv(input_file) %>%
	rename(asv=Representative_Sequence) %>%
	select(-total) %>%
	pivot_longer(cols=-asv, names_to="genome", values_to="count") %>%
	filter(count != 0) %>%
	write_tsv(output_file)
