Final_Project
================
Matteo Larrode
2023-04-10

## Intro

I am passionate about both political science and technology, so I grew
interested in the effect of the rise and diffusion of new technologies
on international relations. One particular topic that fascinates me is
the relationship between internet use, especially activity on social
networks, and freedom of speech.

Social media platforms have fundamentally transformed the landscape of
social and political movements. They have allowed individuals to bypass
traditional gatekeepers of information, such as the mainstream media,
and connect with each other directly. This has enabled dissidents to
spread information and organize more quickly and effectively than ever
before. But on the other hand, they can also be easily monitored and
censored by governments, potentially putting activists at risk.

## Data Preparation

I created a dataset called “final_data.csv” by joining data on Internet
penetration, provided by the [International Telecommunication Union
(ITU)](https://www.itu.int/en/ITU-D/Statistics/Pages/stat/default.aspx)
(percentage of the population who has access to the internet), and
around 50 different metrics used by
[V-Dem](https://www.v-dem.net/data/the-v-dem-dataset/) to measure levels
of democracy. This data is available for a total of 157 countries.

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
    ## ✔ ggplot2 3.4.0     ✔ purrr   1.0.1
    ## ✔ tibble  3.2.1     ✔ dplyr   1.1.0
    ## ✔ tidyr   1.3.0     ✔ stringr 1.5.0
    ## ✔ readr   2.1.4     ✔ forcats 0.5.2
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(ggplot2)
library(ggthemes)
library(scales)
```

    ## 
    ## Attaching package: 'scales'
    ## 
    ## The following object is masked from 'package:purrr':
    ## 
    ##     discard
    ## 
    ## The following object is masked from 'package:readr':
    ## 
    ##     col_factor

``` r
df <- read_csv("data/final_data.csv")
```

    ## Rows: 202 Columns: 52
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (2): Economy, country_text_id
    ## dbl (50): value_2021, value_2021_perc, country_id, year, v2x_libdem, v2x_ega...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
df_noNA <- read_csv("data/final_data.csv")%>% 
  drop_na()
```

    ## Rows: 202 Columns: 52
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (2): Economy, country_text_id
    ## dbl (50): value_2021, value_2021_perc, country_id, year, v2x_libdem, v2x_ega...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
#dataframe for freedom of discussion, Internet penetration & Level of democracy

df_reduced <- df %>% 
  select(Economy, value_2021_perc, v2x_libdem, v2cldiscm, v2cldiscw)%>%
  mutate(is_dem = v2x_libdem >= 0.5,
         is_dem_long = ifelse(is_dem, "Higher Liberal Dem. Index", "Lower Liberal Dem. Index"))
```

## Findings

### Effect of Internet on Freedom of Speech for Women

My main research question is: “Does higher Internet penetration lead to
higher levels of freedom of speech?” More specifically, could the
Internet empower people who are usually less able to express themselves
to finally share their opinions?

Here is a scatterplot that illustrates the relationship between freedom
of discussion for women, my outcome variable, and access to the
Internet, my main independent variable.

``` r
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
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 43 rows containing non-finite values (`stat_smooth()`).

    ## Warning: Removed 43 rows containing missing values (`geom_point()`).

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
```

    ## `geom_smooth()` using formula = 'y ~ x'

    ## Warning: Removed 43 rows containing non-finite values (`stat_smooth()`).

    ## Warning: Removed 43 rows containing missing values (`geom_point()`).

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
