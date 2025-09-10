# Prune trees to match seabird list from HBW v9
# Trees come from Claramunt et al 2025: BBtree3
# Available from: https://raw.githubusercontent.com/evolucionario/BigBirdTree
# Natalie Cooper Sep 2025. 
# -----------------------------------------
# Load libraries
# ----------------
library(ape) # to read in and manipulate trees
library(tidyverse) # for data manipulation
library(geiger) # for name check
library(phytools) # for tip binding

# --------------------
# Read in seabird list
# --------------------
seabirds <- read_csv("data-raw/seabird-list-Clements2024_2025-09-10.csv")

# Add _ between species names to match tree
seabirds$Clements2024_Binomial <- gsub(" ", "_", seabirds$Clements2024_Binomial)

# -----------------------------------------------------------------
# Read in Claramunt et al 2025 tree: BBtree3
# ------------------------------------------------------------------
github.directory <- "https://raw.githubusercontent.com/evolucionario/BigBirdTree/refs/heads/main/"
url <- paste0(github.directory, "RAGBackbone/", "BBtree3.tre")

BBtree <- read.tree(url)
# Check it read in correctly
str(BBtree)

# ----------------------------
# Read in updates to taxonomy
# ----------------------------
fix <- read_csv("data-raw/tips-to-fix.csv")

# Subset out just the ones where the taxonomy needs updating
update <- fix %>% filter(!is.na(Tree))

# Subset out just the ones where the tips need adding
to_add <- fix %>% filter(is.na(Tree) & !is.na(Tip))

# ------------------------------------------------
# Update taxonomy for some species to match HBW
for(i in 1:length(update$Species)){
  BBtree$tip.label <- gsub(update$Tree[i], update$Species[i], BBtree$tip.label)
}
# ------------------------------------------------
# What's missing from the tree?
x <- name.check(BBtree, seabirds, data.names = seabirds$Clements2024_Binomial)
x$data_not_tree
length(x$data_not_tree) # Should be 39

# 39 species should be missing. These are generally species recently elevated 
# from subspecies, or where the taxonomy is debated. We can add most of these to the 
# pruned tree where we know their previous position.

#------------------
# Prune tree
# -----------------
seabird_tree <- drop.tip(BBtree, x$tree_not_data) 
# Check
str(seabird_tree)
# should have 352 tips
 
# --------------------------------------------------------------------------- 
# Add missing species to tips designated with arbitrarily small branch length
# ---------------------------------------------------------------------------
for (i in 1:length(to_add$Species)){
  node <- which(seabird_tree$tip.label == to_add$Tip[i])
  seabird_tree <- bind.tip(seabird_tree, tip.label = to_add$Species[i],
                 where = node, position = 0.01)
}

str(seabird_tree)
# should have 372 tips

# ------------------------------------------------
# What's missing from the tree?
x2 <- name.check(seabird_tree, seabirds, data.names = seabirds$Clements2024_Binomial)
x2$data_not_tree
length(x2$data_not_tree) # Should be 19

# "Diomedea_epomophora"  "Diomedea_sanfordi"    "Fregetta_lineata"    
# "Megadyptes_antipodes" "Mergus_octosetaceus"  "Microcarbo_africanus"
# "Microcarbo_coronatus" "Oceanites_pincoyae"   "Phaethon_aethereus"  
# "Pterodroma_caribbaea" "Pterodroma_mollis"    "Puffinus_auricularis"
# "Puffinus_puffinus"    "Sterna_acuticauda"    "Sterna_aurantia"     
# "Sterna_repressa"      "Sterna_virgata"       "Sternula_balaenarum" 
# "Sternula_lorata"     
# These are species with uncertain phylogenetic placement/difficult taxonomy
# ---------------------------------------------------------------------------

# Write out
write.nexus(seabird_tree, file = "data/seabird-tree-Claramont2025_2025-09-10.nex")
