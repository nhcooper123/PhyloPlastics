# Phylogeny figure
# Sept 2025
# Natalie Cooper
# -------------------------------
# Load libraries
# -------------------------------
library(ape)
library(ggtree)
library(ggtreeExtra) #geom_fruit
library(tidyverse)
library(ggnewscale)

order_colours <- c("#ffd92f","#fc8d62","#8da0cb","#b3b3b3",
                   "#a6d854","#66c2a5","#e5c494","#e78ac3")

feeding_colours <- c("#F94144","#F3722C","#F8961E",
                             "#F9C74F","#90BE6D","#43AA8B",
                             "#577590")
diet_colours <- c("#F94144","#F3722C","#F9C74F","#90BE6D","#577590")
# -------------------------
# Read in the data and tree
# -------------------------
# Read in the tree of species in the study
seabird_tree <- read.nexus("data/seabird_tree_plastic_2025-09-15.nex") 
# Remove _ from tip labels
seabird_tree$tip.label <- gsub("_", " ", seabird_tree$tip.label)

# Read in the data
plastic_data <- read_csv("data/plastic-data-aggregated_2025-09-24.csv")
# Check data
str(plastic_data)

# --------------------------------------------------
# Create summary dataset with one species per line
# --------------------------------------------------
# Summarise to get mean FO
species_plastic <- plastic_data %>%
  group_by(order, clements2024_binomial) %>%
  summarise(
    species_n = sum(n_total), 
    species_plastic = sum(n_plastic), 
    mean_species_FO = mean(FO), 
    mean_species_FO_weighted = weighted.mean(FO, n_total)) %>%
  ungroup()

# Select out trait data and recombine with summary plastic data
species_traits <- plastic_data %>%
  select(clements2024_binomial, order, body_mass_g:terrestrial_feeding) %>%
  distinct()

# Merge
species_plastic <- 
  as.data.frame(full_join(species_plastic, species_traits)) %>%
  # for ggtree to work species names MUST be the first column
  dplyr::select(clements2024_binomial, everything())

# Check it
str(species_plastic)

# Reorder to match tree
species_plastic <- species_plastic[match(seabird_tree$tip.label, species_plastic$clements2024_binomial), ]

## --------------------------------------------------
# Plotting the tree - separate categories
# --------------------------------------------------
# Note that this code will throw lots of warnings about scales which can be ignored

# Create the basic tree 
base_tree <- ggtree(seabird_tree, layout = "fan", open.angle = 10) %<+% species_plastic +
  theme(legend.position = "right")


base_tree + geom_cladelab(node = 242, label = "hi") 
# --------------------------------------------------
# Add diet data
# --------------------------------------------------
# Add carrion as first ring
carrion_tree <- base_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = carrion),
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
             mapping = aes(fill = cephalopods),
             colour = "#EBECF0",
             width = 4,      
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "B", text.size = 1.5, vjust = 1)) +
  scale_fill_manual(values = c("#EBECF0","#09BC8A"))

# Add crustaceans
crustacean_tree <- cephalopod_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = crustaceans),
             colour = "#EBECF0",
             width = 4,        # Width of the diet ring
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "C", text.size = 1.5, vjust = 1)) +
  scale_fill_manual(values = c("#EBECF0","#09BC8A"))

# Add fish
fish_tree <- crustacean_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = fish),
             colour = "#EBECF0",
             width = 4,       
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "D", text.size = 1.5, vjust = 1)) +
  scale_fill_manual(values = c("#EBECF0","#09BC8A"))

# Add other inverts
invert_tree <- fish_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = other_inverts),
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
             mapping = aes(fill = aerial_pursuit),
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
             mapping = aes(fill = bottom_feeding),
             colour = "#EBECF0",
             width = 4,      
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "G", text.size = 1.5, vjust = 1)) +
  scale_fill_manual(values = c("#EBECF0","#74CEF7"))

# Add diving
diving_tree <- bottom_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = diving),
             colour = "#EBECF0",
             width = 4,        
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "H", text.size = 1.5, vjust = 1)) +
  scale_fill_manual(values = c("#EBECF0","#74CEF7"))

