#Data Cleaning

# load libraries & data ------------
library(tidyverse)
library(readxl)

#files too big to be on the GitHub, accessible following the links on the README
access_internet <- read_excel("../data0/PercentIndividualsUsingInternet.xlsx")
vdem <- read_csv("../data0/VDem_dataset.csv")

#Cleaning Internet access ------------

#2021 value for access to internet
#select variable & filter out NAs
internet_users_2021 <- access_internet%>%
  mutate(value_2021 = round(access_internet$`2021_value`, 0),
         value_2021_perc = value_2021 / 100)%>%
  select("Economy", value_2021, value_2021_perc)%>%
  filter(!is.na(value_2021))%>%
  print(n=10)

#clean some names to prepare the join
internet_users_2021 <- internet_users_2021 %>%
  mutate(Economy = recode(Economy,
                          "Bolivia (Plurinational State of)" = "Bolivia",
                          "Cabo Verde" = "Cape Verde",
                          "Central African Rep." = "Central African Republic",
                          "Côte d'Ivoire"= "Ivory Coast",
                          "Czech Republic" = "Czechia",
                          "Dem. Rep. of the Congo" = "Democratic Republic of the Congo",
                          "Dominican Rep." = "Dominican Republic",
                          "Hong Kong, China" = "Hong Kong",
                          "Iran (Islamic Republic of)" = "Iran",
                          "Lao P.D.R." = "Laos",
                          "Myanmar" = "Burma/Myanmar",
                          "Nepal (Republic of)" = "Nepal",
                          "Taiwan, Province of China" = "Taiwan",
                          "Gambia" = "The Gambia",
                          "Türkiye" = "Turkey",
                          "United States" = "United States of America",
                          "Viet Nam" = "Vietnam"))

#missing access to Internet data for 2021: replace with 2020 values???

#RESULT CSV
write_csv(internet_users_2021, "data/clean_internet_users.csv")


#Cleaning VDem ------------

#2021 value for vdem & select variables of interest
vdem_2021 <- vdem %>%
  filter(year == 2021)%>%
  select(country_name, country_text_id, country_id, year,v2x_libdem, v2x_partipdem, v2x_egaldem, v2clkill, v2cldiscm, v2cldiscw, v2cseeorgs, v2csreprss, v2csantimv, v2csanmvch_0, v2csanmvch_1, v2csanmvch_2, v2csanmvch_3, v2csanmvch_4, v2csanmvch_5, v2csanmvch_6, v2csanmvch_7, v2csanmvch_8, v2csanmvch_9, v2csanmvch_10, v2csanmvch_11, v2csanmvch_12, v2mecenefi, v2meharjrn, v2smgovdom, v2smgovfilcap, v2smgovfilprc, v2smgovshutcap, v2smgovshut, v2smgovsm, v2smgovsmmon, v2smgovsmcenprc, v2smonex, v2smorgavgact, v2smorgelitact, v2smorgtypes_0,v2smorgtypes_1, v2smorgtypes_2, v2smorgtypes_3, v2smorgtypes_4, v2smorgtypes_5, v2smorgtypes_6, v2smorgtypes_7, v2smorgtypes_8, v2smorgtypes_9, v2smarrest)

#RESULT CSV
write_csv(vdem_2021, "data/new_vdem.csv")


#Merging ----------
internet_df <- read_csv("data/clean_internet_users.csv")
vdem_df <- read_csv("data/new_vdem.csv")

final_df <- full_join(internet_df, vdem_df, by = c("Economy" = "country_name"))

#FINAL CSV
write_csv(final_df, "data/final_data.csv")