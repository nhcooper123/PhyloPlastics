# PhyloPlastics

Code and data for paper: Frequency of occurrence of plastic varies across phylogeny but not ecology in seabirds. 

This repository contains all the code and some data used in the [paper](ADD LINK WHEN PUBLISHED). 

To cite the paper: 
>  Frequency of occurrence of plastic varies across phylogeny but not ecology in seabirds. 2026. Stephanie Avery-Gomm, Nia Potapova, Chrissie Potter,  Alexander L. Bond, Stephanie B. Borrelle, Jennifer L. Lavers, Steven J. Portugal, Hugh P. Possingham, Jennifer F. Provencher, and Natalie Cooper. ADD DETAILS WHEN PUBLISHED.

To cite this repo: 
>  Natalie Cooper & Andrew Macdonald. Code for the paper v1. GitHub: nhcooper123/PhyloPlastics. Zenodo. DOI: ADD ON PUBLICATION

ADD ZENODO BADGE WHEN PUBLISHED

![alt text](https://github.com/nhcooper123/PhyloPlastics/raw/main/final-figures/FigureS3-cropped.png)

-------

## DATA

All data are available from the [NHM Data Portal](https://doi.org/10.5519/hemrjx9q), but also within the  `data/`  and `data-raw/` folders. Full metadata are available on the NHM Data Portal

If you use the data please cite as follows: 
>  Avery-Gomm S et al. 2025 Global seabird plastic ingestion database. Natural History Museum. doi:10.5519/HEMRJX9Q.

### Taxonomy
The full taxonomy file can be found here: https://www.birds.cornell.edu/clementschecklist/download/.

If you want to use the taxonomy please cite:

> Clements, J. F., P. C. Rasmussen, T. S. Schulenberg, M. J. Iliff, T. A. Fredericks, J. A. Gerbracht, D. Lepage, A. Spencer, S. M. Billerman, B. L. Sullivan, M. Smith, and C. L. Wood. 2025. The eBird/Clements Checklist of Birds of the World: v2025. Downloaded from https://www.birds.cornell.edu/clementschecklist/download/.

### Phylogeny
The full raw phylogeny file can be found here: https://raw.githubusercontent.com/evolucionario/BigBirdTree/refs/heads/main/RAGBackbone/BBtree3.tre.

If you want to use the phylogeny please cite:

> Claramunt, Santiago, Catherine Sheard, Joseph W. Brown, Gala Cortés-Ramírez, Joel Cracraft, Michelle M. Su, Brian C. Weeks, and Joseph A. Tobias. 2025. “A New Time Tree of Birds Reveals the Interplay between Dispersal, Geographic Range Size, and Diversification.” Current Biology 35 (16): 3883-3895.e4.

-------
## Analyses

### Data preparation

Prior to analyses we ran three scripts to prepare the data for analyses. These scripts are in the `data-preparation` folder.

- **01_extract-seabirds**. This reads in the full bird taxonomy of Clements et al. 2025 (https://www.birds.cornell.edu/clementschecklist/download/.) and extracts just seabirds as defined in our paper. i.e. species that depend on the marine environment for at least part of their life cycle [Gaston 2004]. These are penguins (Sphenisciformes), albatrosses, shearwaters, and petrels (Procellariiformes), frigatebirds, cormorants, gannets and boobies (Suliformes, excluding Anhingidae), tropicbirds (Phaethontiformes), pelicans (Pelecaniformes; Pelecanidae), auks (Charadriiformes; Alcidae), skuas and jaegers (Charadriiformes; Stercorariidae), phalaropes (Charadriiformes; Scolopacidae; Phalaropodini), and terns and gulls (Charadriiformes; Laridae). We also include divers (Gaviiformes), and sea ducks and mergansers (Anseriformes; Anatidae; Mergini, excluding central Brazilian Mergus octosetaceus), as these species spend the majority of the year at sea. We exclude eight extinct species. Creates `Clements-taxonomy-2025.csv`.

- **02_compile-datasets**. This code reads in the raw data for plastic ingestion (`02_plastic-ingestion-data.csv`)and trait data (`03_trait-data.csv`), updates the taxonomy and performs some simple data cleaning to result in the files `plastic-ingestion-data-2026.csv` and `trait-data-2026.csv`. These intermediate files are cleaned and aggregated further in the main analyses.

- **03_get-phylogenetic-trees-BBtree**. This code reads in the `BBtree3` phylogeny of Claramunt et al. 2025 and matches it to the seabird taxonomy of Clements et al. 2025 (`Clements-taxonomy-2025.csv`). This involves some name updates and also adding species missing from the tree (see details in `data-raw/tipstoadd.csv`). Results in a species-level (`seabird-tree-2026.nex`) and family-level (`family-tree-2026.nex`) phylogeny for use in the analyses.

### Analyses

The main analyses scripts are as follows.

- **01_data-preparation.qmd**. This takes the cleaned data from script `02_` in `data-preparation` (`plastic-ingestion-data-2026.csv` and `trait-data-2026.csv`) and performs further cleaning to remove NAs, and to aggregate the dataset to remove pseudoreplicates.	This results in cleaned and aggregated dataset and tree for 230 species that is used in the rest of the analyses (`plastic-data-aggregated_2026.csv` and `seabird-tree-plastic-2026.nex`).		
- **02_data-exploration.qmd**. Extracts some summary data, including number of records, species, sources and number of well-studied species. Creates distributional plots of variables for the supplemental materials (Figures S1 and S4-S7). 				
- **03_dataset-coverage.qmd**. Calculates various dataset coverage metrics, including for orders and families (Table S2 in the supplemental). Family level coverage is also plotted to create Figure 1. 				
- **04_summaries-for-results.qmd**. Calculates summary stats including total numbers of birds, studies and species in each model for the text and for Table S2, and order and family level FO for the supplemental results Table S3.			
- **05_mcmcglmm-models-full.qmd**. Runs the MCMCglmm models including a lot of sensitivity analyses requested by reviewers and saves outputs.			
- **06_figureS2-phylogeny-summary.R**. Summary figure showing FO for seabirds across the seabird phylogeny, i.e. Figure S2. Note this requires a little extra processing in Inkscape to add silhouettes and clade labels.		
- **07_figure3_mcmc_results.R**. Code to take the outputs of the models from script 05 to create results Figure 3.	
- **08_figures_phylogenies-and-data.R**. This creates the figures for the supplemental that show data coverage (Figure S3) and also Figure 2 of FO across the tree for the main text. Note that these require some post processing in Inkscape to add the silhouettes.
- **09_get-citations.R**. This uses the `grateful` package to extract citations for all R packages. Note that this required some post extraction cleaning before inclusion in the paper.

-------
## Other folders

The folders `figures` and `output` contains the main and supplemental figures and tables as well as the MCMCglmm model outputs. `final-figures` contains the post Inkscape processed figures for Figures S2, S3 and Figure 2.

-------
## Session Info
For reproducibility purposes, here is the output of `devtools::session_info()` used to perform the analyses in the publication.

    ─ Session info ────────────────────────────────────────────────────
    setting  value
    version  R version 4.5.3 (2026-03-11)
    os       macOS Sequoia 15.6.1
    system   aarch64, darwin20
    ui       RStudio
    language (EN)
    collate  en_US.UTF-8
    ctype    en_US.UTF-8
    tz       Europe/London
    date     2026-05-01
    rstudio  2026.04.0+526 Globemaster Allium (desktop)
    pandoc   3.8.3 @ /Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/aarch64/ (via rmarkdown)
    quarto   1.9.36 @ /Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto

    ─ Packages ────────────────────────────────────────────────────────
    package           * version    date (UTC) lib source
    ape               * 5.8-1      2024-12-16 [1] CRAN (R 4.5.0)
    aplot               0.2.9      2025-09-12 [1] CRAN (R 4.5.0)
    bslib               0.9.0      2025-01-30 [1] CRAN (R 4.5.0)
    cachem              1.1.0      2024-05-16 [1] CRAN (R 4.5.0)
    cli                 3.6.5      2025-04-23 [1] CRAN (R 4.5.0)
    clusterGeneration   1.3.8      2023-08-16 [1] CRAN (R 4.5.0)
    coda              * 0.19-4.1   2024-01-31 [1] CRAN (R 4.5.0)
    codetools           0.2-20     2024-03-31 [1] CRAN (R 4.5.2)
    combinat            0.0-8      2012-10-29 [1] CRAN (R 4.5.0)
    corpcor             1.6.10     2021-09-16 [1] CRAN (R 4.5.0)
    cubature            2.1.4      2025-06-02 [1] CRAN (R 4.5.0)
    DEoptim             2.2-8      2022-11-11 [1] CRAN (R 4.5.0)
    deSolve             1.40       2023-11-27 [1] CRAN (R 4.5.0)
    devtools            2.4.5      2022-10-11 [1] CRAN (R 4.5.0)
    dichromat           2.0-0.1    2022-05-02 [1] CRAN (R 4.5.0)
    digest              0.6.37     2024-08-19 [1] CRAN (R 4.5.0)
    doParallel          1.0.17     2022-02-07 [1] CRAN (R 4.5.0)
    dplyr             * 1.1.4      2023-11-17 [1] CRAN (R 4.5.0)
    ellipsis            0.3.2      2021-04-29 [1] CRAN (R 4.5.0)
    evaluate            1.0.5      2025-08-27 [1] CRAN (R 4.5.0)
    expm                1.0-0      2024-08-19 [1] CRAN (R 4.5.0)
    farver              2.1.2      2024-05-13 [1] CRAN (R 4.5.0)
    fastmap             1.2.0      2024-05-15 [1] CRAN (R 4.5.0)
    fastmatch           1.1-6      2024-12-23 [1] CRAN (R 4.5.0)
    forcats           * 1.0.0      2023-01-29 [1] CRAN (R 4.5.0)
    foreach             1.5.2      2022-02-02 [1] CRAN (R 4.5.0)
    fs                  1.6.6      2025-04-12 [1] CRAN (R 4.5.0)
    geiger            * 2.0.11     2023-04-03 [1] CRAN (R 4.5.0)
    generics            0.1.4      2025-05-09 [1] CRAN (R 4.5.0)
    ggfun               0.2.0      2025-07-15 [1] CRAN (R 4.5.0)
    ggnewscale        * 0.5.2      2025-06-20 [1] CRAN (R 4.5.0)
    ggplot2           * 4.0.1      2025-11-14 [1] CRAN (R 4.5.2)
    ggplotify           0.1.2      2023-08-09 [1] CRAN (R 4.5.0)
    ggstance          * 0.3.7      2024-04-05 [1] CRAN (R 4.5.0)
    ggtree            * 3.16.3     2025-07-14 [1] Bioconductor 3.21 (R 4.5.1)
    ggtreeExtra       * 1.18.0     2025-04-15 [1] Bioconductor 3.21 (R 4.5.0)
    glue                1.8.0      2024-09-30 [1] CRAN (R 4.5.0)
    grateful          * 0.3.0      2025-09-04 [1] CRAN (R 4.5.0)
    gridGraphics        0.5-1      2020-12-13 [1] CRAN (R 4.5.0)
    gtable              0.3.6      2024-10-25 [1] CRAN (R 4.5.0)
    here              * 1.0.2      2025-09-15 [1] CRAN (R 4.5.0)
    Hmisc             * 5.2-5      2026-01-09 [1] CRAN (R 4.5.2)
    hms                 1.1.3      2023-03-21 [1] CRAN (R 4.5.0)
    htmltools           0.5.8.1    2024-04-04 [1] CRAN (R 4.5.0)
    htmlwidgets         1.6.4      2023-12-06 [1] CRAN (R 4.5.0)
    httpuv              1.6.16     2025-04-16 [1] CRAN (R 4.5.0)
    igraph              2.1.4      2025-01-23 [1] CRAN (R 4.5.0)
    iterators           1.0.14     2022-02-05 [1] CRAN (R 4.5.0)
    jquerylib           0.1.4      2021-04-26 [1] CRAN (R 4.5.0)
    jsonlite            2.0.0      2025-03-27 [1] CRAN (R 4.5.0)
    knitr               1.50       2025-03-16 [1] CRAN (R 4.5.0)
    later               1.4.4      2025-08-27 [1] CRAN (R 4.5.0)
    lattice             0.22-7     2025-04-02 [1] CRAN (R 4.5.2)
    lazyeval            0.2.2      2019-03-15 [1] CRAN (R 4.5.0)
    lifecycle           1.0.4      2023-11-07 [1] CRAN (R 4.5.0)
    lubridate         * 1.9.4      2024-12-08 [1] CRAN (R 4.5.0)
    magrittr            2.0.4      2025-09-12 [1] CRAN (R 4.5.0)
    maps              * 3.4.3      2025-05-26 [1] CRAN (R 4.5.0)
    MASS                7.3-65     2025-02-28 [1] CRAN (R 4.5.2)
    Matrix            * 1.7-4      2025-08-28 [1] CRAN (R 4.5.2)
    MCMCglmm          * 2.36       2024-05-06 [1] CRAN (R 4.5.0)
    memoise             2.0.1      2021-11-26 [1] CRAN (R 4.5.0)
    mime                0.13       2025-03-17 [1] CRAN (R 4.5.0)
    miniUI              0.1.2      2025-04-17 [1] CRAN (R 4.5.0)
    mnormt              2.1.1      2022-09-26 [1] CRAN (R 4.5.0)
    mvtnorm             1.3-3      2025-01-10 [1] CRAN (R 4.5.0)
    nlme                3.1-168    2025-03-31 [1] CRAN (R 4.5.2)
    numDeriv            2016.8-1.1 2019-06-06 [1] CRAN (R 4.5.0)
    optimParallel       1.0-2      2021-02-11 [1] CRAN (R 4.5.0)
    patchwork         * 1.3.2      2025-08-25 [1] CRAN (R 4.5.0)
    phangorn            2.12.1     2024-09-17 [1] CRAN (R 4.5.0)
    phytools          * 2.4-4      2025-01-08 [1] CRAN (R 4.5.0)
    pillar              1.11.1     2025-09-17 [1] CRAN (R 4.5.0)
    pkgbuild            1.4.8      2025-05-26 [1] CRAN (R 4.5.0)
    pkgconfig           2.0.3      2019-09-22 [1] CRAN (R 4.5.0)
    pkgload             1.4.0      2024-06-28 [1] CRAN (R 4.5.0)
    profvis             0.4.0      2024-09-20 [1] CRAN (R 4.5.0)
    promises            1.3.3      2025-05-29 [1] CRAN (R 4.5.0)
    purrr             * 1.1.0      2025-07-10 [1] CRAN (R 4.5.0)
    quadprog            1.5-8      2019-11-20 [1] CRAN (R 4.5.0)
    R6                  2.6.1      2025-02-15 [1] CRAN (R 4.5.0)
    rappdirs            0.3.3      2021-01-31 [1] CRAN (R 4.5.0)
    RColorBrewer        1.1-3      2022-04-03 [1] CRAN (R 4.5.0)
    Rcpp                1.1.0      2025-07-02 [1] CRAN (R 4.5.0)
    readr             * 2.1.5      2024-01-10 [1] CRAN (R 4.5.0)
    remotes             2.5.0      2024-03-17 [1] CRAN (R 4.5.0)
    renv                1.1.6      2026-01-16 [1] CRAN (R 4.5.2)
    rlang               1.1.6      2025-04-11 [1] CRAN (R 4.5.0)
    rmarkdown           2.29       2024-11-04 [1] CRAN (R 4.5.0)
    rprojroot           2.1.1      2025-08-26 [1] CRAN (R 4.5.0)
    rstudioapi          0.17.1     2024-10-22 [1] CRAN (R 4.5.0)
    S7                  0.2.0      2024-11-07 [1] CRAN (R 4.5.0)
    sass                0.4.10     2025-04-11 [1] CRAN (R 4.5.0)
    scales              1.4.0      2025-04-24 [1] CRAN (R 4.5.0)
    scatterplot3d       0.3-44     2023-05-05 [1] CRAN (R 4.5.0)
    sessioninfo         1.2.3      2025-02-05 [1] CRAN (R 4.5.0)
    shiny               1.11.1     2025-07-03 [1] CRAN (R 4.5.0)
    stringi             1.8.7      2025-03-27 [1] CRAN (R 4.5.0)
    stringr           * 1.5.2      2025-09-08 [1] CRAN (R 4.5.0)
    subplex             1.9        2024-07-05 [1] CRAN (R 4.5.0)
    tensorA             0.36.2.1   2023-12-13 [1] CRAN (R 4.5.0)
    tibble            * 3.3.0      2025-06-08 [1] CRAN (R 4.5.0)
    tidyr             * 1.3.1      2024-01-24 [1] CRAN (R 4.5.0)
    tidyselect          1.2.1      2024-03-11 [1] CRAN (R 4.5.0)
    tidytree          * 0.4.6      2023-12-12 [1] CRAN (R 4.5.0)
    tidyverse         * 2.0.0      2023-02-22 [1] CRAN (R 4.5.0)
    timechange          0.3.0      2024-01-18 [1] CRAN (R 4.5.0)
    treeio            * 1.32.0     2025-04-15 [1] Bioconductor 3.21 (R 4.5.0)
    tzdb                0.5.0      2025-03-15 [1] CRAN (R 4.5.0)
    urlchecker          1.0.1      2021-11-30 [1] CRAN (R 4.5.0)
    usethis             3.2.1      2025-09-06 [1] CRAN (R 4.5.0)
    vctrs               0.6.5      2023-12-01 [1] CRAN (R 4.5.0)
    withr               3.0.2      2024-10-28 [1] CRAN (R 4.5.0)
    xfun                0.53       2025-08-19 [1] CRAN (R 4.5.0)
    xtable              1.8-4      2019-04-21 [1] CRAN (R 4.5.0)
    yaml                2.3.10     2024-07-26 [1] CRAN (R 4.5.0)
    yulab.utils         0.2.1      2025-08-19 [1] CRAN (R 4.5.0)
   
## Checkpoint for reproducibility
To rerun all the code with packages as they existed on CRAN at time of our analyses we recommend using the `checkpoint` package, and running this code prior to the analysis:

```{r}
checkpoint("2026-05-01")
```
