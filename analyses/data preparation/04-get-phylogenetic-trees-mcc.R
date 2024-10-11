# Prune trees to match seabird list from HBW v8.1
# Trees come from elaboration/innovation project PGLS analyses hackett backbone
# Natalie Cooper Oct 2024. 
# -----------------------------------------

# ----------------
# Load libraries
# ----------------
library(ape) # to read in and manipulate trees
library(tidyverse) # for data manipulation
library(geiger) # for name check
library(phytools) # for tip binding

# --------------------
# Read in seabird list
# --------------------
seabirds <- read_csv("data-raw/seabird-list-HBW-2024-09-30.csv")

# Add _ between species names to match tree
seabirds$HBWv8.1_Binomial <- gsub(" ", "_", seabirds$HBWv8.1_Binomial)

# ----------------
# Read in MCC tree
# ----------------
tree1 <- read.tree("data-raw/Prum_merge_hackett_stage2_1K_mcc.tree") #mcc tree
# Check it read in correctly
str(tree1)

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
  tree1$tip.label <- gsub(update$Tree[i], update$Species[i], tree1$tip.label)
}
# ------------------------------------------------
# What's missing from the tree?
x <- name.check(tree1, seabirds, data.names = seabirds$HBWv8.1_Binomial)
x$data_not_tree
length(x$data_not_tree) # Should be 27

# 27 species should be missing. These are generally species recently elevated 
# from subspecies, or where the taxonomy is debated. We can add most of these to the 
# pruned tree where we know their previous position.

#------------------
# Prune tree
# -----------------
seabird_tree <- drop.tip(tree1, x$tree_not_data) 
# Check
str(seabird_tree)
# should have 357 tips
 
# -------------------- 
# Add missing species
# --------------------
for (i in 1:length(to_add$Species)){
  node <- which(seabird_tree$tip.label == to_add$Tip[i])
  seabird_tree <- bind.tip(seabird_tree, tip.label = to_add$Species[i],
                 where = node, position = 0.0001)
}

str(seabird_tree)
# should have 380 tips

# ------------------------------------------------
# What's missing from the tree?
x2 <- name.check(seabird_tree, seabirds, data.names = seabirds$HBWv8.1_Binomial)
x2$data_not_tree
length(x2$data_not_tree) # Should be 4

# 4 species should be missing. Aphrodroma_brevirostris, Fregetta_lineata, Oceanites_pincoyae, Puffinus_bryani
# These are new species with uncertainy phylogenetic placement
# ------------------------------------------------

# Write out
write.nexus(seabird_tree, file = "data/seabird-tree-HBW-2024-10-11.nex")