# Add plunging
plunging_tree <- diving_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = plunging),
             colour = "#EBECF0",
             width = 4,       
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "I", text.size = 1.5, vjust = 1)) +
  scale_fill_manual(values = c("#EBECF0","#74CEF7"))

# Add terrestrial
terr_tree <- plunging_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = terrestrial_feeding),
             colour = "#EBECF0",
             width = 4,        
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "J", text.size = 1.5, vjust = 1)) + 
  scale_fill_manual(values = c("#EBECF0","#74CEF7"))

# Add scavenging
scavenge_tree <- terr_tree + 
    geom_fruit(geom = geom_tile,
               mapping = aes(fill = scavenging),
                             colour = "#EBECF0",
                             width = 4,        
                             offset = 0.04,
                             grid.params = list(),
                             axis.params = list(axis = "x", text = "K", text.size = 1.5, vjust = 1)) + 
                 scale_fill_manual(values = c("#EBECF0","#74CEF7"))

# Add skimming
skim_tree <- scavenge_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = skimming),
             colour = "#EBECF0",
             width = 4,        
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "L", text.size = 1.5, vjust = 1)) + 
  scale_fill_manual(values = c("#EBECF0","#74CEF7"))

# Add surface seizing
surface_tree <- skim_tree + 
  geom_fruit(geom = geom_tile,
             mapping = aes(fill = surface_seizing),
             colour = "#EBECF0",
             width = 4,        
             offset = 0.04,
             grid.params = list(),
             axis.params = list(axis = "x", text = "M", text.size = 1.5, vjust = 1)) + 
  scale_fill_manual(values = c("#EBECF0","#74CEF7"))

# --------------------------------------------------
# Add species weighted mean FO
# --------------------------------------------------               
# Add FO as grey bars
tree_final <- 
  surface_tree + 
  new_scale_fill() + # set new scale for bars 
  geom_fruit(geom = geom_col,
             mapping = aes(x = mean_species_FO_weighted),
             fill = "grey80",
             offset = 0.04,     # Small gap from feeding method ring
             width = 1,         
             axis.params = list(axis = "x", 
                                text.size = 1.5,
                                hjust = c(-1, -0.5, -1),
                                vjust = 0,
                                nbreak = 3,
                                text.angle=-90),
             grid.params=list(alpha = 0.5)) # to force the gridlines for the bars

# --------------------------------------------------  
# Remove the legend
# --------------------------------------------------
tree_final <- tree_final + theme(legend.position = "none")

# Write to file
# ggsave("figures/tree_diet_feeding_FO.png", width = 8, height = 8)

# label families?
# colour branches by order?
# figure for supplemental versus figure for main text
# 
# 
# 
# --------------------------------------------------
# Figure 2
# Just add species weighted mean FO
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
tree_FO + geom_cladelab(aes(node = 10), label = "hi") #, 
    #label = order, colour = order)



tree_FO + groupOTU(p_iris, grp, 'Species') + aes(color=Species)






nodeids <- nodeid(tree, tree$node.label[nchar(tree$node.label)>4])
nodedf <- data.frame(node=nodeids)
nodelab <- gsub("[\\.0-9]", "", tree$node.label[nchar(tree$node.label)>4])
# The layers of clade and hightlight
poslist <- c(1.6, 1.4, 1.6, 0.8, 0.1, 0.25, 1.6, 1.6, 1.2, 0.4,
             1.2, 1.8, 0.3, 0.8, 0.4, 0.3, 0.4, 0.4, 0.4, 0.6,
             0.3, 0.4, 0.3)
labdf <- data.frame(node=nodeids, label=nodelab, pos=poslist)

# The circular layout tree.
p <- ggtree(tree, layout="fan", size=0.15, open.angle=5) +
  geom_hilight(data=nodedf, mapping=aes(node=node),
               extendto=6.8, alpha=0.3, fill="grey", color="grey50",
               size=0.05) +
  geom_cladelab(data=labdf, 
                mapping=aes(node=node, 
                            label=label,
                            offset.text=pos),
                hjust=0.5,
                angle="auto",
                barsize=NA,
                horizontal=FALSE, 
                fontsize=1.4,
                fontface="italic"
  )

#-----------------------------
# Figure 1
#----------------------------

# Read in dataset for all species
results <- read_csv("output/results-for-tree-plotting.csv")
# Read in tree for all species
#



