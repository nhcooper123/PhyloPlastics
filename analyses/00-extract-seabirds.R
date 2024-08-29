# Extract seabirds from Bird Life taxonomy
# HBW v8.1
# Available at: http://datazone.birdlife.org/userfiles/file/Species/Taxonomy/HBW-BirdLife_Checklist_v81_Jan24.zip
# Natalie Cooper Sept 2024. 
# -----------------------------------------

# Seabirds are defined as follows
# 1) All Sphenisciformes (penguins)
# 2) All Procellariiformes (petrels, albatross etc.)
# 3) All Gaviiformes (divers/loons)
# 4) All Phaethontiformes (tropicbirds)
# 5) All Suliformes (gannets, boobies etc.) except Anghingidae (anhingas)
# 6) Within Pelecaniformes, Pelecanidae (pelicans)
# 7) Within Charadriiformes, Laridae (gulls), Alcidae (auks), Stercorariidae (skuas) and Phalaropus (phalaropes)
# 8) Within Anserifromes, Mergini (diving ducks)
# We also exclude the extinct species Camptorhynchus labradorius and Hydrobates macrodactylus

# -----------------------------------------
# Load libraries
library(readxl)
library(tidyverse)

# Read in HBW taxonomy
# skip first 3 lines as data starts on row 4
birds <- read_xlsx(path = "data-raw/Handbook of the Birds of the World and BirdLife International Digital Checklist of the Birds of the World_Version_81.xlsx",
                   skip = 3)

# Remove anything with NA for order as these are subspecies
birds <- 
  birds %>%
  filter(!is.na(Order))

# Select seabirds
seabirds <- 
  birds %>%
  # Split species name into Genus and species
  separate(`Scientific name`, c("Genus", "Species"), remove = FALSE) %>%
  # Select orders/families/tribes/genera containing seabirds
  filter(Order == "SULIFORMES" | 
         Order ==  "SPHENISCIFORMES" | 
           Order ==  "PROCELLARIIFORMES" | 
           Order ==  "PHAETHONTIFORMES" |
           Order == "GAVIIFORMES"|
           `Family name` == "Pelecanidae" |
           `Family name` == "Alcidae" |
           `Family name` == "Stercorariidae" |
           `Family name` == "Laridae" |
           Tribe == "Mergini" |
           Tribe == "Phalaropodini") %>%
  # Remove Anhingidae from Suliformes
  filter(`Family name` != "Anhingidae") %>%
  # Remove two extinct species
  filter(`Scientific name` != "Camptorhynchus labradorius" &
         `Scientific name` != "Hydrobates macrodactylus") %>%
  # select only the required columns and tidy up names a bit
  dplyr::select(Order, Family = `Family name`, Subfamily, Tribe, 
                Common_name = `Common name`, Binomial = `Scientific name`, 
                Genus, IUCN_2023 = `2023 IUCN Red List category`,
                Synonyms) %>%
  distinct(Binomial, .keep_all = TRUE)

# Save the list
write_csv(seabirds, file = "data-raw/seabird-list-HBW.csv")

#---------------------
# Summarise the data
# -------------------

# By order
seabirds %>% group_by(Order) %>% summarise(n())
# By family
seabirds %>% group_by(Family) %>% summarise(n())
# Total
seabirds %>% summarise(n())
