# Extract seabirds from Clements taxonomy
# Citation: Clements, J. F., P. C. Rasmussen, T. S. Schulenberg, M. J. Iliff, T. A. Fredericks, J. A. Gerbracht, D. Lepage, A. Spencer, S. M. Billerman, B. L. Sullivan, M. Smith, and C. L. Wood. 2024. The eBird/Clements checklist of Birds of the World: v2024. 
# Downloaded from https://www.birds.cornell.edu/clementschecklist/download/
# Natalie Cooper Sept 2025. 
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
# We also exclude the extinct species Camptorhynchus labradorius, Hydrobates macrodactylus
# Bulweria_bifax, Mergus_australis, Pinguinus_impennis, Pterodroma_rupinarum, and Urile_perspicillatus
# -----------------------------------------
# Load libraries
library(readxl)
library(tidyverse)

# Read in HBW taxonomy
# skip first 3 lines as data starts on row 4
# Also exclude the last several thousand entries which describe non-valid taxa
birds <- read_csv(path = "data-raw/Clements_Taxonomy_2024.csv")

# Select only species
birds <- 
  birds %>%
  filter(category == "species")

# Select seabirds
seabirds <- 
  birds %>%
  # Split species name into Genus and species
  separate(scientific.name, c("genus", "species"), remove = FALSE) %>%
  # Select orders/families/tribes/genera containing seabirds
  filter(order == "Suliformes" | 
         order ==  "Sphenisciformes" | 
         order ==  "Procellariiformes" | 
         order ==  "Phaethontiformes" |
         order == "Gaviiformes"|
         family == "Pelecanidae (Pelicans)"|
         family == "Alcidae (Auks, Murres, and Puffins)"|
         family == "Stercorariidae (Skuas and Jaegers)"|
         family == "Laridae (Gulls, Terns, and Skimmers)"|
         genus == "Phalaropus" |
         genus == "Steganopus" |
         genus == "Clangula" |
         genus == "Somateria" |
         genus == "Polysticta" |
         genus == "Melanitta" |
         genus == "Bucephala" |
         genus == "Mergellus" |
         genus == "Lophodytes" |
         genus == "Mergus" |
         genus == "Histrionicus") %>%
  # Remove Anhingidae from Suliformes
  filter(family != "Anhingidae (Anhingas)") %>%
  # Remove extinct species
  filter(scientific.name != "Camptorhynchus labradorius" &
         scientific.name != "Hydrobates macrodactylus" &
         scientific.name != "Bulweria bifax" &
         scientific.name != "Mergus australis" &
         scientific.name != "Pinguinus impennis" &
         scientific.name != "Pterodroma rupinarum" &
         scientific.name != "Urile perspicillatus") %>%
  # select only the required columns and tidy up names a bit
  dplyr::select(Clements2024_Order = order, Clements2024_Family = family,
                Clements2024_Common_name = English.name, Clements2024_Binomial = scientific.name, 
                Clements2024_Genus = genus) %>%
  distinct(Clements2024_Binomial, .keep_all = TRUE)

# Save the list
write_csv(seabirds, file = "data-raw/seabird-list-Clements2024_2025-09-10.csv")

#---------------------
# Summarise the data
# -------------------

# By order
seabirds %>% group_by(Clements2024_Order) %>% summarise(n())
# By family
seabirds %>% group_by(Clements2024_Family) %>% summarise(n())
# Total
seabirds %>% summarise(n()) #384
