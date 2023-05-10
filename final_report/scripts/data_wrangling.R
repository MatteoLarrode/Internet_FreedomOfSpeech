#Cleaning 

#load data & packages ----------
library(tidyverse)

df <- read_csv("../data/final_data.csv")

#cleaning --------------

#final variable selection
df_reduced <- df %>% 
  select(Economy, #countries
         most_recent_perc,  #internet access(%)
         v2x_regime,  #regime classification (4)
         v2x_freexp_altinf, #freedom of Expression and Alternative Sources of Information index
         v2cldiscm, #freedom of discussion for men
         v2cldiscw,  #freedom of discussion for women
         v2mecenefi, #Internet censorship effort (higher = less censorship)
         v2smgovdom, #Government dissemination of false information domestic (higher = less dissemination)
         v2smgovfilprc, #Government Internet filtering in practice (high = less often)
         v2smgovshut, #Government Internet shut down in practice (high = less often)
         v2smgovsmmon, #Government social media monitoring  (high = less monitoring)
         v2smarrest, #Arrests for online political content (high = less likely)
         v2smorgavgact, #Average people’s use of social media to organize offline action
         v2smorgelitact)%>% #Elites’ use of social media to organize offline action
  #variables for capacity coded in the opposite way as variables for gvt action: reverse code them
  mutate(v2mecenefi = -1*v2mecenefi,
         v2smgovdom = -1*v2smgovdom,
         v2smgovfilprc = -1*v2smgovfilprc,
         v2smgovshut = -1*v2smgovshut,
         v2smgovsmmon = -1*v2smgovsmmon,
         v2smarrest = -1*v2smarrest)%>%
  #new variable for regimes
  mutate(v2x_regime = as.factor(v2x_regime),
         regime_type = as.factor(ifelse(grepl("democracy", v2x_regime), "Democracies", "Autocracies")))


#scale all variables
df_transformed <- df_reduced  %>% 
  mutate_if(is.numeric, ~ . * 100)

#dataset with renamed variables for dataviz
df_renamed <- df_transformed %>%
  rename(
    `Countries` = Economy,
    `Internet access (%)` = most_recent_perc,
    `Regime classification` = v2x_regime,
    `Freedom of Expression and Alternative Sources of Information` = v2x_freexp_altinf,
    `Freedom of discussion for men` = v2cldiscm,
    `Freedom of discussion for women` = v2cldiscw,
    `Internet censorship effort` = v2mecenefi,
    `Government dissemination of false information` = v2smgovdom,
    `Government Internet filtering in practice` = v2smgovfilprc,
    `Government Internet shut down in practice` = v2smgovshut,
    `Government social media monitoring` = v2smgovsmmon,
    `Arrests for online political content` = v2smarrest,
    `Average people's use of social media to organize offline action` = v2smorgavgact,
    `Elites' use of social media to organize offline action` = v2smorgelitact,
    `Regime type` = regime_type)%>%
  mutate(`Regime type` = factor(`Regime type`, levels = c("Democracies", "Autocracies")))


#DEMOCRACIES
df_democracies <- df_renamed%>%
  filter(`Regime type` == "Democracies")


#AUTOCRACIES
#dataset for autocracies (labelled)
labelled <- c("Qatar", "China", "South Sudan", "Nicaragua", "Egypt", "Russia",
              "Kenya", "Iraq", "Kuwait")

df_autocracies <- df_transformed%>%
  filter(regime_type == "Autocracies")%>%
  mutate(labelled = ifelse(Economy %in% labelled, Economy, ""))