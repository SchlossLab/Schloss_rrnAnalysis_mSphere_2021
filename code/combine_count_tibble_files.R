#!/usr/bin/env Rscript --vanilla

# name: combine_count_tibble_files.R
#
# input: tidy versions of count_files for each region
# output: composite tidy count file with a column to designate the region
# note: the input file names need to be 'data/<region>/rrnDB.count_tibble'


library(tidyverse)

# rename_function <- function(x){
# 	"easv"
# }

read_count_tibble <- function(count_tibble_file){

	region <- str_replace(string=count_tibble_file,
											 pattern="data/(.*)/rrnDB\\..*\\.count_tibble",
											 replacement="\\1")

	type <- if_else(str_detect(count_tibble_file, "esv"), "esv", "asv")

	threshold <- if_else(type == "esv", "esv",
											 str_replace(string=count_tibble_file,
													pattern="data/.*/rrnDB\\.(.*)\\.count_tibble",
													replacement="0.\\1"))

	# rename asv or esv to be easv for column name
	read_tsv(count_tibble_file, col_types="ccd") %>%
		mutate(region = region,
					 threshold = threshold) %>%
		rename_with(function(x){"easv"}, ends_with("sv"))


}


tibble_files <- commandArgs(trailingOnly=TRUE)


map_dfr(.x=tibble_files, .f=read_count_tibble) %>%
	write_tsv("data/processed/rrnDB.easv.count_tibble")
