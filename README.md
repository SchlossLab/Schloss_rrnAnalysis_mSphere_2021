Code Club Project: Assessing whether intra and inter-genomic variation
hinder utility of ASVs
================
Pat Schloss
9/11/2020

Developed over a series of *Code Club* episodes led by Pat Schloss to
answer an important question in microbiology and develop comfort using
tools to develop reproducible research practices.

Questions
---------

-   Within a genome, how many distinct sequences of the 16S rRNA gene
    are present relative to the number of copies per genome? How far
    apart are these sequences from each other? How does this scale from
    a genome to kingdoms?

-   Within a taxa (any level), how many ASVs from that taxa are shared
    with sister taxa? How does this change with taxonomic level?
    Variable region?

-   Make sure we have taxonomic data for all of our genomes

-   Read FASTA files into R (do it on our own)

-   inner\_join with tsv file

-   group\_by / summarize to count number of sequences and copies per
    genome

### Dependencies:

-   [mothur v.1.44.2](https://github.com/mothur/mothur/tree/v.1.44.2) -
    `code/install_mothur.sh` installs mothur
-   `wget`
-   R version 4.0.2 (2020-06-22)
    -   `tidyverse` (v. 1.3.0)
    -   `data.table` (v. 1.13.0)
    -   `rmarkdown` (v. 2.3)

### My computer

    ## R version 4.0.2 (2020-06-22)
    ## Platform: x86_64-apple-darwin19.5.0 (64-bit)
    ## Running under: macOS Catalina 10.15.6
    ## 
    ## Matrix products: default
    ## BLAS/LAPACK: /usr/local/Cellar/openblas/0.3.10_1/lib/libopenblasp-r0.3.10.dylib
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] data.table_1.13.0 forcats_0.5.0     stringr_1.4.0     dplyr_1.0.2      
    ##  [5] purrr_0.3.4       readr_1.3.1       tidyr_1.1.1       tibble_3.0.3     
    ##  [9] ggplot2_3.3.2     tidyverse_1.3.0   rmarkdown_2.3    
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.5       cellranger_1.1.0 pillar_1.4.6     compiler_4.0.2  
    ##  [5] dbplyr_1.4.4     tools_4.0.2      digest_0.6.25    lubridate_1.7.9 
    ##  [9] jsonlite_1.7.0   evaluate_0.14    lifecycle_0.2.0  gtable_0.3.0    
    ## [13] pkgconfig_2.0.3  rlang_0.4.7      reprex_0.3.0     cli_2.0.2       
    ## [17] rstudioapi_0.11  DBI_1.1.0        yaml_2.2.1       haven_2.3.1     
    ## [21] xfun_0.16        withr_2.2.0      xml2_1.3.2       httr_1.4.2      
    ## [25] knitr_1.29       fs_1.5.0         hms_0.5.3        generics_0.0.2  
    ## [29] vctrs_0.3.2      grid_4.0.2       tidyselect_1.1.0 glue_1.4.1      
    ## [33] R6_2.4.1         fansi_0.4.1      readxl_1.3.1     modelr_0.1.8    
    ## [37] blob_1.2.1       magrittr_1.5     backports_1.1.9  scales_1.1.1    
    ## [41] ellipsis_0.3.1   htmltools_0.5.0  rvest_0.3.6      assertthat_0.2.1
    ## [45] colorspace_1.4-1 stringi_1.4.6    munsell_0.5.0    broom_0.7.0     
    ## [49] crayon_1.3.4
