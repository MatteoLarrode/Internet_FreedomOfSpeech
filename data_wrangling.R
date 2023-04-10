#Data Wrangling

# load libraries & data ------------
library(tidyverse)

df <- read_csv("data/final_data.csv")

df_noNA <- read_csv("data/final_data.csv")%>% 
  drop_na()


#Dataframe for freedom of discussion, Internet penetration & Level of democracy

df_reduced <- df %>% 
  select(Economy, value_2021_perc, v2x_libdem, v2cldiscm, v2cldiscw)%>%
  mutate(is_dem = v2x_libdem >= 0.5,
         is_dem_long = ifelse(is_dem, "Higher Liberal Dem. Index", "Lower Liberal Dem. Index"))

