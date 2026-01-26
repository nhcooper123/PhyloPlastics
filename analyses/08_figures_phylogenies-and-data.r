# Phylogeny figure
# Figure 2 in text
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
# Read in the data and tree
# -------------------------
# Read in the tree of species in the study
seabird_tree <- read.nexus("data/seabird-tree-plastic-2026.nex") 
# Remove _ from tip labels
seabird_tree$tip.label <- gsub("_", " ", seabird_tree$tip.label)

# Read in the data
plastic_data <- read_csv("data/plastic-data-aggregated_2026.csv")
# Check data
str(plastic_data)

# --------------------------------------------------
# Create summary dataset with one species per line
# --------------------------------------------------
# Summarise to get mean FO
species_plastic <- plastic_data %>%
  group_by(order, clements2025_binomial) %>%
  summarise(
    species_n = sum(n_total), 
    species_plastic = sum(n_plastic), 
    mean_species_FO = mean(FO), 
    mean_species_FO_weighted = weighted.mean(FO, n_total)) %>%
  ungroup()

# Select out trait data and recombine with summary plastic data
species_traits <- plastic_data %>%
  select(clements2025_binomial, order, family, body_mass_g:terrestrial_feeding) %>%
  distinct()

# Merge
species_plastic <- 
  as.data.frame(full_join(species_plastic, species_traits)) %>%
  # for ggtree to work species names MUST be the first column
  dplyr::select(clements2025_binomial, everything())

# Check it
str(species_plastic)

# Reorder to match tree
species_plastic <- species_plastic[match(seabird_tree$tip.label, species_plastic$clements2025_binomial), ]

## --------------------------------------------------
# Plotting the tree - separate categories
# --------------------------------------------------
# Note that this code will throw lots of warnings about scales which can be ignored

# Create the basic tree 
base_tree <- ggtree(seabird_tree, layout = "fan", open.angle = 10) %<+% species_plastic +
  theme(legend.position = "right")
# --------------------------------------------------
# Add diet data
# --------------------------------------------------
# Add carrion as first ring
carrion_tree <- base_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = as.factor(carrion)),
             colour = "#EBECF0",# colour the lines between the boxes
             width = 4, # width of box       
             offset = 0.04, # distance from tree
             grid.params = list(), # show gridlines
             axis.params = list(axis = "x", text = "A", text.size = 1.5, vjust = 1)) + # add labels
  scale_fill_manual(values = c("#EBECF0","#09BC8A")) # define colours

# Add cephalopods
cephalopod_tree <- 
  carrion_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = as.factor(cephalopods)),
             colour = "#EBECF0",
             width = 4,      
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "B", text.size = 1.5, vjust = 1)) +
  scale_fill_manual(values = c("#EBECF0","#09BC8A"))

# Add crustaceans
crustacean_tree <- cephalopod_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = as.factor(crustaceans)),
             colour = "#EBECF0",
             width = 4,        # Width of the diet ring
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "C", text.size = 1.5, vjust = 1)) +
  scale_fill_manual(values = c("#EBECF0","#09BC8A"))

# Add fish
fish_tree <- crustacean_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = as.factor(fish)),
             colour = "#EBECF0",
             width = 4,       
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "D", text.size = 1.5, vjust = 1)) +
  scale_fill_manual(values = c("#EBECF0","#09BC8A"))

# Add other inverts
invert_tree <- fish_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = as.factor(other_inverts)),
             colour = "#EBECF0",
             width = 4,        
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "E", text.size = 1.5, vjust = 1)) + 
  scale_fill_manual(values = c("#EBECF0","#09BC8A"))

# --------------------------------------------------
# Add feeding method data
# --------------------------------------------------
# Add aerial pursuit
aerial_tree <- invert_tree + 
  new_scale_fill() + # add new scale so we can use different colours
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = as.factor(aerial_pursuit)),
             colour = "#EBECF0",# colour the lines between the boxes
             width = 4, # width of box       
             offset = 0.04, # distance from tree
             grid.params = list(), # show gridlines
             axis.params = list(axis = "x", text = "F", text.size = 1.5, vjust = 1)) + # add labels
  scale_fill_manual(values = c("#EBECF0","#74CEF7")) # define colours

# Add bottom feeding
bottom_tree <- 
  aerial_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = as.factor(bottom_feeding)),
             colour = "#EBECF0",
             width = 4,      
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "G", text.size = 1.5, vjust = 1)) +
  scale_fill_manual(values = c("#EBECF0","#74CEF7"))

# Add diving
diving_tree <- bottom_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = as.factor(diving)),
             colour = "#EBECF0",
             width = 4,        
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "H", text.size = 1.5, vjust = 1)) +
  scale_fill_manual(values = c("#EBECF0","#74CEF7"))

