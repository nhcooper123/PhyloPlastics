# Figure for the MCMCglmm model outputs
# Figure 3 in the text
#-------------------------------------

#-------------------------------------
# Load libraries
#-------------------------------------
library(tidyverse)
library(MCMCglmm)

#-------------------------------------
# Load model outputs
#-------------------------------------
model_full <- readRDS("output/model-full_2026.rds")

#-------------------------------------
# Extract required info for plot
#-------------------------------------
# Extract posterior summaries
fixed <- summary(model_full)$solutions

# Remove intercept
fixed <- fixed[!grepl("(Intercept)", rownames(fixed)), ]

# Create plotting dataframe
effects_df <- data.frame(
  predictor = rownames(fixed),
  post.mean = fixed[, "post.mean"],
  HPD.lower = fixed[, "l-95% CI"],
  HPD.upper = fixed[, "u-95% CI"]
)

# Make sure they're in the right plotting order
# and change names to make plots look nicer
effects_df <-
  effects_df %>% 
  mutate(predictor = str_replace(predictor, "year_centered", "median year")) %>%
  mutate(predictor = str_replace_all(predictor, "as_", "")) %>%
  mutate(predictor = str_replace_all(predictor, "_", " ")) %>%
  mutate(predictor = str_replace_all(predictor, "inverts", "invertebrates")) %>%
  mutate(predictor = str_replace(predictor, "body mass 2sd", "body mass")) %>%
  mutate(predictor = factor(predictor,         
                            levels = rev(c("carrion", "cephalopods", "crustaceans", "fish", "other invertebrates",
                                            "fishery", "refuse",          
                                            "aerial pursuit", "bottom feeding", "diving", "plunging", 
                                             "scavenging", "skimming", "surface seizing", "terrestrial feeding",
                                             "body mass", "pelagic specialist", "median year"))))
  
# Plot
ggplot(effects_df, aes(x = post.mean, y = predictor)) +
  geom_point(size = 1.5) +
  geom_errorbarh(aes(xmin = HPD.lower, xmax = HPD.upper), height = 0.2) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  xlab("posterior mean") +
  ylab("fixed effects") +
  theme_bw() +
  # Add rectangles for diet
  geom_rect(aes(xmin = min(HPD.lower)-1, 
                xmax = max(HPD.upper)+1, 
                ymin = 18.8, ymax = 13.5),
                alpha = 0.01, fill = "lightgrey") +
  # Add rectangles for feeding
  geom_rect(aes(xmin = min(HPD.lower)-1, 
                xmax = max(HPD.upper)+1, 
                ymin = 3.5, ymax = 11.5),
                alpha = 0.01, fill = "lightgrey") +
  # Ensure limits are as required
  coord_cartesian(xlim = c(min(effects_df$HPD.lower), max(effects_df$HPD.upper)))

# Save effect size plot
ggsave("figures/effect-size-plot.png", dpi = 1200)

#-----------------------------------
# Figures for the taxonomic subsets
# ----------------------------------
# Load model outputs
#-------------------------------------
model_char <- readRDS("output/model_Charadriiformes_2026.rds")
model_proc <- readRDS("output/model_Procellariiformes_2026.rds")
model_lar <- readRDS("output/model_Laridae_2026.rds")

#-------------------------------------
# Extract required info for plots
#-------------------------------------
# Extract posterior summaries
fixed_char <- summary(model_char)$solutions
fixed_proc <- summary(model_proc)$solutions
fixed_lar <- summary(model_lar)$solutions

# Create plotting dataframe
effects_df_char <- data.frame(
  predictor = rownames(fixed_char),
  post.mean = fixed_char[, "post.mean"],
  HPD.lower = fixed_char[, "l-95% CI"],
  HPD.upper = fixed_char[, "u-95% CI"]
)

effects_df_proc <- data.frame(
  predictor = rownames(fixed_proc),
  post.mean = fixed_proc[, "post.mean"],
  HPD.lower = fixed_proc[, "l-95% CI"],
  HPD.upper = fixed_proc[, "u-95% CI"]
)

effects_df_lar <- data.frame(
  predictor = rownames(fixed_lar),
  post.mean = fixed_lar[, "post.mean"],
  HPD.lower = fixed_lar[, "l-95% CI"],
  HPD.upper = fixed_lar[, "u-95% CI"]
)

