#Data Wrangling

# load libraries & data ------------
library(tidyverse)

df <- read_csv("data/final_data.csv")


#Dataframe for freedom of discussion, Internet penetration & Level of democracy

df_reduced1 <- df %>% 
  select(Economy, value_2021_perc, v2x_libdem, v2cldiscm, v2cldiscw)%>%
  #threshold of 0.5
  mutate(is_dem = v2x_libdem >= 0.5)
