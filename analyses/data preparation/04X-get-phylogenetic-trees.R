# Prune trees to match seabird list from HBW v8.1
# Trees come from https://github.com/McTavishLab/AvesData/tree/main/Tree_versions/Aves_1.2/Clements2023
# MCC tree = summary_dated_clements.nex
# Tree sample (100 random samples) = dated_sample_2023.tre
# # trees <- read.tree("data-raw/dated_sample_2023.tre") #sample of 100 dated trees
# Natalie Cooper Sept 2024. 
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
tree1 <- read.nexus("data-raw/summary_dated_clements.nex") #mcc tree
# Check it read in correctly
str(tree1)

# Update taxonomy for some species to match HBW
tree1$tip.label <- gsub("Anous_albivitta", "Anous_albivittus", tree1$tip.label)
tree1$tip.label <- gsub("Stercorarius_antarcticus", "Catharacta_antarctica", tree1$tip.label)
tree1$tip.label <- gsub("Stercorarius_chilensis", "Catharacta_chilensis", tree1$tip.label)
tree1$tip.label <- gsub("Stercorarius_skua", "Catharacta_skua", tree1$tip.label)
tree1$tip.label <- gsub("Stercorarius_maccormicki", "Catharacta_maccormicki", tree1$tip.label)
tree1$tip.label <- gsub("Leucophaeus_atricilla", "Larus_atricilla", tree1$tip.label)
tree1$tip.label <- gsub("Leucophaeus_fuliginosus", "Larus_fuliginosus", tree1$tip.label)
tree1$tip.label <- gsub("Leucophaeus_modestus", "Larus_modestus", tree1$tip.label)
tree1$tip.label <- gsub("Leucophaeus_pipixcan", "Larus_pipixcan", tree1$tip.label)
tree1$tip.label <- gsub("Leucophaeus_scoresbii", "Larus_scoresbii", tree1$tip.label)
tree1$tip.label <- gsub("Ichthyaetus_audouinii", "Larus_audouinii", tree1$tip.label)
tree1$tip.label <- gsub("Ichthyaetus_hemprichii", "Larus_hemprichii", tree1$tip.label)
tree1$tip.label <- gsub("Ichthyaetus_ichthyaetus", "Larus_ichthyaetus", tree1$tip.label)
tree1$tip.label <- gsub("Ichthyaetus_leucophthalmus", "Larus_leucophthalmus", tree1$tip.label)
tree1$tip.label <- gsub("Ichthyaetus_melanocephalus", "Larus_melanocephalus", tree1$tip.label)
tree1$tip.label <- gsub("Ichthyaetus_relictus", "Larus_relictus", tree1$tip.label)
tree1$tip.label <- gsub("Chroicocephalus_brunnicephalus", "Larus_brunnicephalus", tree1$tip.label)
tree1$tip.label <- gsub("Chroicocephalus_bulleri", "Larus_bulleri", tree1$tip.label)
tree1$tip.label <- gsub("Chroicocephalus_cirrocephalus", "Larus_cirrocephalus", tree1$tip.label)
tree1$tip.label <- gsub("Chroicocephalus_genei", "Larus_genei", tree1$tip.label)
tree1$tip.label <- gsub("Chroicocephalus_hartlaubii", "Larus_hartlaubii", tree1$tip.label)
tree1$tip.label <- gsub("Chroicocephalus_maculipennis", "Larus_maculipennis", tree1$tip.label)
tree1$tip.label <- gsub("Chroicocephalus_novaehollandiae", "Larus_novaehollandiae", tree1$tip.label)
tree1$tip.label <- gsub("Chroicocephalus_philadelphia", "Larus_philadelphia", tree1$tip.label)
tree1$tip.label <- gsub("Chroicocephalus_ridibundus", "Larus_ridibundus", tree1$tip.label)
tree1$tip.label <- gsub("Chroicocephalus_serranus", "Larus_serranus", tree1$tip.label)
tree1$tip.label <- gsub("Leucocarbo_bougainvillii", "Leucocarbo_bougainvilliorum", tree1$tip.label)
tree1$tip.label <- gsub("Leucocarbo_bransfieldensis", "Phalacrocorax_bransfieldensis", tree1$tip.label)
tree1$tip.label <- gsub("Leucocarbo_georgianus", "Phalacrocorax_georgianus", tree1$tip.label)
tree1$tip.label <- gsub("Phalaropus_tricolor", "Steganopus_tricolor", tree1$tip.label)


# What's missing from the tree?
x <- name.check(tree1, seabirds, data.names = seabirds$HBWv8.1_Binomial)
x$data_not_tree
length(x$data_not_tree) # Should be 7

# These species should be missing. These are generally species recently elevated 
# from subspecies, or where the taxonomy is debated. We can add these to the 
# pruned tree

#[1] "Calonectris_borealis"        "Gygis_candida"              
#[3] "Gygis_microrhyncha"          "Larus_smithsonianus"        
#[5] "Pelecanoides_whenuahouensis" "Pterodroma_deserta"         
#[7] "Thalassarche_impavida"       

#------------------
# Prune tree
# -----------------
seabird_tree <- drop.tip(tree1, x$tree_not_data) 
# Check
str(seabird_tree)
# should have 382 tips
 
# -------------------- 
# Add missing species
# --------------------
# 
# Read in the data
to_add <- read_csv("data-raw/tips-to-add.csv")

for (i in 1:length(to_add$Species)){
  node <- which(seabird_tree$tip.label == to_add$Tip[i])
  seabird_tree <- bind.tip(seabird_tree, tip.label = to_add$Species[i],
                 where = node, position = 0.0001)
}

str(seabird_tree)
# should have 389 tips

# Write out
write.nexus(seabird_tree, file = "data/seabird-tree-HBW-2024-09-30.nex")