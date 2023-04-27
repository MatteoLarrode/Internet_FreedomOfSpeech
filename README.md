Final_Project
================
Matteo Larrode
2023-04-10

## Intro

A growing body of literature has been interested in the effect of the
rise and diffusion of new technologies on international relations. One
particular topic of contention is the relationship between internet use,
especially activity on social networks, and civil liberties.

Social media platforms have fundamentally transformed the landscape of
social and political movements. They have allowed individuals to bypass
traditional gatekeepers of information, such as the mainstream media,
and connect with each other directly. This has enabled dissidents to
spread information and organize more quickly and effectively than ever
before. The other side of the coin is that they also enabled certain
governments to better monitor and gather information, potentially
putting activists at risk.

Through a combination of data analysis and case studies, this report
seeks to further uncover the nature of the effect of the development of
the internet and social media on freedom of speech and activism.

## Dataset & Methodology

For this research project, a dataset on internet penetration, V-Dem
indicators, and the political environment of the internet and social
media was compiled for 179 countries.

- **Internet penetration**: The [International Telecommunication Union
  (ITU)](https://www.itu.int/en/Pages/default.aspx) is the UN
  specialized agency for information and communications technologies
  (ICT), and the official source for global ICT
  [statistics](https://www.itu.int/en/ITU-D/Statistics/Pages/stat/default.aspx).
  These statistics include the percentage of the population having
  access to the internet, broken down by gender and urban/rural area, at
  country level.

- **Measure of democracy**: The [Varieties of Democracy Dataset, version
  13](https://www.v-dem.net/data/the-v-dem-dataset/) measures democracy
  and many of its indicators in the set of countries studied. It also
  includes the Regimes of the World (RoW) variable that was used to
  classify regime types for this project.

- **Political environment of the internet and social media**: Through
  expert-coded surveys, the Digital Society Survey, designed by the
  [Digital Society Project](http://digitalsocietyproject.org), provides
  information on topics related to coordinated information operations,
  digital media freedom, online media polarization, social cleavages as
  well as state internet regulation capacity and approach.

#### Types of political systems

This report tackles the differences in the impact of the internet on
civil liberties, especially freedom of expression, across different
types of regimes. To classify them, we will use the Regimes of the World
(RoW) data by political scientists Anna Lührmann, Marcus Tannenberg, and
Staffan Lindberg, published by the Varieties of Democracy (V-Dem)
project. The RoW data distinguishes four types of political systems
based on how their elections work and other factors related to how their
government functions.

- closed autocracies
- electoral autocracies
- electoral democracies
- liberal democracies

One strength of using the RoW data is that it is based on evaluations by
experts, who are primarily academics, members of the media, and civil
society, and often nationals or residents of the country they assess.
This allows for a nuanced and informed assessment of a country’s
political system. Additionally, V-Dem uses several experts per country,
year, and topic, to make its assessments less subjective, which further
increases the reliability of the data.

However, a weakness of using expert evaluations is that they are to some
degree subjective, and there may be disagreement about specific
characteristics or how something as complex as a political system can be
reduced into a single measure. V-Dem addresses this by using several
experts and specific questions on completely explained scales.

Overall, the use of the RoW data is a valid and [widely accepted
approach](https://ourworldindata.org/regimes-of-the-world-data) to
measuring political regimes, and we believe it will be a useful tool for
our analysis.

## Findings

### Effect of Internet on Freedom of Speech for Women

Here is a scatterplot that illustrates the relationship between freedom
of discussion for women, my outcome variable, and access to the
Internet, my main independent variable.

``` r
free_disc_women_plot <- ggplot(df_reduced, aes(x = most_recent_perc, y = v2cldiscw))+
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
```

    ## `geom_smooth()` using formula = 'y ~ x'

![](README_files/figure-gfm/freedom_speech_women-1.png)<!-- -->

From this simple scatterplot, and the linear regression fitted to the
data, it seems that countries with higher levels of Internet penetration
are associated with higher levels of freedom of discussion for women.
However, an important omitted variable bias could emerge if we do not
take governance into account. Indeed, democracies, usually characterized
by high levels of freedom of discussion, are also often more developed
than authoritarian regimes, and therefore have higher Internet
penetration rates on average.

An interesting extra step to analyze the relationship between Internet
penetration and freedom of discussion could be to control for the level
of democracy. To reach this objective, we will use V-Dem’s Liberal
democracy index (v2x_libdem), that measures to what extent is the ideal
of liberal democracy achieved. To clarify, the liberal principle of
democracy emphasizes the importance of protecting individual and
minority rights against the tyranny of the state and the tyranny of the
majority. This is achieved by constitutionally protected civil
liberties, strong rule of law, an independent judiciary, and effective
checks and balances that, together, limit the exercise of executive
power.

To explore this addition of an independent variable to the model, we can
create the same scatterplot as before, but faceted by different levels
of the liberal democracy index. There is no specific threshold level at
which a country is considered a democracy on the V-Dem index. Rather,
the index measures the extent to which a country meets the various
criteria for democracy and assigns a score accordingly. The higher the
score, the more democratic the country is considered to be. However, for
the purpose of this graph, I arbitrarily decided of a threshold (0.5) to
separate countries into two categories of liberal democracy.

``` r
free_disc_women_plot2 <- ggplot(df_reduced, aes(x = most_recent_perc, y = v2cldiscw))+
  geom_point()+
  geom_smooth(method = "lm")+
  
  facet_wrap(~ regime_type, ncol=2) +
  
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
```

    ## `geom_smooth()` using formula = 'y ~ x'

![](README_files/figure-gfm/freedom_speech_women_faceted-1.png)<!-- -->

This faceted graph gives some very interesting information! It suggests
that the effect of Internet penetration on freedom of discussion for
women is **conditional on the level of libertarian democracy**. In
countries considered to be more democratic, higher access to the
Internet seems to be correlated to an increase in the freedom of
discussion for women. This observation supports the hypothesis that the
inter-connectivity and anonymity provided by the Internet empowers
groups that tend to be discriminated against to express themselves. On
the other hand, countries classified as having a lower liberal democracy
index do not display any apparent relationship between Internet
penetration and freedom of discussion for women. This could be explained
by the censorship and online harassment efforts put in place by
authoritarian regimes to limit the danger that free speech on the
Internet poses to their stability.

## Two opposing effects

### Positive: the Internet & Social Media as a Promoter of Civil Liberties

#### Platform for people to speak out + gendered approach

#### Platform to organize offline action

### Negative: Risks for democracy + gendered approach

#### i- surveillance + violence

#### ii - personalisation

#### iii - disinformation

> COMPARE AUTOCRACIES TO DEMOCRACIES = uncover nature interaction regime
> x internet on freedom of speech - Literature - Dataviz & models

\###Reminders \#### Quality of data –\> violence on women not reported …
