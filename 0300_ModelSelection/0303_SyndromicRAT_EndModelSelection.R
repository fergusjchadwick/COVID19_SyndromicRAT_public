#' Now that we have narrowed down to the best set of symptoms for the syndromic
#' only model. This has reduced the potential model space to manageable level
#' so we can now explore the symptom-covariate combinations to the 5 best models
#' of each complexity level. 

# Source helper code and libraries
source("0000_HelperCode_Libraries/0001_Libraries.R")
source("0000_HelperCode_Libraries/0003_HelperFunctions.R")

# Extract list of all RDS files
rds_files <- fs::dir_ls("0300_ModelSelection/Output/", 
                        regexp = "\\.rds$")

# Get syndromic only, fine model selection files 
synd_RAT__files <- rds_files[str_detect(rds_files, "SyndromicRAT_Fine")]

# Function to read files,and extract log loss dataframe
read_logloss <- function(file){
  tmp <- readRDS(file)[["cv_log_loss"]]
  tmp
}

# Read each file in parallel, extract log loss df and bind into single data frame 
final_models <- synd_RAT__files %>% 
  future_map_dfr(read_logloss)

# Get whole model log loss from log losses for each cross validation set
final_models_wide <- final_models %>% 
  pivot_wider(names_from = CV, values_from = log_loss, values_fn = list) %>%
  unnest(c(`1`, `2` , `3`, `4`,  `5`))  
final_models_wide <- final_models_wide %>%  
  mutate(ModelLogLoss = final_models_wide %>%
           select(c(`1`, `2` , `3`,  `4`, `5`)) %>%
           rowSums())

# List of candidate models at each complexity level
fittypes <- final_models_wide$FitType %>% unique()
symp_0_models <- fittypes[parse_number(fittypes) == 0]
symp_1_models <- fittypes[parse_number(fittypes) == 1]
symp_2_models <- fittypes[parse_number(fittypes) == 2]
symp_3_models <- fittypes[parse_number(fittypes) == 3]
symp_4_models <- fittypes[parse_number(fittypes) == 4]

# Initialise best model list
best_models <- data.frame("SympNum" = 4:0, "ModelName" = NA)

# 4 Symptom Model Comparisons ---------------------------------------------

ggplot(final_models_wide %>% filter(FitType %in% symp_4_models), 
       aes(x = ModelLogLoss, y = FitType)) +
  geom_boxplot()

# Add model with lowest log loss to best model list
best_models$ModelName[1] <- symp_4_models[3]

# 3 Symptom Model Comparisons ---------------------------------------------

ggplot(final_models_wide %>% filter(FitType %in% symp_3_models), 
       aes(x = ModelLogLoss, y = FitType)) +
  geom_boxplot()

# Add model with lowest log loss to best model list
best_models$ModelName[2] <- symp_3_models[11]

# 2 Symptom Model Comparisons ---------------------------------------------

ggplot(final_models_wide %>% filter(FitType %in% symp_2_models), 
       aes(x = ModelLogLoss, y = FitType)) +
  geom_boxplot()

# Add model with lowest log loss to best model list
best_models$ModelName[3] <- symp_2_models[19]

# 1 Symptom Model Comparisons ---------------------------------------------

ggplot(final_models_wide %>% filter(FitType %in% symp_1_models), 
       aes(x = ModelLogLoss, y = FitType)) +
  geom_boxplot()

# Add model with lowest log loss to best model list
best_models$ModelName[4] <- symp_1_models[7]

# 1 Symptom Model Comparisons ---------------------------------------------

ggplot(final_models_wide %>% filter(FitType %in% symp_0_models), 
       aes(x = ModelLogLoss, y = FitType)) +
  geom_boxplot()

# Add model with lowest log loss to best model list
best_models$ModelName[5] <- symp_0_models[3]


# Best Model From Each Round ----------------------------------------------

ggplot(final_models_wide %>% filter(FitType %in% best_models$ModelName), 
       aes(x = ModelLogLoss, y = FitType)) +
  geom_boxplot()

saveRDS(best_models, "0300_ModelSelection/0310_SyndromicRAT_BestModels.rds")
