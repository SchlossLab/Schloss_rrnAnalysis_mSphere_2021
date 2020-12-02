#!/usr/bin/env Rscript --vanilla

# name: get_roc_data.R
#
# Trade off analysis of ASV threshold impact on lumping and splitting taxa
#
# input:
# 	- data/processed/rrnDB.easv.count_tibble
# output:
#   - data/processed/rrnDB.roc.tsv
#
# Generate a confusion matrix, visualization, and associated statistics (e.g.
# sensitivity, specificity, Matthew's correlation coefficient) for each
# threshold and region represented in the pooled count_tibble file. Will
# look at the trade-off between thresholds and risk of splitting a single
# genome or species into multiple bins and the risk of merging species into
# a single E/ASV. Let's think of it as a classification problem.
#
# Confusion matrix...
# * same taxa, same easv = true positive
# * different taxa, different easv = true negative
# * different taxa, same easv = false positive (merging different taxa)
# * same taxa, different easv = false negative (splitting single taxa)
#
# Could then look at measures of sensitivity and specificity, plot receiver
# operator characteristic curve over thresholds, and calculate Matthew's
# correlation coefficient for each threshold
#
# To calculate confusion matrix, we need to create a data frame that
# provides an all vs. all comparison for each operon retaining the genome_id
# and easv for each operon. We could then easily compare across columns
# whether all possible pairs of easvs represent each cell of the confusion
# matrix. Because some taxa are over represented, we would
# need to grab representative genomes from each taxa, calculate metrics and
# repeat a decent number of times.
#
# Considerations...
# * May need to generate data for additional thresholds depending on shape of
#   curves
# * Might be ideal to look into how to parallelize steps to speed things up

library(tidyverse)
library(Rcpp)

set.seed(19760620)

desired_threshold <- 0.01
desired_region <- "v4"

# Plan of attack...
# 1. Read in easvs and subset to get separate *region* and easv *threshold*
#    combinations

easv <- read_tsv("data/processed/rrnDB.easv.count_tibble",
								 col_types = cols(.default = col_character(),
								 								 count = col_integer())) %>%
	mutate(threshold = recode(threshold, "esv" = "0.000"),
				 threshold = as.numeric(threshold)) %>%
	filter(threshold == desired_threshold & region == desired_region) %>%
	select(easv, genome, count)


# 2. Read in metadata and sub-sample to get 1 genome per species so that we have
#    the genome_id, easv, and count columns for each taxon

metadata <- read_tsv("data/references/genome_id_taxonomy.tsv",
										 col_types = cols(.default = col_character())) %>%
	select(genome_id, species) %>%
	group_by(species) %>% # Get one genome per species
	slice_sample(n=1) %>%
	ungroup()


# 3. Generate data frame that contains separate rows for each operon in the
#		 dataset by replicating each genome_id/easv row count times

metadata_easv <- inner_join(metadata, easv, by=c("genome_id" = "genome")) %>%
	uncount(count) %>%
	select(-species)


# 4. Create a data frame that compares each operon to every other operon

cppFunction('DataFrame get_confusion_matrix(DataFrame genomes_easvs){

						CharacterVector genomes = genomes_easvs[0];
						CharacterVector easvs = genomes_easvs[1];
						
						int n_operons = genomes.length();
						
						int tp = 0;
						int fp = 0;
						int tn = 0;
						int fn = 0;
						bool same_genome, same_easv;
						
						for(int i=0;i<(n_operons-1);i++){
							for(int j=1;j<n_operons;j++){

								same_genome = genomes[i] == genomes[j];
								same_easv = easvs[i] == easvs[j];
							
									if(same_genome & same_easv) 			{ tp++; }
									else if(!same_genome & !same_easv){ tn++; }
									else if(same_genome & !same_easv) { fn++;	}
									else if(!same_genome & same_easv) { fp++; }
							}
						}
						
						DataFrame confusion = DataFrame::create(Named("tp") = tp, Named("fp") = fp, Named("tn") = tn, Named("fn") = fn);
						return(confusion);
				}')


# 5. Store the confusion matrix and associated statistics for each iteration,
#    region, and easv
#
# Confusion matrix...
# * same taxa, same easv = true positive
# * different taxa, different easv = true negative
# * different taxa, same easv = false positive (merging different taxa)
# * same taxa, different easv = false negative (splitting single taxa)

confusion_matrix <- get_confusion_matrix(metadata_easv) %>%
	summarize(
		true_pos = sum(tp),
		true_neg = sum(tn),
		false_neg = sum(fn),
		false_pos = sum(fp)
	) %>%
	mutate(region = desired_region,
				 threshold = desired_threshold,
				 sensitivity = true_pos / (true_pos + false_neg),
				 specificity = true_neg / (true_neg + false_pos)) %>%
	select(region, threshold, everything())


# 6. Plot...
#    * ROC (true positive rate vs false positive rate) for each region and find
#      threshold that gives optimal TPR/FPR
#    * Sensitivity/Specificity/Accuracy/MCC against thresholds for each region
