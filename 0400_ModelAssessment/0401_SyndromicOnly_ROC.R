#' We now need to calculate the posterior ROCs for the syndromic only model.

# Read in helper functions and libraries
source("0000_HelperCode_Libraries/0001_Libraries.R")
source("0000_HelperCode_Libraries/0003_HelperFunctions.R")
best_models <- readRDS("0300_ModelSelection/0310_SyndromicOnly_BestModels.rds")

# rds files for best models
best_model_files <- paste0("0300_ModelSelection/Output/SyndromicOnly_Fine_Round",
                           best_models$ModelName, ".rds")

# Read each file in parallel, extract validation df and bind into single data frame 
best_valid <- best_model_files %>% 
  future_map_dfr(read_validation) 

# Thin to make ROC calculations feasible
iter_num <- max(best_valid$Iter)
iter_thin <- 0.1 
thinned_iter_indx <- sample(1:iter_num, iter_thin * iter_num)
best_valid <- best_valid %>% filter(Iter %in% thinned_iter_indx)

# Generate true and false, positive and negative counts 
synd_only_ROC <- ROC_diagnose(validation_df = best_valid, 
                              prob_range = c(0.01, 0.99), 
                              increment_size = 0.0025)
saveRDS(synd_only_ROC, "0400_ModelAssessment/0410_SyndromicOnly_ROC.rds")
# synd_only_ROC <- readRDS("0400_ModelAssessment/0410_SyndromicOnly_ROC.rds")
# Generate true and false, positive and negative rates, calculate median, SD and 
# CIs for each 
synd_only_ROCrate <- synd_only_ROC  %>% 
  group_by(SwabType, FitType, threshold) %>%
  summarise(MedFalseNegRate = median(FalseNegRate, na.rm = TRUE),
            SDFalseNegRate = sd(FalseNegRate, na.rm = TRUE),
            my_50CI(varnam = "FalseNegRate", x = FalseNegRate),
            MedFalsePosRate = median(FalsePosRate, na.rm = TRUE),
            SDFalsePosRate = sd(FalsePosRate, na.rm = TRUE),
            my_50CI(varnam = "FalsePosRate",x = FalsePosRate),
            MedTrueNegRate = median(TrueNegRate, na.rm = TRUE),
            SDTrueNegRate = sd(TrueNegRate, na.rm = TRUE),
            my_50CI(varnam = "TrueNegRate", x = TrueNegRate),
            MedTruePosRate = median(TruePosRate, na.rm = TRUE),
            SDTruePosRate = sd(TruePosRate, na.rm = TRUE),
            my_50CI(varnam = "TruePosRate", x = TruePosRate)) %>%
  pivot_wider(names_from = probs, values_from = ends_with("_CI"))
saveRDS(synd_only_ROCrate, "0400_ModelAssessment/0410_SyndromicOnly_ROCrate.rds")


