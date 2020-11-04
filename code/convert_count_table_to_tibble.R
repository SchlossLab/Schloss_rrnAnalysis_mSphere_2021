#!/usr/bin/env Rscript --vanilla

# name: convert_count_table_to_tibble.R
#
# input: mothur-formatted count file
# output: tidy data frame with esv, genome, count as columns
# note: we expect input to be in order of input , output

library(tidyverse)
library(data.table)

args <- commandArgs(trailingOnly=TRUE)

input_file <- args[1]
output_file <- args[2]

fread(input_file) %>%
	rename(esv=Representative_Sequence) %>%
	select(-total) %>%
	melt(id.vars="esv", variable.name="genome", value.name="count") %>%
	filter(count != 0) %>%
	write_tsv(output_file)
