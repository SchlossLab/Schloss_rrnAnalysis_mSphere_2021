# Code Club Project: Assessing whether intra and inter-genomic variation hinder utility of ASVs

**Author:** Pat Schloss

Developed over a series of *Code Club* episodes led by Pat Schloss to answer an important question in microbiology and develop comfort using tools to develop reproducible research practices.



## Questions
* Within a genome, how many distinct sequences of the 16S rRNA gene are present relative to the number of copies per genome? How far apart are these sequences from each other? How does this scale from a genome to kingdoms?
* Within a taxa (any level), how many ASVs from that taxa are shared with sister taxa? How does this change with taxonomic level? Variable region?


* Make sure we have taxonomic data for all of our genomes
* Read FASTA files into R (do it on our own)
* inner_join with tsv file
* group_by / summarize to count number of sequences and copies per genome


### Dependencies:  
* [mothur v.1.44.2](https://github.com/mothur/mothur/tree/v.1.44.2) - `code/install_mothur.sh` installs mothur
* `wget`
