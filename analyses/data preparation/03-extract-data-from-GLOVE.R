# Extract GLOVE records for correct species
# Match our records with GLOVE
# Oct 2024

# Load libraries
library(readxl)
library(tidyverse)

# Read in GLOVE data
glove <- read_csv("data-raw/Glove-2024-10-01-BIRDS_ONLY.csv")

# Read in plastic ingestion data
ds <- read_csv("data-raw/plastic-ingestion-data-2024-10-02.csv")

glove_seabirds <-
  glove %>%
  # Select orders/families/tribes/genera containing seabirds
  filter(order == "Suliformes" | 
           family == "Phalacrocoracidae" | # in GLOVE these are misclassified within Pelicaniformes
           order ==  "Sphenisciformes" | 
           order ==  "Procellariiformes" | 
           order ==  "Phaethontiformes" |
           order == "Gaviiformes"|
           family == "Pelecanidae" |
           family == "Alcidae" |
           family == "Stercorariidae" |
           family == "Laridae" |
           # GLOVE has no Tribe column so these are the species in 
           # tribe Mergini
           species == "Clangula hyemalis" |
           species == "Somateria fischeri" | 
           species == "Somateria spectabilis" | 
           species == "Somateria mollissima" | 
           species == "Polysticta stelleri" | 
           species == "Melanitta perspicillata" | 
           species == "Melanitta fusca" | 
           species == "Melanitta stejnegeri" | 
           species == "Melanitta deglandi" | 
           species == "Melanitta nigra" | 
           species == "Melanitta americana" | 
           species == "Bucephala albeola" | 
           species == "Bucephala clangula" | 
           species ==  "Bucephala islandica" | 
           species ==  "Mergellus albellus" | 
           species == "Lophodytes cucullatus" | 
           species == "Mergus merganser" | 
           species == "Mergus squamatus" | 
           species == "Mergus serrator" | 
           species == "Mergus australis" | 
           species == "Mergus octosetaceus" | 
           species == "Histrionicus histrionicus" | 
           # GLOVE has no Tribe column so these are the phalaropes
           species == "Steganopus tricolor" | 
           species == "Phalaropus lobatus" | 
           species == "Phalaropus fulicarius") %>%
  # Remove Anhingidae from Suliformes
  filter(family != "Anhingidae") %>%
  # Remove two extinct species
  filter(species != "Camptorhynchus labradorius" &
           species != "Hydrobates macrodactylus"&
           species != "Bulweria bifax" &
           species != "Mergus australis" &
           species != "Pinguinus impennis" &
           species != "Pterodroma rupinarum" &
           species != "Urile perspicillatus")

# Save to file
write_csv(glove_seabirds, file = "data-raw/Glove-2024-10-01-SEABIRDS.csv")
