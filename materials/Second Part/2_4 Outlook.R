####################################
### Day 2: GESIS Fall Seminar
### Session 4: Outlook
####################################

#Analysis
# 
# When performing analyses in `R` we get as output a summary of results, which is informative but not always what we might need. 
# For instance, the output of the test `cor.test()` holds rich information that we might want to store for further analyses. 
# Or, we might want to have a select set of reported coefficients when we calculate correlations between same variables across a 
# multitude of data sets (for instance in replication projects). 


# Pearson's r correlation coefficient
pearson_r <- cor.test(df$height, # defines variable 1
                      df$mass, # defines variable 2
                                   method="pearson", # defines which correlation type to calculate
                                   use="complete.obs") # specifies that missing data should not be considered
pearson_r

#Visual Inspection
plot(df$height, df$mass) #base-R

ggplot(data = df, aes(x = height, y = mass))+ #Ggplot
  geom_point()


df_without_outliers <- df |>  dplyr::filter(mass <500) 

pearson_r <- cor.test(df_without_outliers$height, # defines variable 1
                      df_without_outliers$mass, # defines variable 2
                      method="pearson", # defines which correlation type to calculate
                      use="complete.obs") # specifies that missing data should not be considered
pearson_r

#Visual Inspection
plot(df_without_outliers$height, df_without_outliers$mass) #base-R

ggplot(data = df_without_outliers, aes(x = height, y = mass))+ #Ggplot
  geom_point()

#Plotting
ggplot(df_without_outliers, aes(x = height, y = mass)) +
  geom_point() +
  geom_smooth(method='lm', formula= y~x)

#Regression Analysis
#Linear Model

model1 <- lm(mass ~ height, data = df_without_outliers)
summary(model1)


  
#We can further improve the plot by e.g.: 
#-adding a title
#-renaming the axes
#-highlighting the reported sex

ggplot(df |>  dplyr::filter(mass <500), aes(x = height, y = mass)) +
  geom_point(aes(color = sex)) +
  geom_smooth(method='lm', formula= y~x, colour = "grey")+
  labs(title = "Height and Mass of Star Wars Characters", 
       y = "Mass (kg)", x = "Height (m)")

#Regression Analysis
#Logistic Regression

#Only filtering cases with 'male' or 'female' sex
#Furthermore, we need assign dummy variables (1/0) for the 'glm()' formula

df_log <- df %>% 
  filter(sex != "male" | sex != "female") %>% 
  mutate(sex_new = case_when(
    sex == "male" ~ 0,
    sex == "female" ~ 1
  ))

model2 <- glm(sex_new ~ height, family = "binomial", data = df_log)
summary(model2)

#More information on interpreting logistic regression: #Regression Analysis

#Please feel free to adapt this code and play around with different settings and functions.