# Add plunging
plunging_tree <- diving_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = as.factor(plunging)),
             colour = "#EBECF0",
             width = 4,       
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "I", text.size = 1.5, vjust = 1)) +
  scale_fill_manual(values = c("#EBECF0","#74CEF7"))

# Add terrestrial
terr_tree <- plunging_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = as.factor(terrestrial_feeding)),
             colour = "#EBECF0",
             width = 4,        
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "J", text.size = 1.5, vjust = 1)) + 
  scale_fill_manual(values = c("#EBECF0","#74CEF7"))

# Add scavenging
scavenge_tree <- terr_tree + 
    geom_fruit(geom = geom_tile,
               mapping = aes(fill = as.factor(scavenging)),
                             colour = "#EBECF0",
                             width = 4,        
                             offset = 0.04,
                             grid.params = list(),
                             axis.params = list(axis = "x", text = "K", text.size = 1.5, vjust = 1)) + 
                 scale_fill_manual(values = c("#EBECF0","#74CEF7"))

# Add skimming
skim_tree <- scavenge_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = as.factor(skimming)),
             colour = "#EBECF0",
             width = 4,        
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "L", text.size = 1.5, vjust = 1)) + 
  scale_fill_manual(values = c("#EBECF0","#74CEF7"))

# Add surface seizing
surface_tree <- skim_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = as.factor(surface_seizing)),
             colour = "#EBECF0",
             width = 4,        
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "M", text.size = 1.5, vjust = 1)) + 
  scale_fill_manual(values = c("#EBECF0","#74CEF7"))

# --------------------------------------------------  
# Remove the legend
# --------------------------------------------------
tree_final <- surface_tree + theme(legend.position = "none")

# --------------------------------------------------  
# Label families
# --------------------------------------------------  
# Extract MRCAs 
anatidae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Anatidae")])
alcidae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Alcidae")])
laridae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Laridae")])
scolopacidae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Scolopacidae")])
stercorariidae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Stercorariidae")])
gaviidae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Gaviidae")])
pelecanidae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Pelecanidae")])
phaethontidae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Phaethontidae")])
procellariidae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Procellariidae")])
diomedeidae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Diomedeidae")])
oceanitidae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Oceanitidae")])
hydrobatidae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Hydrobatidae")])
spheniscidae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Spheniscidae")])
fregatidae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Fregatidae")])
phalacrocoracidae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Phalacrocoracidae")])
sulidae <- findMRCA(tree = seabird_tree, tips = species_plastic$clements2025_binomial[which(species_plastic$family == "Sulidae")])

# add to tree
tree_final + 
# anseriforms
  geom_cladelab(node = anatidae, 
                label = "", 
                 offset.text = 5,
                  barcolour = order_colours[1],
                  barsize = 2,
                  offset = 50) +
# charadriiforms
geom_cladelab(node = alcidae, 
              label = "", 
              offset.text = 7,
              barcolour = order_colours[2],
              barsize = 2,
              offset = 50) +
  geom_cladelab(node = laridae, 
                label = "", 
                offset.text = 12,
                barcolour = order_colours[2],
                barsize = 2,
                offset = 50) +
  geom_cladelab(node = scolopacidae, 
                label = "", 
                offset.text = 5,
                barcolour = order_colours[2],
                barsize = 2,
                offset = 50) +
  geom_cladelab(node = stercorariidae, 
                label = "", 
                offset.text = 5,
                barcolour = order_colours[2],
                barsize = 2,
                offset = 50) +
  # gaviiforms
geom_cladelab(node = gaviidae, 
                label = "", 
                offset.text = 45,
                barcolour = order_colours[3],
                barsize = 2,
                offset = 50) +
# pelecaniforms
geom_cladelab(node = pelecanidae, 
             label = "", 
             offset.text = 45,
             barcolour = order_colours[4],
             barsize = 2,
             offset = 50) +
  # phaethontiforms
  geom_cladelab(node = phaethontidae, 
                label = "", 
                offset.text = 45,
                barcolour = order_colours[5],
                barsize = 2,
                offset = 50) +
  # procellariformes
  geom_cladelab(node = procellariidae, 
                label = "", 
                offset.text = 20,
                barcolour = order_colours[6],
                barsize = 2,
                offset = 50) +
  geom_cladelab(node = diomedeidae, 
                label = "", 
                offset.text = 35,
                barcolour = order_colours[6],
                barsize = 2,
                offset = 50) +
  geom_cladelab(node = oceanitidae, 
                label = "", 
                offset.text = 80,
                barcolour = order_colours[6],
                barsize = 2,
                offset = 50) +
  geom_cladelab(node = hydrobatidae, 
                label = "", 
                offset.text = 80,
                barcolour = order_colours[6],
                barsize = 2,
                offset = 50) +
