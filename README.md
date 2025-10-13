# PhyloPlastics

Code and data for XXX paper

Author(s): Natalie Cooper, Andrew Macdonald

This repository contains all the code and some data used in the [paper](ADD LINK WHEN PUBLISHED). 

To cite the paper: 
>  CITATION WHEN PUBLISHED

To cite this repo: 
>  Natalie Cooper & Andrew Macdonald. Code for the paper v1. GitHub: nhcooper123/PhyloPlastics. Zenodo. DOI: ADD ON PUBLICATION

ADD ZENODO BADGE WHEN PUBLISHED

![alt text](https://github.com/nhcooper123/PhyloPlastics/raw/main/figures/tree-FO-families.png)

-------

## DATA

All data are available from the [NHM Data Portal](ADD LINK), but also within the  `data/`  and `data-raw/` folders.

If you use the data please cite as follows: 
>  ADD CITATION

-------
## Analyses

### Data preparation

Prior to analyses we ran three scripts to prepare the data for analyses. These scripts are in the `data-preparation` folder.

- **01_extra-seabirds**. This reads in the full bird taxonomy of Clements et al 2024 and extracts just seabirds as defined in our paper. i.e. species that depend on the marine environment for at least part of their life cycle [Gaston 2004]. These are penguins (Sphenisciformes), albatrosses, shearwaters, and petrels (Procellariiformes), frigatebirds, cormorants, gannets and boobies (Suliformes, excluding Anhingidae), tropicbirds (Phaethontiformes), pelicans (Pelecaniformes; Pelecanidae), auks (Charadriiformes; Alcidae), skuas and jaegers (Charadriiformes; Stercorariidae), phalaropes (Charadriiformes; Scolopacidae; Phalaropodini), and terns and gulls (Charadriiformes; Laridae). We also include divers (Gaviiformes), and sea ducks and mergansers (Anseriformes; Anatidae; Mergini, excluding central Brazilian Mergus octosetaceus), as these species spend the majority of the year at sea

- **01_extra-seabirds**. 

- **01_extra-seabirds**. 

### Analyses

The main analyses scripts are as follows.

- **01_data-preparation.qmd**. This takes the cleaned data from script `02_` in `data-preparation` and performs further cleaning to remove NAs, and to aggregate the dataset to remove pseudoreplicates.			
- **02_data-exploration.qmd**				
- **03_dataset-coverage.qmd**				
- **04_summaries-for-results.qmd**			
- **05_mcmcglmm-models-full.qmd**. Runs the MCMCglmm models including sensitivity analyses.			
- **06_figure1-phylogeny-summary.R**. Summary figure showing FO for seabirds across the seabird phylogeny, i.e. Figure 1. Note this requires a little extra processing in Inkscape to add silhouettes and clade labels.		
- **07_figure3_mcmc_results.R**. Code to take the outputs of the models from script 05 to create results figure 3.	
- **08_figure_phylogenies-and-data.R**. This builds the figures for the supplemental that show data coverage and/or summaries of results.	
- **09_get-citations.R**. This uses the `grateful` package to extract citations for all R packages. Note that this required some post extraction cleaning before inclusion in the paper.

-------
## Other folders

The folders `figures` and `output` contains the main figures and tables as well as the MCMCglmm model outputs.

-------
## Session Info
For reproducibility purposes, here is the output of `devtools::session_info()` used to perform the analyses in the publication.

TO DO BEFORE SUBMISSION
   
## Checkpoint for reproducibility
To rerun all the code with packages as they existed on CRAN at time of our analyses we recommend using the `checkpoint` package, and running this code prior to the analysis:

```{r}
checkpoint("2024-02-02")
```
