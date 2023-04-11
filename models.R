# Regression models

# Effect of Internet penetration on freedom of speech for women w/ interaction term

model1 <- lm(data = df_reduced,  v2cldiscw ~ value_2021_perc * is_dem)
summary(model1)
