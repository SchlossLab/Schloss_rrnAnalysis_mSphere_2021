Code Club Project: Assessing whether intra and inter-genomic variation
hinder utility of ESVs and ASVs
================
Pat Schloss
9/11/2020

Developed over a series of *Code Club* episodes led by Pat Schloss to
answer an important question in microbiology and develop comfort using
tools to develop reproducible research practices.

## Questions

-   Within a genome, how many distinct sequences of the 16S rRNA gene
    are present relative to the number of copies per genome? How far
    apart are these sequences from each other? How does this scale from
    a genome to kingdoms?
-   Within a taxa (any level), how many ESVs or ASVs from that taxa are
    shared with sister taxa? How does this change with taxonomic level?
    Variable region?

### Dependencies:

-   [mothur v.1.44.2](https://github.com/mothur/mothur/tree/v.1.44.2) -
    `code/install_mothur.sh` installs mothur
-   `wget`
-   R version 4.0.3 (2020-10-10)
    -   `tidyverse` (v. 1.3.0)
    -   `Rcpp` (v. 1.0.5)
    -   `furrr` (v. 0.2.1)
    -   `data.table` (v. 1.13.2)
    -   `rmarkdown` (v. 2.5)

### My computer

    ## R version 4.0.3 (2020-10-10)
    ## Platform: x86_64-apple-darwin17.0 (64-bit)
    ## Running under: macOS Catalina 10.15.7
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
    ##  [5] forcats_0.5.0     stringr_1.4.0     dplyr_1.0.2       purrr_0.3.4      
    ##  [9] readr_1.4.0       tidyr_1.1.2       tibble_3.0.4      ggplot2_3.3.2    
    ## [13] tidyverse_1.3.0   rmarkdown_2.5    
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.1.0  xfun_0.19         listenv_0.8.0     haven_2.3.1      
    ##  [5] colorspace_2.0-0  vctrs_0.3.5       generics_0.1.0    htmltools_0.5.0  
    ##  [9] yaml_2.2.1        rlang_0.4.9       pillar_1.4.6      glue_1.4.2       
    ## [13] withr_2.3.0       DBI_1.1.0         dbplyr_2.0.0      modelr_0.1.8     
    ## [17] readxl_1.3.1      lifecycle_0.2.0   munsell_0.5.0     gtable_0.3.0     
    ## [21] cellranger_1.1.0  rvest_0.3.6       codetools_0.2-16  evaluate_0.14    
    ## [25] knitr_1.30        ps_1.4.0          parallel_4.0.3    fansi_0.4.1      
    ## [29] broom_0.7.2       scales_1.1.1      backports_1.2.0   jsonlite_1.7.1   
    ## [33] parallelly_1.21.0 fs_1.5.0          hms_0.5.3         digest_0.6.27    
    ## [37] stringi_1.5.3     grid_4.0.3        cli_2.1.0         tools_4.0.3      
    ## [41] magrittr_2.0.1    crayon_1.3.4      pkgconfig_2.0.3   ellipsis_0.3.1   
    ## [45] xml2_1.3.2        reprex_0.3.0      lubridate_1.7.9.2 assertthat_0.2.1 
    ## [49] httr_1.4.2        rstudioapi_0.13   globals_0.14.0    R6_2.5.0         
    ## [53] compiler_4.0.3
