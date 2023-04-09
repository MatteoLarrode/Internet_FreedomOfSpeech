#Data Wrangling

# load libraries & data ------------
library(tidyverse)

df <- read_csv("data/final_data.csv")

non_democracies_df <- df %>%
  filter(v2x_libdem <= 0.6)

democracies_df <- df %>%
  filter(v2x_libdem >= 0.6)