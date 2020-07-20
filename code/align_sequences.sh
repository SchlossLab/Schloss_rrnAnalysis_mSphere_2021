#!/usr/bin/env bash

# author: pat schloss
# inputs: data/raw/rrnDB-5.6_16S_rRNA.fasta
#					data/references/silva_seed/silva.seed_v138.align
# outputs: data/raw/rrnDB-5.6_16S_rRNA.align
#
# We need to include flip=T to make sure all sequences are pointed in the same
# direction

code/mothur/mothur '#align.seqs(fasta=data/raw/rrnDB-5.6_16S_rRNA.fasta,
reference=data/references/silva_seed/silva.seed_v138.align, flip=T)'
