#!/usr/bin/env Rscript --vanilla

# name: combine_count_tibble_files.R
#
# input: tidy versions of count_files for each region
# output: composite tidy count file with a column to designate the region
# note: the input file names need to be 'data/<region>/rrnDB.count_tibble'


library(tidyverse)

tibble_files <- commandArgs(trailingOnly=TRUE)

names(tibble_files) <- str_replace(string=tibble_files,
																	 pattern="data/(.*)/rrnDB.count_tibble",
																	 replacement="\\1")

map_dfr(.x=tibble_files, .f=read_tsv, .id="region", col_types="ccd") %>%
	write_tsv("data/processed/rrnDB.count_tibble")
