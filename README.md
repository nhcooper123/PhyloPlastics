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

- **01_data-preparation.qmd**. This takes the cleaned data from script `02_` in `data-preparation` (`plastic-ingestion-data-2026.csv` and `trait-data-2026.csv`.) and performs further cleaning to remove NAs, and to aggregate the dataset to remove pseudoreplicates.	This results in cleaned and aggregated dataset that is used in the rest of the analyses (``)		
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
