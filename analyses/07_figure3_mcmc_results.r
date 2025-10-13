# Figure for the MCMCglmm model outputs
# Oct 2025
#-------------------------------------

#-------------------------------------
# Load libraries
#-------------------------------------
library(tidyverse)
library(MCMCglmm)

#-------------------------------------
# Load model outputs
#-------------------------------------
model_full <- readRDS("output/model_full.rds")

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
  mutate(predictor = str_replace_all(predictor, "as_", "")) %>%
  mutate(predictor = str_replace_all(predictor, "_", " ")) %>%
  mutate(predictor = str_replace_all(predictor, "inverts", "invertebrates")) %>%
  mutate(predictor = str_replace(predictor, "body mass 2sd", "body mass")) %>%
  mutate(predictor = factor(predictor,         
                            levels = rev(c("carrion", "cephalopods", "crustaceans", "fish", "other invertebrates",
                                            "agriculture", "fishery", "refuse",          
                                            "aerial pursuit", "bottom feeding", "diving", "plunging", 
                                             "scavenging", "skimming", "surface seizing", "terrestrial feeding",
                                             "body mass", "pelagic specialist"))))
  
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
                ymin = 2.5, ymax = 10.5),
                alpha = 0.01, fill = "lightgrey") +
  # Ensure limits are as required
  coord_cartesian(xlim = c(min(effects_df$HPD.lower), max(effects_df$HPD.upper)))

# Save effect size plot
ggsave("figures/effect-size-plot.png", dpi = 1200)

