####################################
### Day 2: GESIS Fall Seminar
### Session 2: Data Wrangling Part II
####################################

#Loading Packages
library(tidyverse)

df <- starwars

# ------------------------------------
## Coding 

# dplyr - mutate ----------------------------------------------------------
# Often, we need to transform old variables, or create new ones. 

# creating a new variable 

df %>% 
  mutate(height_metre = height / 100)

df %>% 
  mutate(height_metre = height / 100) %>% 
  select(height_metre, height)

#We can also take all values from another variable

df %>% 
  mutate(dublicated_variable = height) %>% 
  select(dublicated_variable, height)

# Or only one specific number (in this case 100)

df %>% 
  mutate(dublicated_variable = 100) %>% 
  select(dublicated_variable, height)

#We can also apply functions

df %>% 
  mutate(summary = paste(height, "cm tall and from", homeworld)) %>% 
  select(name, summary, height, homeworld)

#or multiple variables at once

df %>% 
  mutate(new_variable1 = 100, 
         new_variable2 = 200,
         new_variable3 = 300) %>% 
  select(name, starts_with("new"))

# R Base

df$height_metre <- df$height / 100
df$height_metre
df$height

# We now want to create a new variable 'category_height' with the categories 
# "Small" (<100) or "Tall" (=>100)

df$category_height <- ifelse(df$height > 100, "Tall", "Small")
df$category_height
df$height
df[,c("height", "category_height")]

#However, this becomes difficult for multiple conditions
#Tall: Above or equal to 150
#Medium: Smaller or equal to 150 but greater than to 120
#Small: Smaller or equal to 120 but greater or equal to 100
#Very Small: Smaller than 100

df$category_height <- ifelse(df$height > 150, "Tall", 
                            ifelse(df$height <= 150 & df$height > 120, "Medium",
                                   ifelse(df$height <= 120 & df$height > 100, "Small", "Very Small")))

df[,c("height", "category_height")] %>% 
  head(20)

# Mutate makes this a lot simpler. It creates a new variable based on a set of rules
# It is especially powerful in combination with the function 'case_when'

df %>% 
  mutate(category_height = case_when(
    (height > 150) ~ "Tall",
    (height <= 150 & height > 120) ~ "Medium",
    (height <= 120 & height > 100) ~ "Small",
    (height <= 100) ~ "Very Small")) %>% 
  select(height, category_height) %>% 
  head(20)

# dplyr - group_by --------------------------------------------------------

# When working with real data, the function `group_by()` from the package `dplyr` is extremely helpful, and your best friend! 
# What does this function actually do? Well, it groups the data after the levels of a specified variable. 
# Say, you want to aggregate your data - you want to find the mean and standard deviation - separately for people of different planets. 
# The function `group_by()` prepares the data in the background, that is it instructs `R` to create separate data frames based on which you can perform subsequent operations. 
# These separate data frames are not seen by you, they are only in the background, and so you need to remember this when working with your data, otherwise you might run into difficulties. 
# The opposite of `group_by()`, or the way to deactivate the grouping of your data is by calling - after you've finished with whatever operations you had to do - the command `ungroup()`. 
# This instructs `R` to now de-activate the separate data frames and go back to the original data frame as the working one. 
# Perhaps a step-by-step example can be more instructive. While we are at it, let us use some of the other commands we've used so far.

# We first tell R to group after homeworld
# If we immediately insepct the outcome, we (nearly) see nothing different than the original data frame
df_grouped <- df %>% group_by(homeworld)

# this is...
head(df)

# ...(almost) identical to this
head(df_grouped)

# This is because we did not **use** this grouping so far, but `R` has kept it in its memory this task. 
# It knows that if we are to preform further operations on the data frame `df_grouped` then the output will be aggregated (organized) after the categories of the variable `homeworld`. 
# If you are uncertain if a df is grouped, or how, you can print it. Within RStudio you you see a "Groups:" tag above the variable names.

# Alternatively, you can check if a dataframe is grouped with `is_grouped_df()`.  

df %>% is_grouped_df()
df_grouped %>% is_grouped_df()

#You can also list the groups a dataframe has with `groups()`.
df_grouped %>% groups()

#if we want to ungroup a dataframe, we can call the 'ungroup()' function

df_grouped %>% ungroup() -> df_ungrouped
df_ungrouped
df_ungrouped %>% is_grouped_df()

# dplyr - group_by and summarise --------------------------------------------------------

# summarise() does what it says - it summarizes your data. 

df %>% 
  summarise(mean_height = mean(height, na.rm = TRUE),
            sd_height = sd(height, na.rm = TRUE))

#This is especially powerfull when the data comes in a grouped format

df_grouped %>% 
  summarise(mean_height = mean(height, na.rm = TRUE),
            sd_heigt = sd(height, na.rm = TRUE))
  

df_grouped %>% 
  summarise(mean_height = mean(height, na.rm = TRUE),
            sd_heigt = sd(height, na.rm = TRUE), 
            number_of_people = n())

# You can see, there are a lot of groups with only one person. 
# We can also group by e.g. gender

df %>%
  group_by(gender) %>% 
  summarise(mean_height = mean(height, na.rm = TRUE),
            sd_height = sd(height, na.rm = TRUE), 
            number_of_people = n())

#What happens if we try to group by more than one characterstic such as sex and gender?
#How can we interpret the differences?

df %>%
  group_by(sex, gender) %>% 
  summarise(mean_height = mean(height, na.rm = TRUE),
            sd_heigt = sd(height, na.rm = TRUE), 
            number_of_people = n())

# Exercises ----

## Exercise 1 -------------------

#Please compute the number of unique combinations for the variables homeworld and species!
#There is no single solution to this taks. Maybe you will find a new way?
#Hint:Maybe the 'nrow()' function might help you.

# (1) #Visual Inspection of Groups in the Console (Groups = 58)
df %>% group_by(homeworld, species) 

# (2) Calculating a statistic and inspecting length of dataframe
df %>% 
  group_by(homeworld, species) %>% 
  summarise(count = n()) %>% #This can also be another function
  nrow()

## Exercise 2 -------------------

#Below, you will find a function to calculate the body Mass index. 
#The function contains two arguments 'mass' and 'height'.
#The mass refers to kg, and the height to metre.
#To test the function, we will calculate the BMI for a character 

#Please execute the following code and load the function into your environment

bmi <- function(mass, height){ 
  # height must be in metres 
  # mass must be in kg 
  return(mass/height^2) 
} 

#Run the followowing line for a character with a mass of 100 kg and a height of 1.7 m
bmi(100, 1.7)

# Now, we want to create the BMI for all Star Wars Characters.
# To do so, please create the following (new) variables
# (1) "height_metre" = Height of a person in metre (Tip: Divide the height by 100)
# (2) "BMI" = The BMI for each person
# and save the data in the new dataframe "df_bmi"

df_bmi <- df %>% 
  mutate(height_metre = height/100,
         bmi_character = bmi(mass, height_metre ))

## Exercise 4 -------------------

#Finally, we want to evaluate the BMI for all Starwars Characters. 
#To do so, we will use group the characters into categories using the following information

#Underweight: <18.5
#Optimal: 18.5 to 25
#Overweight: >25

#Now, please create a new variable 'bmi-type' using the information above.
#Ultimately, you 

df_bmi %>% 
  mutate(bmi_type = case_when(
    (bmi_character < 18.5) ~ "Underweight",
    (bmi_character >= 18.5 & bmi_character <= 25) ~ "Optimal",
    (bmi_character > 25) ~ "Overweight")) %>% 
  count(bmi_type)
