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

### General Findings

For a first high-level overview, we used the “Freedom of Expression and
Alternative Sources of Information index” of the VDem dataset. This
variable quantifies the extent to which governments respect press and
media freedom, the freedom of ordinary people to discuss political
matters at home and in the public sphere, as well as the freedom of
academic and cultural expression.

``` r
freedom_speech_internet <- ggplot(df_reduced, aes(x = most_recent_perc, y = v2x_freexp_altinf))+
  geom_point()+
  geom_smooth(method = "lm")+
  
  theme(aspect.ratio = 3.2/7,
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
  labs(title = "Higher Access to the Internet is Correlated with More Freedom of Discussion",
       caption="Source: ITU, V-Dem")

freedom_speech_internet
```

    ## `geom_smooth()` using formula = 'y ~ x'

![](README_files/figure-gfm/freedom_speech_internet-1.png)<!-- -->

From this simple scatterplot, and the linear regression fitted to the
data, it seems that countries with higher levels of Internet penetration
are associated with higher levels of freedom of discussion.

However, an important omitted variable bias could emerge when ignoring
regime type. Indeed, democracies, usually characterized by high levels
of freedom of discussion, are also often more developed than
authoritarian regimes, and therefore have higher Internet penetration
rates on average.

The next step taken to analyze the relationship between Internet
penetration and freedom of discussion is to take regime type into
account. To reach this objective, we will use V-Dem’s Regimes of the
World (RoW) classification mentioned above.

``` r
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
  labs(title = "Relationship between Internet Penetration and Freedom of Discussion \n depending on the regime type",
       caption="Source: ITU, V-Dem")

freedom_speech_internet_facet
```

    ## `geom_smooth()` using formula = 'y ~ x'

![](README_files/figure-gfm/freedom_speech_internet_facet-1.png)<!-- -->

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
