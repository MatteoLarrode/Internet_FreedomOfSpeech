#Visualizations ---------

freedom_disc_men <- ggplot(non_democracies_df, aes(x=v2cldiscm, y=value_2021))+
  geom_point()

freedom_disc_men

#----

model1 <- lm(data = df,  v2cldiscw ~ value_2021_perc * v2x_libdem)
summary(model1)

# ---

socialMed_offline <- ggplot(non_democracies_df, aes(x=value_2021, y=v2smorgavgact))+
  geom_point()+
  geom_smooth(method = "lm")

socialMed_offline

#----

plot <- ggplot(democracies_df, aes(x=value_2021, y=v2x_libdem))+
  geom_point()+
  geom_smooth(method = "lm")

plot



#Access to internet ----------------

#density plot 
density_internet_21 <- ggplot(internet_users_2021, aes(x = value_2021_perc))+
  geom_density(col = "#5b92e5")+
  
  theme(text=element_text(family="Roboto"),
        panel.background = element_blank(),
        plot.margin = unit(c(0, 0.5, 0.5, 1), "cm"),
        plot.title=element_text(hjust=0.5, face="bold", size=16, margin = margin(b=10)),
        plot.subtitle=element_text(hjust=0.5, face="bold", size=12, 
                                   colour = "#696969", margin = margin(b = 20)),
        plot.caption = element_text(size=9, vjust = -2),
        axis.title.x = element_blank(),
        axis.ticks = element_blank(),
        panel.grid.major = element_line(color = "gray", linetype = "dashed", linewidth = 0.2))+
  scale_x_continuous(labels = scales::percent, expand = c(0,0))+
  scale_y_continuous(name = element_text("Density"))+
  scale_fill_discrete(guide = "none")+
  labs(title = "Inequality in Access to the Internet",
       subtitle = "Percentage of the population using the internet across more than 180 countries",
       caption="Source: International Telecommunication Union (ITU) | @matteoStats")

density_internet_21