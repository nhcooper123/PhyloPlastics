# Prepare new datasets from old data
# with updated taxonomy and new columns required

# Load libraries
library(tidyverse)

# Read in corrected taxonomic data from HBW v 8.1
birds <- read_csv("data-raw/seabird-list-HBW-2024-09-30.csv")

#------------------------------------------
# 1. Ingestion data
#------------------------------------------
# Read in the old data and modify as needed
old <- read_csv("data-raw/Old data/2022-08-05 Data S2. Plastic ingestion included records for 50,000 individual birds representing 212 seabird species.csv")

# Remove _ to match to taxonomic data
old$TipLabel_HBWBLv6 <- gsub("_", " ", old$TipLabel_HBWBLv6)
# Correct the spellings of species where names have changed
old$TipLabel_HBWBLv6 <- gsub("Nannopterum auritus", "Nannopterum auritum", old$TipLabel_HBWBLv6)
# Remove the scaup which should be excluded as they aren't seabirds
old <- 
  old %>%
  filter(TipLabel_HBWBLv6 != "Aythya marila")

#--------------------------------------------
# Combine old data with new taxonomy
# Join is based on tree as old data does not have species names
both <- left_join(old, birds, by = join_by(TipLabel_HBWBLv6 == HBWv8.1_Binomial))

#--------------------------------------------
# Add new n_plastic column
# Note that this was not in the original data, but FO is the proportion of
# birds which contained plastic. But we can back calculate using round to remove
# issues with rounding errors
both <- both %>%
  mutate(n_plastic = round(FO * n, digits = 0))

#--------------------------------------------
# Add new scientific name and sampling method columns
both <- both %>%
  mutate(Sci.name_Plastic.study = NA) %>%
  mutate(Sampling_method = NA) %>%
  mutate(Added_by = "SA-G") %>%
  mutate(Comments = NA)

#--------------------------------------------
# Add ocean basin data
old_oceans <- read_csv("data-raw/Old data/2022-08-05 Data S2. Ocean Basins for UniqueID_Plastic_Study(2).csv")

# Remove the scaup records (numbers 351 and 352) which should be excluded as they aren't seabirds
oceans <- 
  old_oceans %>%
  filter(UniqueID_Plastic_study != 351 & UniqueID_Plastic_study != 352) %>%
  rename(UniqueID_Plastic.study = UniqueID_Plastic_study)

# Merge with ingestion data
all <- left_join(both, oceans, by = "UniqueID_Plastic.study")

#----------------------------------------------
# Remove un-necessary columns and reorganise
cleaned_data <- 
  all %>%
  select(SISRecID_BLVr9, HBWv8.1_Binomial = TipLabel_HBWBLv6, UniqueID_Plastic.study, Source,
         Common.name_Plastic.study, Sci.name_Plastic.study,
         Site = Site.x, lat = lat.x, lon = lon.x, MarineRegion, Age.Class, Date_Text, Date_FirstYR, Date_LastYR, Date_MedianYR, Study.Duration, 
         n, n_plastic, FO, Plastic, Sampling_method, Added_by, Comments)

# Save file
write_csv(cleaned_data, "data-raw/plastic-ingestion-data-2024-10-02.csv")

#------------------------------------------
# 2. Trait data
#------------------------------------------
# Read in the old data and modify as needed
old_traits <- read_csv("data-raw/Old data/2022-10-02  Data S1. Behavioural and life-history dataset.YesNo.csv")

# Correct the spellings of species where names have changed
old_traits$Scientific.name_HBWBLv6 <- gsub("Nannopterum auritus", "Nannopterum auritum", old_traits$Scientific.name_HBWBLv6)
old_traits$Scientific.name_HBWBLv6 <- gsub("Nannopterum brasilianus", "Nannopterum brasilianum", old_traits$Scientific.name_HBWBLv6)
# Remove the scaup which should be excluded as they aren't seabirds
old_traits <- 
  old_traits %>%
  filter(Scientific.name_HBWBLv6 != "Aythya marila" & Scientific.name_HBWBLv6 != "Aythya affinis")

#--------------------------------------------
# Combine old data with new taxonomy
# Join is based on tree as old data does not have species names
# Only keeps species that match new taxonomy - excludes extinct species
both_traits <- right_join(old_traits, birds, by = join_by(Scientific.name_HBWBLv6 == HBWv8.1_Binomial))

#--------------------------------------------
# Remove un-necessary columns and reorganise

cleaned_data_traits <- 
  both_traits %>%
  select(SISRecID_BLVr9, HBWv8.1_Binomial = Scientific.name_HBWBLv6, Link_species, 
         HBWv8.1_Order, HBWv8.1_Family, HBWv8.1_Subfamily, HBWv8.1_Tribe, 
         HBWv8.1_Common_name, HBWv8.1_Genus, HBWv8.1_Synonyms, IUCN_2023, 
         Feeding.Method.Simple, Diet, Diet_description, Anthropogenic.subsidy.search.word,
         Anthropogenic.subsidy.simple, Fish, Cephalopods, Crustaceans, Other.Inverts, 
         Carrion.NonFishVertebrates, Anthropogenic.Subsidy, pelagic_specialist_CR, Body.Mass.g, scaled.body.mass,
         Source_Body.Mass.g, DMS.responsive_Savoca, DMS.responsive_Dell.Ariccia, Agreement_Savoca_Dell.Ariccia,    
         Body.Mass.g.FLAWED, AS.Fishery, AS.Refuse, AS.Agriculture)

# Save file
write_csv(cleaned_data_traits, "data-raw/trait-data-2024-10-02.csv")
