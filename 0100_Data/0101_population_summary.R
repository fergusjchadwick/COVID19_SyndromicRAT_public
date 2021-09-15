# Load libraries
source("0000_HelperCode_Libraries/0001_Libraries.R")
# Import Data
dat <- readRDS("0100_Data/0103_nasal_dat.RDS")

# Bin age groups
dat <- dat %>% mutate(age_group = cut(age, 
                                       breaks = c(seq(15, 55, 10), 95), 
                                       labels = c(paste(seq(16, 46, 10), 
                                                      c(seq(25, 55, 10)),
                                                      sep = "-"),
                                                      "56+"))) 
dat$gender <- recode(dat$gender, "Male" = "Men",
                     "Female" = "Women")

# Summary of symptoms and case positivity by age and gender
dat_summ <- dat %>% 
  group_by(age_group, gender) %>% 
  summarise("Count" = length(result),
            "Positivity Rate (%)" = round(sum(result)/length(result)*100, 0),
            "Breathing Problems" = round(sum(breath_problem)/Count*100, 0),
            "Cough" = round(sum(cough)/Count*100, 0),
            "Diarrhoea" = round(sum(diarrhoea)/Count*100, 0),
            "Fever" = round(sum(fever)/Count*100, 0),
            "Headache" = round(sum(headache)/Count*100, 0),
            "Loss of Smell" = round(sum(loss_of_smell)/Count*100, 0),
            "Loss of Taste" = round(sum(loss_of_taste)/Count*100, 0),
            "Muscle Pain" = round(sum(muscle_pain)/Count*100, 0),
            "Red Eyes" = round(sum(red_eye)/Count*100, 0),
            "Runny Nose" = round(sum(runny_nose)/Count*100, 0),
            "Sore Throat" = round(sum(sore_throat)/Count*100, 0),
            "Tiredness" = round(sum(tired)/Count*100, 0),
            "Vomiting" = round(sum(vomit)/Count*100, 0),
            "Wet Cough" = round(sum(wet_cough)/Count*100, 0))

symp_counts <- dat %>% 
  summarise("age_group" = "All",
            "gender" = " ",
            "Count" = length(result),
            "Positivity Rate (%)" = round(sum(result)/length(result)*100, 0),
            "Breathing Problems" = round(sum(breath_problem)/Count*100, 0),
            "Cough" = round(sum(cough)/Count*100, 0),
            "Diarrhoea" = round(sum(diarrhoea)/Count*100, 0),
            "Fever" = round(sum(fever)/Count*100, 0),
            "Headache" = round(sum(headache)/Count*100, 0),
            "Loss of Smell" = round(sum(loss_of_smell)/Count*100, 0),
            "Loss of Taste" = round(sum(loss_of_taste)/Count*100, 0),
            "Muscle Pain" = round(sum(muscle_pain)/Count*100, 0),
            "Red Eyes" = round(sum(red_eye)/Count*100, 0),
            "Runny Nose" = round(sum(runny_nose)/Count*100, 0),
            "Sore Throat" = round(sum(sore_throat)/Count*100, 0),
            "Tiredness" = round(sum(tired)/Count*100, 0),
            "Vomiting" = round(sum(vomit)/Count*100, 0),
            "Wet Cough" = round(sum(wet_cough)/Count*100, 0))

dat_summ2 <- rbind(dat_summ, symp_counts) %>% as.data.frame()
saveRDS(dat_summ2, "0100_Data/0103_pop_summ_breakdown.RDS")
# Calculate population characteristics
pop_summ <- dat %>% 
  group_by(gender) %>% 
  summarise("Gender_Count" = summary(gender),
            "Age_Mean" = mean(age),
            "Age_SD" = sd(age)) %>%
  filter(!Gender_Count == 0) # Remove annoying duplications

saveRDS(pop_summ, "0100_Data/0103_pop_summ.RDS")
