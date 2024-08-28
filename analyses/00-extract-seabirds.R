# Extract seabirds from birldlife taxonomy

# Seabirds = Sphenisciformes, Procellariiformes, Pelecaniformes, Charadriiformes, Gaviiformes,Anseriformes; Anatidae; Mergini

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
  separate(`Scientific name`, "Genus", "Species", remove = FALSE) %>%
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
           Genus == "Phalaropus") %>%
  # Remove Anhingidae from Suliformes
  filter(Family != "Anhingidae")

  old <- read.csv("data-raw/2022-10-02  Data S1. Behavioural and life-history dataset.YesNo.csv")
  