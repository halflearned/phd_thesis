
# Helper functions
make_heterogeneity_table <- function(data, covariates, group, prefix="Group") {

  # Compute mean mean and std. error
  grp <- data %>% dplyr::group_by_(group)
  se <- grp %>% dplyr::summarise_all(~sqrt(var(.)/length(.)))
  m <- grp %>% dplyr::summarise_all(mean) 
  
  # Choose covariate order based on Vaar(E[Y|X])/E[Y|X]
  cov_order <- data %>%
               select(covariates, group) %>% 
               group_by_(group) %>%
               summarize_all(mean) %>%
               summarize_all(~var(.)/(mean(.) + 1)) %>%
               select(covariates) %>%
               as.numeric %>% order() %>% rev()

  # Make a table of characters
  tab <- map2_df(m, se, ~str_c(round(.x,2), " (", round(.y,2), ") "))  %>% 
                  select(covariates[cov_order]) %>%
                  as.data.frame() %>% t()
  colnames(tab) <- map(seq(dim(tab)[2]), ~str_c(prefix, .))
  
  return(tab)
}