#penguins
  geom_cladelab(node = spheniscidae, 
                label = "", 
                offset.text = 100,
                barcolour = order_colours[7],
                barsize = 2,
                offset = 50) +
  #suliiforms
  geom_cladelab(node = fregatidae, 
                label = "", 
                offset.text = 80,
                barcolour = order_colours[8],
                barsize = 2,
                offset = 50) +
  geom_cladelab(node = phalacrocoracidae, 
                label = "", 
                offset.text = 150,
                barcolour = order_colours[8],
                barsize = 2,
                offset = 50) +
  geom_cladelab(node = sulidae, 
                label = "", 
                offset.text = 80,
                barcolour = order_colours[8],
                barsize = 2,
                offset = 50)
  
# Write to file
# ggsave("figures/figureS3-tree-diet-feeding-families.png", width = 8, height = 8)
 
# --------------------------------------------------
# Figure 2(?)
# Just species weighted mean FO coloured by order
# --------------------------------------------------               
# Add FO as bars coloured by order
tree_FO <- 
  base_tree + 
  geom_fruit(geom = geom_col,
             mapping = aes(x = mean_species_FO_weighted, fill = order),
             #fill = "grey80",
             offset = 0.04,     # Small gap from feeding method ring
             width = 1, 
             pwidth = 0.5, # make bars a bit larger compared to tree, deafult is 0.2 
             axis.params = list(axis = "x", 
                                text.size = 1.5,
                                hjust = c(-1, -0.5, -0.5, -0.5, -0.5, -1),
                                vjust = 0,
                                nbreak = 5,
                                text.angle=-90),
             grid.params=list(alpha = 0.5)) + # to force the gridlines for the bars
  scale_fill_manual(values = order_colours) 

#----------------
# Add family labels
# names removed - these are hard to make look good in ggtree
# add them in inkscape instead

tree_FO + 
  # anseriforms
  geom_cladelab(node = anatidae, 
                label = "", 
                barcolour = order_colours[1],
                barsize = 2,
                offset = 50) +
  # charadriiforms
  geom_cladelab(node = alcidae, 
                label = "", 
                barcolour = order_colours[2],
                barsize = 2,
                offset = 50) +
  geom_cladelab(node = laridae, 
                label = "", 
                barcolour = order_colours[2],
                barsize = 2,
                offset = 50) +
  geom_cladelab(node = scolopacidae, 
                label = "", 
                barcolour = order_colours[2],
                barsize = 2,
                offset = 50) +
  geom_cladelab(node = stercorariidae, 
                label = "", 
                barcolour = order_colours[2],
                barsize = 2,
                offset = 50) +
  # gaviiforms
  geom_cladelab(node = gaviidae, 
                label = "",
                barcolour = order_colours[3],
                barsize = 2,
                offset = 50) +
  # pelecaniforms
  geom_cladelab(node = pelecanidae, 
                label = "", 
                barcolour = order_colours[4],
                barsize = 2,
                offset = 50) +
  # phaethontiforms
  geom_cladelab(node = phaethontidae, 
                label = "", 
                barcolour = order_colours[5],
                barsize = 2,
                offset = 50) +
  # procellariformes
  geom_cladelab(node = procellariidae, 
                label = "", 
                barcolour = order_colours[6],
                barsize = 2,
                offset = 50) +
  geom_cladelab(node = diomedeidae, 
                label = "", 
                barcolour = order_colours[6],
                barsize = 2,
                offset = 50) +
  geom_cladelab(node = oceanitidae, 
                label = "", 
                barcolour = order_colours[6],
                barsize = 2,
                offset = 50) +
  geom_cladelab(node = hydrobatidae, 
                label = "", 
                barcolour = order_colours[6],
                barsize = 2,
                offset = 50) +
  #penguins
  geom_cladelab(node = spheniscidae, 
                label = "", 
                barcolour = order_colours[7],
                barsize = 2,
                offset = 50) +
  #suliiforms
  geom_cladelab(node = fregatidae, 
                label = "", 
                barcolour = order_colours[8],
                barsize = 2,
                offset = 50) +
  geom_cladelab(node = phalacrocoracidae, 
                label = "", 
                barcolour = order_colours[8],
                barsize = 2,
                offset = 50) +
  geom_cladelab(node = sulidae, 
                label = "", 
                barcolour = order_colours[8],
                barsize = 2,
                offset = 50)

# Write to file
# ggsave("figures/figure2-tree-FO-families.jpeg", width = 8, height = 8)