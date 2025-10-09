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
effects_df <-
  effects_df %>% mutate(predictor = factor(predictor, 
                                            levels = rev(c("carrion", "cephalopods", "crustaceans", "fish", "other_inverts",
                                                       "as_agriculture", "as_fishery", "as_refuse",          
                                                       "aerial_pursuit", "bottom_feeding", "diving", "plunging", 
                                                       "scavenging", "skimming", "surface_seizing", "terrestrial_feeding",
                                                       "body_mass_2sd", "pelagic_specialist"))))      

rectangles <- data.frame(X = c(min(effects_df$HPD.lower)-1, max(effects_df$HPD.upper)+1),
                         Y = c("other_inverts", "as_refuse"))


# Plot
ggplot(effects_df, aes(x = post.mean, y = predictor)) +
  geom_point(size = 1.5) +
  geom_errorbarh(aes(xmin = HPD.lower, xmax = HPD.upper), width = 0.2) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  xlab("posterior mean") +
  ylab("") +
  theme_bw() +
  #geom_area(data = rectangles, aes(x=X,y="as_agriculture"),alpha=0.1,fill="grey") +
  #geom_area(data = rectangles, aes(x=X,y="as_refuse"),alpha=0.2,fill="grey") +
  #geom_area(data = rectangles, aes(x=X,y="body_mass_2sd"),alpha=0.3,fill="grey") +
  coord_cartesian(xlim = c(min(effects_df$HPD.lower), max(effects_df$HPD.upper))) +
  geom_hline(aes(yintercept = stage(predictor, after_scale = yintercept - 0.5)),
             data = data.frame(predictor = "other_inverts"),
             linetype = "dotted")

  
  # Save effect size plot
#ggsave("effect.size.plot.png", effect.size.plot, width = 180, height = 140, 
       units = "mm", dpi = 300)