# Make sure they're in the right plotting order
# and change names to make plots look nicer
effects_df_char <-
  effects_df_char %>% 
  mutate(predictor = str_replace(predictor, "year_centered", "median year")) %>%
  mutate(predictor = str_replace_all(predictor, "as_", "")) %>%
  mutate(predictor = str_replace_all(predictor, "_", " ")) %>%
  mutate(predictor = str_replace_all(predictor, "inverts", "invertebrates")) %>%
  mutate(predictor = str_replace(predictor, "body mass 2sd", "body mass")) %>%
  mutate(predictor = factor(predictor,         
                            levels = rev(c("carrion", "cephalopods", "crustaceans", "fish", "other invertebrates",
                                           "fishery", "refuse",          
                                           "aerial pursuit", "bottom feeding", "diving", "plunging", 
                                           "scavenging", "skimming", "surface seizing", "terrestrial feeding",
                                           "body mass", "pelagic specialist", "median year"))))

effects_df_proc <-
  effects_df_proc %>% 
  mutate(predictor = str_replace(predictor, "year_centered", "median year")) %>%
  mutate(predictor = str_replace_all(predictor, "as_", "")) %>%
  mutate(predictor = str_replace_all(predictor, "_", " ")) %>%
  mutate(predictor = str_replace_all(predictor, "inverts", "invertebrates")) %>%
  mutate(predictor = str_replace(predictor, "body mass 2sd", "body mass")) %>%
  mutate(predictor = factor(predictor,         
                            levels = rev(c("carrion", "cephalopods", "crustaceans", "fish", "other invertebrates",
                                           "fishery", "refuse",          
                                           "aerial pursuit", "bottom feeding", "diving", "plunging", 
                                           "scavenging", "skimming", "surface seizing", "terrestrial feeding",
                                           "body mass", "median year"))))


effects_df_lar <-
  effects_df_lar %>% 
  mutate(predictor = str_replace(predictor, "year_centered", "median year")) %>%
  mutate(predictor = str_replace_all(predictor, "as_", "")) %>%
  mutate(predictor = str_replace_all(predictor, "_", " ")) %>%
  mutate(predictor = str_replace_all(predictor, "inverts", "invertebrates")) %>%
  mutate(predictor = str_replace(predictor, "body mass 2sd", "body mass")) %>%
  mutate(predictor = factor(predictor,         
                            levels = rev(c("carrion", "cephalopods", "crustaceans", "other invertebrates",
                                           "fishery", "refuse",          
                                           "aerial pursuit", "plunging", 
                                           "scavenging", "skimming", "surface seizing", "terrestrial feeding",
                                           "body mass", "pelagic specialist", "median year"))))

# Plot
ggplot(effects_df_char, aes(x = post.mean, y = predictor)) +
  geom_point(size = 1.5) +
  geom_errorbarh(aes(xmin = HPD.lower, xmax = HPD.upper), height = 0.2) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  xlab("posterior mean") +
  ylab("fixed effects") +
  theme_bw() +
  # Ensure limits are as required
  coord_cartesian(xlim = c(min(effects_df_char$HPD.lower), max(effects_df_char$HPD.upper)))

# Save effect size plot
ggsave("figures/effect-size-plot_Charadriiformes.png", dpi = 1200, width = 4)

# Plot
ggplot(effects_df_proc, aes(x = post.mean, y = predictor)) +
  geom_point(size = 1.5) +
  geom_errorbarh(aes(xmin = HPD.lower, xmax = HPD.upper), height = 0.2) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  xlab("posterior mean") +
  ylab("fixed effects") +
  theme_bw() +
  # Ensure limits are as required
  coord_cartesian(xlim = c(min(effects_df_proc$HPD.lower), max(effects_df_proc$HPD.upper)))

# Save effect size plot
ggsave("figures/effect-size-plot_Procellariiformes.png", dpi = 1200, width = 4)

# Plot
ggplot(effects_df_lar, aes(x = post.mean, y = predictor)) +
  geom_point(size = 1.5) +
  geom_errorbarh(aes(xmin = HPD.lower, xmax = HPD.upper), height = 0.2) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  xlab("posterior mean") +
  ylab("fixed effects") +
  theme_bw() +
  # Ensure limits are as required
  coord_cartesian(xlim = c(min(effects_df_lar$HPD.lower), max(effects_df_lar$HPD.upper)))

# Save effect size plot
ggsave("figures/effect-size-plot_Laridae.png", dpi = 1200, width = 4)
