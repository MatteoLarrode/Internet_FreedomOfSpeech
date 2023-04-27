#Data Cleaning

# load libraries & data ------------
library(tidyverse)
library(readxl)

#files too big to be on the GitHub, accessible only locally
access_internet <- read_excel("../data0/internet_penetration.xlsx")
access_internet_gender_rural <- read_excel("../data0/internet_gender_rural.xlsx")
vdem <- read_csv("../data0/VDem_dataset.csv")

#Cleaning Internet access ------------

#Latest value for access to internet (2020 or 2021)
#select variable & filter out NAs
internet_users_20_21 <- access_internet%>%
  mutate(value_2021 = round(access_internet$`2021_value`, 0),
         value_2020 = round(access_internet$`2020_value`, 0))%>%
  select(Economy, value_2020, value_2021)%>%
  filter_at(vars(value_2020,value_2021),any_vars(!is.na(.)))

#clean some names to prepare the join
internet_users_recent <- internet_users_20_21 %>%
  mutate(most_recent_value = ifelse(is.na(value_2021), value_2020, value_2021),
         most_recent_perc = most_recent_value / 100) %>%
  select(Economy, most_recent_value, most_recent_perc) %>%
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
                          "Korea (Rep. of)" = "South Korea",
                          "Lao P.D.R." = "Laos",
                          "Myanmar" = "Burma/Myanmar",
                          "Nepal (Republic of)" = "Nepal",
                          "Taiwan, Province of China" = "Taiwan",
                          "Gambia" = "The Gambia",
                          "Russian Federation" = "Russia",
                          "Syrian Arab Republic" = "Syria",
                          "Türkiye" = "Turkey",
                          "United States" = "United States of America",
                          "Viet Nam" = "Vietnam"))


#now add gender data
internet_gender_rural_20_21 <- access_internet_gender_rural%>%
  filter(Latest_year >= 2021)%>%
  select(-All_Individuals)

#merge to data
internet_users_recent_extended <- left_join(internet_users_recent, internet_gender_rural_20_21, by = "Economy")


#RESULT CSV
write_csv(internet_users_recent_extended, "data/clean_internet_users.csv")


#Cleaning VDem ------------

#2021 value for vdem & select variables of interest
vdem_2021 <- vdem %>%
  filter(year == 2021 )%>%
  select(country_name, country_text_id, country_id, year, v2x_regime, v2x_libdem, v2x_freexp_altinf, v2clkill, v2cldiscm, v2cldiscw, v2cseeorgs, v2csreprss, v2csantimv, v2csanmvch_0, v2csanmvch_1, v2csanmvch_2, v2csanmvch_3, v2csanmvch_4, v2csanmvch_5, v2csanmvch_6, v2csanmvch_7, v2csanmvch_8, v2csanmvch_9, v2csanmvch_10, v2csanmvch_11, v2csanmvch_12, v2mecenefi, v2meharjrn, v2smgovdom, v2smgovfilcap, v2smgovfilprc, v2smgovshutcap, v2smgovshut, v2smgovsm, v2smgovsmmon, v2smgovsmcenprc, v2smonex, v2smorgavgact, v2smorgelitact, v2smorgtypes_0,v2smorgtypes_1, v2smorgtypes_2, v2smorgtypes_3, v2smorgtypes_4, v2smorgtypes_5, v2smorgtypes_6, v2smorgtypes_7, v2smorgtypes_8, v2smorgtypes_9, v2smarrest)%>%
  mutate(v2x_regime = case_when(v2x_regime == 0 ~ "Closed autocracy",
                                v2x_regime == 1 ~ "Electoral autocracy",
                                v2x_regime == 2 ~ "Electoral democracy",
                                v2x_regime == 3 ~ "Liberal democracy"))

#RESULT CSV
write_csv(vdem_2021, "data/new_vdem.csv")


#Merging ----------
internet_df <- read_csv("data/clean_internet_users.csv")
vdem_df <- read_csv("data/new_vdem.csv")

final_df <- full_join(internet_df, vdem_df, by = c("Economy" = "country_name"))%>%
  filter(!is.na(country_text_id))%>%
  filter(!is.na(most_recent_value))
  


#FINAL CSV
write_csv(final_df, "data/final_data.csv")
