# Prune trees to match seabird list from Clements 2024 taxonomy
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

# -------------------------------------------------------
# Update taxonomy for some species to match Clements 2024
# Only a few as the tree uses this taxonomy
# -------------------------------------------------------
BBtree$tip.label <- gsub("Leucocarbo_bougainvillii", "Leucocarbo_bougainvilliorum", BBtree$tip.label)
BBtree$tip.label <- gsub("Puffinus_assimilis_tunneyi", "Puffinus_assimilis", BBtree$tip.label)
BBtree$tip.label <- gsub("Puffinus_bailloni_bailloni", "Puffinus_bailloni", BBtree$tip.label)

# ------------------------------------------------
# What's missing from the tree?
x <- name.check(BBtree, seabirds, data.names = seabirds$Clements2024_Binomial)
x$data_not_tree
length(x$data_not_tree) # Should be 39

# 39 species should be missing. These are generally species recently elevated 
# from subspecies, or where the taxonomy/phylogeny is debated. We can add most of these to the 
# pruned tree where we know their previous position.

#---------------------------------------------------
# Prune tree
# ---------------------------------------------------
seabird_tree <- drop.tip(BBtree, x$tree_not_data) 
# Check
str(seabird_tree)
# should have 352 tips
 
# --------------------------------------------------------------------------- 
# Add missing species to tips 
# ---------------------------------------------------------------------------
# First do the more complex cases
# Diomedea sanfordi as sister to all other Diomedea
node <- findMRCA(tree = seabird_tree, tips = c("Diomedea_dabbenena", "Diomedea_antipodensis", 
                                                "Diomedea_exulans", "Diomedea_amsterdamensis"))
seabird_tree <- bind.tip(seabird_tree, tip.label = "Diomedea_sanfordi",
                         where = node, position = 0.54)

# Fregetta lineata.   
node <- findMRCA(tree = seabird_tree, tips = c("Fregetta_grallaria", "Fregetta_tropica","Fregetta_maoriana"))
seabird_tree <- bind.tip(seabird_tree, tip.label = "Fregetta_lineata",
                         where = node, position = 4.859042173)

# Megadyptes antipodes as sister to all Eudyptes
node <- findMRCA(tree = seabird_tree, tips = c("Eudyptes_robustus",
                                               "Eudyptes_pachyrhynchus",
                                               "Eudyptes_moseleyi",
                                               "Eudyptes_schlegeli",
                                               "Eudyptes_chrysolophus",
                                               "Eudyptes_sclateri"))
seabird_tree <- bind.tip(seabird_tree, tip.label = "Megadyptes_antipodes",
                         where = node, position = 4.05234108)

# Microcarbo africanus as sister to other Microcarbo
node <- findMRCA(tree = seabird_tree, tips = c("Microcarbo_melanoleucos",
                                               "Microcarbo_pygmaeus",
                                               "Microcarbo_niger"))
seabird_tree <- bind.tip(seabird_tree, tip.label = "Microcarbo_africanus",
                         where = node, position = 10.54225343)

# Oceanites pincoyae as polytomy with root of clade containing the other two species in genus
node <- findMRCA(tree = seabird_tree, tips = c("Oceanites_oceanicus", "Oceanites_gracilis"))
seabird_tree <- bind.tip(seabird_tree, tip.label = "Oceanites_pincoyae",
                         where = node, position = 13.00895487)

# Pterodroma atrata as polytomy at base of Pterodroma. Other missing species added to polytomy in the next step.      
node <- findMRCA(tree = seabird_tree, tips = c("Pterodroma_hypoleuca",
                                               "Pterodroma_magentae",
                                               "Pterodroma_lessonii",
                                               "Pterodroma_incerta",
                                               "Pterodroma_hasitata",
                                               "Pterodroma_cahow",
                                               "Pterodroma_madeira",
                                               "Pterodroma_feae",
                                               "Pterodroma_longirostris",
                                               "Pterodroma_cookii",
                                               "Pterodroma_pycrofti",
                                               "Pterodroma_leucoptera",
                                               "Pterodroma_brevipes",
                                               "Pterodroma_nigripennis",
                                               "Pterodroma_solandri",
                                               "Pterodroma_axillaris",
                                               "Pterodroma_inexpectata",
                                               "Pterodroma_neglecta",
                                               "Pterodroma_arminjoniana",
                                               "Pterodroma_alba",
                                               "Pterodroma_heraldica",
                                               "Pterodroma_ultima",
                                               "Pterodroma_cervicalis",
                                               "Pterodroma_externa",
                                               "Pterodroma_phaeopygia",
                                               "Pterodroma_baraui",
                                               "Pterodroma_sandwichensis"))
seabird_tree <- bind.tip(seabird_tree, tip.label = "Pterodroma_atrata",
                         where = node, position = 14.74645025)

# Puffinus as polytomy as base of other Puffinus. Other missing species added to polytomy in the next step.
node <- findMRCA(tree = seabird_tree, tips = c("Puffinus_nativitatis",
                                               "Puffinus_myrtae"))
seabird_tree <- bind.tip(seabird_tree, tip.label = "Puffinus_auricularis",
                         where = node, position = 3.264401817)
#---------------------------------------------------------------------------
# Simple ones where we just need to add species to a sister can be automated
# Read in updates and remove complex cases
to_add <- read_csv("data-raw/tips-to-add.csv")
to_add <- to_add %>% filter(Simple == "YES")

# Loop to add species
for (i in 1:length(to_add$Species)){
  node <- which(seabird_tree$tip.label == to_add$Tip[i])
  seabird_tree <- bind.tip(seabird_tree, tip.label = to_add$Species[i],
                 where = node, position = to_add$Branch[i])
}

str(seabird_tree)
# should have 385 tips

#-----------------------
# Print out for checks
#-----------------------
pdf(width = 10, height = 30, file = "output/seabird_tree_Claramunt25.pdf")
plot(seabird_tree, no.margin = TRUE, cex = 0.5)
dev.off()

# ------------------------------------------------
# What's still missing from the tree?
# ------------------------------------------------
x2 <- name.check(seabird_tree, seabirds, data.names = seabirds$Clements2024_Binomial)
x2$data_not_tree
length(x2$data_not_tree) # Should be 6

#"Mergus_octosetaceus"  = not a seabird
#"Pterodroma_caribbaea" = extinct 
#"Sterna_acuticauda", "Sterna_aurantia", "Sterna_repressa", "Sterna_virgata"
# These are species with uncertain phylogenetic placement/difficult taxonomy
# ---------------------------------------------------------------------------

# Write out
write.nexus(seabird_tree, file = "data/seabird-tree-Claramont2025_2025-09-11.nex")
