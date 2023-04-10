# Visualizations

# Internet penetration & Freedom of discussion for women -------

free_disc_women_plot <- ggplot(df_reduced, aes(x = value_2021_perc, y = v2cldiscw))+
  geom_point()+
  geom_smooth(method = "lm")+
  
  theme_wsj(title_family = "Roboto")+
  theme(text=element_text(family="Roboto"),
        plot.title=element_text(hjust=0.5, face="bold", size=12, margin = margin(b=10)),
        plot.caption = element_text(size=9, vjust = -2),
        axis.title = element_text(size = 12),
        axis.title.x = element_text(vjust = -2),
        axis.text.x = element_text(vjust = -.5),
        axis.text.y = element_blank(),
        axis.ticks.x = element_blank())+
  scale_x_continuous(name ="Internet Penetration",labels = scales::percent_format(accuracy = 1))+
  scale_y_continuous(name = "Freedom of Discussion for Women")+
  labs(title = "Higher Access to the Internet is Correlated with More Freedom of Discussion for Women",
       caption="Source: ITU, V-Dem | @matteoStats")

free_disc_women_plot

#CONTROL FOR DEMOCRACY = FACETED

free_disc_women_plot2 <- ggplot(df_reduced, aes(x = value_2021_perc, y = v2cldiscw))+
  geom_point()+
  geom_smooth(method = "lm")+
  
  facet_wrap(~ is_dem_long, ncol=2) +
  
  theme_wsj(title_family = "Roboto")+
  theme(text=element_text(family="Roboto"),
        plot.title=element_text(hjust=0.5, face="bold", size=12, margin = margin(b=10)),
        plot.caption = element_text(size=9, vjust = -2),
        axis.title = element_text(size = 12),
        axis.title.x = element_text(vjust = -2),
        axis.text.x = element_text(vjust = -.5),
        axis.text.y = element_blank(),
        axis.ticks.x = element_blank())+
  scale_x_continuous(name ="Internet Penetration",labels = scales::percent_format(accuracy = 1))+
  scale_y_continuous(name = "Freedom of Discussion for Women")+
  labs(title = "Relationship between Internet Penetration and Freedom of Discussion for Women \n at Different Levels of Liberal Democracy",
       caption="Source: ITU, V-Dem | @matteoStats")

free_disc_women_plot2




# Access to internet ----------------

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