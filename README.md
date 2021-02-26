Amplicon sequence variants artificially split bacterial genomes into
separate clusters
================
Pat Schloss
2/22/2021

## Abstract

Amplicon sequencing variants (ASVs) have been proposed as an alternative
to operational taxonomic units (OTUs) for analyzing microbial
communities. ASVs have grown in popularity, in part, because of a desire
to reflect a more refined level of taxonomy since they do not cluster
sequences based on a distance-based threshold. However, ASVs and the use
of overly narrow thresholds to identify OTUs increase the risk of
splitting a single genome into separate clusters. To assess this risk, I
analyzed the intragenomic variation of 16S rRNA genes from the bacterial
genomes represented in a *rrn* copy number database, which contained
20,427 genomes from 5,972 species. As the number of copies of the 16S
rRNA gene increased in a genome, the number of ASVs also increased.
There was an average of 0.58 ASVs per copy of the 16S rRNA gene for full
length 16S rRNA genes. It was necessary to use a distance threshold of
5.25% to cluster full length ASVs from the same genome into a single OTU
with 95% confidence for genomes with 7 copies of the 16S rRNA, such as
*E. coli*. This research highlights the risk of splitting a single
bacterial genome into separate clusters when ASVs are used to analyze
16S rRNA gene sequence data. Although there is also a risk of clustering
ASVs from different species into the same OTU when using broad distance
thresholds, those risks are of less concern than artificially splitting
a genome into separate ASVs and OTUs.

## Importance

16S rRNA gene sequencing has engendered significant interest in studying
microbial communities. There has been a tension between trying to
classify 16S rRNA gene sequences to increasingly lower taxonomic levels
and the reality that those levels were defined using more sequence and
physiological information than is available from a fragment of the 16S
rRNA gene. Furthermore, naming of bacterial taxa reflects the biases of
those who name them. One motivation for the recent push to adopt ASVs in
place of OTUs in microbial community analyses is to allow researchers to
perform their analyes at the finest possible level that reflects
species-level taxonomy. The current research is significant because it
quantifies the risk of artificially splitting bacterial genomes into
separate clusters. Far from providing a better represenation of
bacterial taxonomy and biology, the ASV approach can lead to conflicting
inferences about the ecology of different ASVs from the same genome.

### Dependencies:

-   [mothur v.1.44.2](https://github.com/mothur/mothur/tree/v.1.44.2) -
    `code/install_mothur.sh` installs mothur
-   `wget`
-   R version 4.0.4 (2021-02-15)
    -   `tidyverse` (v. 1.3.0)
    -   `Rcpp` (v. 1.0.5)
    -   `furrr` (v. 0.2.1)
    -   `data.table` (v. 1.13.2)
    -   `here` (v. 1.0.1)
    -   `rmarkdown` (v. 2.5)

### My computer

    ## R version 4.0.4 (2021-02-15)
    ## Platform: x86_64-apple-darwin17.0 (64-bit)
    ## Running under: macOS Big Sur 10.16
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRblas.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] furrr_0.2.1       future_1.20.1     Rcpp_1.0.5        data.table_1.13.2
    ##  [5] here_1.0.1        knitr_1.30        forcats_0.5.0     stringr_1.4.0    
    ##  [9] dplyr_1.0.2       purrr_0.3.4       readr_1.4.0       tidyr_1.1.2      
    ## [13] tibble_3.0.4      ggplot2_3.3.2     tidyverse_1.3.0   rmarkdown_2.5    
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.1.0  xfun_0.19         listenv_0.8.0     haven_2.3.1      
    ##  [5] colorspace_2.0-0  vctrs_0.3.5       generics_0.1.0    htmltools_0.5.0  
    ##  [9] yaml_2.2.1        rlang_0.4.9       pillar_1.4.6      glue_1.4.2       
    ## [13] withr_2.3.0       DBI_1.1.0         dbplyr_2.0.0      modelr_0.1.8     
    ## [17] readxl_1.3.1      lifecycle_0.2.0   munsell_0.5.0     gtable_0.3.0     
    ## [21] cellranger_1.1.0  rvest_0.3.6       codetools_0.2-18  evaluate_0.14    
    ## [25] ps_1.4.0          parallel_4.0.4    fansi_0.4.1       broom_0.7.2      
    ## [29] scales_1.1.1      backports_1.2.0   jsonlite_1.7.1    parallelly_1.21.0
    ## [33] fs_1.5.0          hms_0.5.3         digest_0.6.27     stringi_1.5.3    
    ## [37] grid_4.0.4        rprojroot_2.0.2   cli_2.1.0         tools_4.0.4      
    ## [41] magrittr_2.0.1    crayon_1.3.4      pkgconfig_2.0.3   ellipsis_0.3.1   
    ## [45] xml2_1.3.2        reprex_0.3.0      lubridate_1.7.9.2 assertthat_0.2.1 
    ## [49] httr_1.4.2        rstudioapi_0.13   globals_0.14.0    R6_2.5.0         
    ## [53] compiler_4.0.4
