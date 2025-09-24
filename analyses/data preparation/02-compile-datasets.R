# Prepare datasets with updated taxonomy
# Clements 2024 to match Claramunt 2025 tree
# Sept 2025
#-----------------------------------------
# Load libraries
library(tidyverse)

#-----------------------------------------
# Read in seabird list
birds <- read_csv("data-raw/seabird-list-Clements2024_2025-09-10.csv")

#------------------------------------------
# 1. Ingestion data
#------------------------------------------
# Read in the ingestion data
ingestion <- read_csv("data-raw/02_plastic-ingestion-data_2025-09-09.csv")

# Update taxonomy to match Clements 2024
ingestion$HBWv8.1_Binomial <- gsub("Catharacta antarctica", "Stercorarius antarcticus", ingestion$HBWv8.1_Binomial) 
ingestion$HBWv8.1_Binomial <- gsub("Catharacta maccormicki", "Stercorarius maccormicki", ingestion$HBWv8.1_Binomial) 
ingestion$HBWv8.1_Binomial <- gsub("Catharacta skua", "Stercorarius skua", ingestion$HBWv8.1_Binomial) 
ingestion$HBWv8.1_Binomial <- gsub("Gygis candida", "Gygis alba", ingestion$HBWv8.1_Binomial) 
ingestion$HBWv8.1_Binomial <- gsub("Larus atricilla", "Leucophaeus atricilla", ingestion$HBWv8.1_Binomial) 
ingestion$HBWv8.1_Binomial <- gsub("Larus audouinii", "Ichthyaetus audouinii", ingestion$HBWv8.1_Binomial) 
ingestion$HBWv8.1_Binomial <- gsub("Larus cirrocephalus", "Chroicocephalus cirrocephalus", ingestion$HBWv8.1_Binomial) 
ingestion$HBWv8.1_Binomial <- gsub("Larus hartlaubii", "Chroicocephalus hartlaubii", ingestion$HBWv8.1_Binomial) 
ingestion$HBWv8.1_Binomial <- gsub("Larus melanocephalus", "Ichthyaetus melanocephalus", ingestion$HBWv8.1_Binomial) 
ingestion$HBWv8.1_Binomial <- gsub("Larus novaehollandiae", "Chroicocephalus novaehollandiae", ingestion$HBWv8.1_Binomial) 
ingestion$HBWv8.1_Binomial <- gsub("Larus philadelphia", "Chroicocephalus philadelphia", ingestion$HBWv8.1_Binomial) 
ingestion$HBWv8.1_Binomial <- gsub("Larus ridibundus", "Chroicocephalus ridibundus", ingestion$HBWv8.1_Binomial) 
ingestion$HBWv8.1_Binomial <- gsub("Thalassarche impavida", "Thalassarche melanophris", ingestion$HBWv8.1_Binomial) 
ingestion$HBWv8.1_Binomial <- gsub("Thalassarche steadi", "Thalassarche cauta", ingestion$HBWv8.1_Binomial) 

# Combine with Clements taxonomy
both <- left_join(ingestion, birds, by = join_by(HBWv8.1_Binomial == Clements2024_Binomial))

# Remove un-necessary columns and reorganise
cleaned_data <-
  both %>%
  dplyr::select(Clements2024_Binomial = HBWv8.1_Binomial, UniqueID_Plastic.study:Sampling_method)

# Save file
write_csv(cleaned_data, "data-raw/plastic-ingestion-data-2025-09-12.csv")

#------------------------------------------
# 2. Trait data
#------------------------------------------
# Read in the old data and modify as needed
traits <- read_csv("data-raw/03_trait-data-2025-09-24.csv")

# Update taxonomy to match Clements 2024
traits$HBWv8.1_Binomial <- gsub("Catharacta antarctica", "Stercorarius antarcticus", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Catharacta maccormicki", "Stercorarius maccormicki", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Catharacta skua", "Stercorarius skua", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Gygis candida", "Gygis alba", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus atricilla", "Leucophaeus atricilla", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus audouinii", "Ichthyaetus audouinii", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus cirrocephalus", "Chroicocephalus cirrocephalus", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus hartlaubii", "Chroicocephalus hartlaubii", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus melanocephalus", "Ichthyaetus melanocephalus", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus novaehollandiae", "Chroicocephalus novaehollandiae", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus philadelphia", "Chroicocephalus philadelphia", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus ridibundus", "Chroicocephalus ridibundus", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Thalassarche impavida", "Thalassarche melanophris", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Thalassarche steadi", "Thalassarche cauta", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Steganopus tricolor", "Phalaropus tricolor", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Catharacta chilensis", "Stercorarius chilensis", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus genei", "Chroicocephalus genei", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus bulleri", "Chroicocephalus bulleri", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus serranus", "Chroicocephalus serranus", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus maculipennis", "Chroicocephalus maculipennis", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus modestus", "Leucophaeus modestus", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus brunnicephalus", "Chroicocephalus brunnicephalus", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus scoresbii", "Leucophaeus scoresbii", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus pipixcan", "Leucophaeus pipixcan", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus fuliginosus", "Leucophaeus fuliginosus", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus ichthyaetus", "Ichthyaetus ichthyaetus", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus relictus", "Ichthyaetus relictus", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus hemprichii", "Ichthyaetus hemprichii", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Larus leucophthalmus", "Ichthyaetus leucophthalmus", traits$HBWv8.1_Binomial) 
traits$HBWv8.1_Binomial <- gsub("Anous albivittus", "Anous albivitta", traits$HBWv8.1_Binomial) 

#--------------------------------------------
# Combine old data with new taxonomy
# Join is based on tree as old data does not have species names
# Only keeps species that match new taxonomy - excludes extinct species
both_traits <- right_join(traits, birds, by = join_by(HBWv8.1_Binomial == Clements2024_Binomial))

#--------------------------------------------
# Remove un-necessary columns and reorganise
cleaned_traits <- 
  both_traits %>%
  select(Clements2024_Binomial = HBWv8.1_Binomial,
         Order = Clements2024_Order, Family = HBWv8.1_Family, Genus = Clements2024_Genus,
         Common.Name = Clements2024_Common_name, Feeding.method = Feeding.Method.Simple, Diet,
         Fish, Cephalopods, Crustaceans, Other.Inverts, Carrion = Carrion.NonFishVertebrates, 
         Anthropogenic.Subsidy, Pelagic.Specialist = pelagic_specialist_CR, 
         Body.Mass.g, AS.Fishery, AS.Refuse, AS.Agriculture, aerial_pursuit, bottom_feeding,
         diving, plunging, scavenging, skimming, surface_seizing, terrestrial_feeding)

# Save file
write_csv(cleaned_traits, "data-raw/trait-data-2025-09-24.csv")
