# Phylogeny figure 1
# Oct 2025
# Natalie Cooper
# -------------------------------
# Load libraries
# -------------------------------
library(ape)
library(ggtree)
library(ggtreeExtra) #geom_fruit
library(tidyverse)
library(ggnewscale)
library(phytools)

order_colours <- c("#ffd92f","#fc8d62","#8da0cb","#b3b3b3",
                   "#a6d854","#66c2a5","#e5c494","#e78ac3")

# -------------------------
# #---------------------------------------------------------------
# Figure 1 (?)
# Summarising which species have been studied and which have not
#---------------------------------------------------------------
# Read in dataset for all species
results <- read_csv("output/results-for-tree-plotting.csv")

#reorder so species names are in first column
results <- select(results, clements2024_binomial, everything())
#---------------------------------------------------------------
# Read in tree for all species
seabird_tree <- read.nexus("data/seabird-tree-Claramont2025_2025-09-11.nex")
# Remove _ from tip labels
seabird_tree$tip.label <- gsub("_", " ", species_tree$tip.label)
#---------------------------------------------------------------
# Create the basic tree 
# throws warning but unsure why
base_tree <- ggtree(seabird_tree, layout = "fan", open.angle = 10) %<+% results +
  theme(legend.position = "right")

#---------------------------------------------------------------
# Add data attributes
# 
# Add studied or not as first ring
studied_tree <- base_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = as.factor(studied)),
             #colour = "#EBECF0",# colour the lines between the boxes
             width = 4, # width of box       
             offset = 0.04, # distance from tree
             grid.params = list(), # show gridlines
             axis.params = list(axis = "x", text = "A", text.size = 1.5, vjust = 1)) + # add labels
  scale_fill_manual(values = c("#EBECF0","#09BC8A")) # define colours


# Add plastic
plastic_tree <- 
  studied_tree + 
  new_scale_fill() + # add new scale so we can use different colours
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = as.factor(plastic)),
            #colour = "#EBECF0",
             width = 4,      
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "B", text.size = 1.5, vjust = 1)) +
  scale_fill_manual(values = c("#EBECF0","black"), na.value="#EBECF0")

# Add well studied
well_tree <- 
  plastic_tree + 
  new_scale_fill() + # add new scale so we can use different colours
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = as.factor(well_studied)),
             #colour = "#EBECF0",
             width = 4,      
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "C", text.size = 1.5, vjust = 1)) +
  scale_fill_manual(values = c("#EBECF0","#74CEF7"))

# --------------------------------------------------  
# Remove the legend
# --------------------------------------------------
tree_final <- well_tree + theme(legend.position = "none")
# check tree
tree_final
# --------------------------------------------------  
# Label families
# --------------------------------------------------  
# Extract MRCAs 
anatidae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Anatidae")])
alcidae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Alcidae")])
laridae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Laridae")])
scolopacidae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Scolopacidae")])
stercorariidae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Stercorariidae")])
gaviidae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Gaviidae")])
pelecanidae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Pelecanidae")])
phaethontidae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Phaethontidae")])
procellariidae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Procellariidae")])
diomedeidae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Diomedeidae")])
oceanitidae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Oceanitidae")])
hydrobatidae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Hydrobatidae")])
spheniscidae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Spheniscidae")])
fregatidae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Fregatidae")])
phalacrocoracidae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Phalacrocoracidae")])
sulidae <- findMRCA(tree = seabird_tree, tips = results$clements2024_binomial[which(results$Family == "Sulidae")])

# add to tree
tree_final + 
  # anseriforms
  geom_cladelab(node = anatidae, 
                label = "",
                barcolour = order_colours[1],
                barsize = 2,
                offset = 12) +
  # charadriiforms
  geom_cladelab(node = alcidae, 
                label = "",
                barcolour = order_colours[2],
                barsize = 2,
                offset = 12) +
  geom_cladelab(node = laridae, 
                label = "",
                barcolour = order_colours[2],
                barsize = 2,
                offset = 12) +
  geom_cladelab(node = scolopacidae, 
                label = "",
                barcolour = order_colours[2],
                barsize = 2,
                offset = 12) +
  geom_cladelab(node = stercorariidae, 
                label = "",
                barcolour = order_colours[2],
                barsize = 2,
                offset = 12) +
  # gaviiforms
  geom_cladelab(node = gaviidae, 
                label = "",
                barcolour = order_colours[3],
                barsize = 2,
                offset = 12) +
  # pelecaniforms
  geom_cladelab(node = pelecanidae, 
                label = "",
                barcolour = order_colours[4],
                barsize = 2,
                offset = 12) +
  # phaethontiforms
  geom_cladelab(node = phaethontidae, 
                label = "",
                barcolour = order_colours[5],
                barsize = 2,
                offset = 12) +
  # procellariformes
  geom_cladelab(node = procellariidae, 
                label = "",
                barcolour = order_colours[6],
                barsize = 2,
                offset = 12) +
  geom_cladelab(node = diomedeidae, 
                label = "",
                barcolour = order_colours[6],
                barsize = 2,
                offset = 12) +
  geom_cladelab(node = oceanitidae, 
                label = "",
                barcolour = order_colours[6],
                barsize = 2,
                offset = 12) +
  geom_cladelab(node = hydrobatidae, 
                label = "",
                barcolour = order_colours[6],
                barsize = 2,
                offset = 12) +
  #penguins
  geom_cladelab(node = spheniscidae, 
                label = "",
                barcolour = order_colours[7],
                barsize = 2,
                offset = 12) +
  #suliiforms
  geom_cladelab(node = fregatidae, 
                label = "",
                barcolour = order_colours[8],
                barsize = 2,
                offset = 12) +
  geom_cladelab(node = phalacrocoracidae, 
                label = "",
                barcolour = order_colours[8],
                barsize = 2,
                offset = 12) +
  geom_cladelab(node = sulidae, 
                label = "",
                barcolour = order_colours[8],
                barsize = 2,
                offset = 12)

# Write to file
# ggsave("figures/tree-plastic-studies-families.png", width = 8, height = 8)
