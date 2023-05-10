# Data Visualization

#load libraries ---------
library(tidyverse)
library(ggplot2)
library(ggthemes)
library(ggrepel)
library(scales)
library(stargazer)
library(tableone)
library(kableExtra)
library(sjPlot)

#datasets created in data_wrangling.R


#data visualization ---------

#TABLE 1: Summary statistics
tableOne <- CreateTableOne(vars = colnames(select(df_renamed, 
                                                  -Countries, 
                                                  -`Regime classification`, 
                                                  -`Regime type`)), 
                           strata = c("Regime type"), 
                           data = df_renamed,
                           test = FALSE)

#use the print function to prepare it for export.
table_p <- print(tableOne, quote = FALSE, noSpaces = TRUE, printToggle = FALSE)
#save to a CSV file
write.csv(table_p, file = "figures/table1.csv")

#from CSV, create the table
table_df <- read_csv("figures/table1.csv")
colnames(table_df)[1]  <- "Variables" 

table_html <- table_df %>%
  kbl(caption = "Table 1. Exploratory data analysis, stratified by regime type") %>%
  kable_classic(full_width = F, html_font = "Times New Roman")

save_kable(table_html, file = "figures/table1.html", self_contained = T)

----------
#FIGURE 1: Relationship between Internet Access and Freedom of Discussion, Faceted by Regime Type
freedom_speech_internet_facet <- ggplot(df_reduced, aes(x = most_recent_perc, y = v2x_freexp_altinf))+
  geom_point()+
  facet_wrap(~ regime_type)+
  geom_smooth(method = "lm")+
  
  theme(aspect.ratio = 4/7,
        text=element_text(family="Roboto Condensed"),
        plot.margin = margin(t = 0, r = 0.5, b = 0, l = 0.5, unit = "cm"),
        plot.background = element_rect(fill = "white"),
        panel.background = element_rect(fill = "white"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(color = "#dcdbd8"),
        panel.grid.minor.y = element_blank(),
        plot.title = element_text(size = rel(1.2), hjust = 0, face = "bold"),
        plot.caption = element_text(hjust = 0, size = 9, colour = "#4B4B4B"),
        axis.text = element_text(size = rel(1), color = "gray8"),
        axis.text.y = element_blank(),
        axis.line.x  = element_line(color = "gray8"),
        axis.ticks.y = element_blank())+
  scale_x_continuous(name ="Internet Penetration",labels = scales::percent_format(accuracy = 1))+
  scale_y_continuous(name = "Freedom of Expression")+
  labs(title = "Relationship between Internet Penetration and Freedom of Discussion \nDepending on Regime Type",
       caption="Source: ITU, V-Dem")

freedom_speech_internet_facet

-----------
#TABLE 2: Regression model, interaction effect
model1 <- lm(data = df_renamed,  
             `Freedom of Expression and Alternative Sources of Information` ~ `Internet access (%)` * `Regime type`)

tab_model(model1)


----------
#TABLE 3: Regression models, the Internet and Freedom of Speech for Women and Men
model_democracies_men <- lm(data = df_democracies,  
                            `Freedom of discussion for men` ~ `Internet access (%)` + `Regime classification`)
model_democracies_women <- lm(data = df_democracies, 
                              `Freedom of discussion for women` ~ `Internet access (%)` + `Regime classification`)

tab_model(model_democracies_men, model_democracies_women)


----------
#FIGURE 2: Social Media Monitoring and Arrests for Online Political Content
autocracies_sm_monitoring <- ggplot(df_autocracies, 
                                    aes(x = v2smgovsmmon, 
                                        y = v2smarrest))+
  
  geom_point(aes(col = most_recent_perc))+
  geom_text_repel(aes(label = labelled))+
  
  theme(text=element_text(family="Roboto Condensed"),
        plot.margin = margin(t = 0, r = 0.5, b = 0, l = 0.5, unit = "cm"),
        plot.background = element_rect(fill = "white"),
        panel.background = element_rect(fill = "white"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(color = "#dcdbd8"),
        panel.grid.minor.y = element_blank(),
        plot.title = element_text(size = rel(1.2), hjust = 0, face = "bold"),
        plot.caption = element_text(hjust = 0, size = 9, colour = "#4B4B4B"),
        axis.text = element_text(size = rel(1), color = "gray8"),
        axis.text.y = element_blank(),
        axis.line.x  = element_line(color = "gray8"),
        axis.ticks.y = element_blank(),
        legend.position = "right",
        legend.text = element_text(size = 8),
        legend.key.height= unit(1.5, 'cm'),
        legend.key.width= unit(0.3, 'cm'))+
  scale_x_continuous(name ="Social Media Monitoring")+
  scale_y_continuous(name = "Arrests for online political content")+
  scale_colour_viridis_c(name = "Internet Access", option = "mako", direction = -1) +
  labs(title = "Social Media Monitoring and Arrests for Political Content Among Autocracies",
       caption="Source: ITU, V-Dem")

autocracies_sm_monitoring

---------
#FIGURE 3: Difference between Average People's and Elites' Use of Social Media for Offline Action

df_autocracies_new <- df_autocracies %>%
  mutate(sm_use_diff = v2smorgavgact - v2smorgelitact)%>%
  #order countries by difference
  mutate(countries_ordered = factor(Economy, levels = Economy[rev(order(sm_use_diff))]))%>%
  #filter every other country to make graph more readable
  filter(row_number() %% 2 == 0)


autocracies_sm_activity <- ggplot(df_autocracies_new, aes(x = sm_use_diff, y = countries_ordered))+
  geom_bar(stat = "identity", 
           show.legend = FALSE,
           aes(fill = sm_use_diff))+
  
  scale_fill_gradient2(midpoint = 0, 
                       low = "blue", mid = "white", high = "red")+
  
  theme(text=element_text(family="Roboto Condensed"),
        plot.background = element_rect(fill = "white"),
        panel.background = element_rect(fill = "white"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(color = "#dcdbd8"),
        panel.grid.minor.y = element_blank(),
        plot.title = element_text(size = rel(0.9), hjust = 0, face = "bold"),
        plot.caption = element_text(hjust = 0, size = 8, colour = "#4B4B4B"),
        axis.text = element_text(size = rel(0.8), color = "gray8"),
        axis.title.y = element_blank(),
        axis.line.x  = element_line(color = "gray8"),
        axis.ticks.y = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank())+
  labs(title = "Difference between Average People's and Elites' Use of the Internet for Offline Action",
       caption="Source: V-Dem")


autocracies_sm_activity