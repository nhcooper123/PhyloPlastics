
library(ape)
# https://github.com/McTavishLab/AvesData/tree/main/Tree_versions/Aves_1.2/Clements2023

trees <- read.tree("data-raw/dated_sample_2023.tre") #sample of 100 dated trees
tree1 <- read.nexus("data-raw/summary_dated_clements.nex") #mcc tree

plot(tree1)
str(tree1)

