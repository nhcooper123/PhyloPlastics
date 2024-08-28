
calculate_variance_comp <- function(one_model) {
  varcomps_full <- one_model |> 
    as_draws_df(variable = "^sd_", regex = TRUE) |> 
    select(!ends_with("Date_median")) |> 
    select(contains("nplastic"), .draw)
  
  relative_variances <- varcomps_full |> 
    # select(-.chain, -.iteration) |> 
    pivot_longer(-.draw, names_to = "varcomp", values_to = "sds") |> 
    mutate(vars = sds^2) |> 
    group_by(.draw) |> 
    mutate(relvar = vars / sum(vars))
  
  relative_forplot <- relative_variances |> 
    select(.draw, varcomp, relvar) |> 
    ungroup() |> 
    mutate(varcomp = str_replace(varcomp, "sd_", ""),
           varcomp = str_replace(varcomp, "__nplastic_Intercept", ""))
  
  ## need to rename the varcomp column
  
  var_rename <- c("diet_type" = "Diet", 
                  "Feeding.Method.Simple" = "Feeding method",
                  "MarineRegion" = "Marine region", 
                  "ROTL.tip.label" = "Species (phylogeny)", 
                  "Source" = "Study", 
                  "TipLabel_HBWBLv6" = "Species (unstructured)")
  
  relative_variance_table_output <- relative_forplot |> 
    mutate(varcomp = var_rename[varcomp],
           varcomp = forcats::fct_reorder(varcomp, relvar))
  
  return(relative_variance_table_output)
}