####################################
### Day 2: GESIS Fall Seminar
### Session 1: Intro to the Tidyverse
####################################

#Loading packages

# Check if tidyverse is already installed
if (!require(tidyverse)) {
  install.packages("tidyverse")
  require(tidyverse)}

#Loading Packages
library(tidyverse)
library("tidyverse") #the same

# ------------------------------------
## Coding 

#Buildung up on work from the first day, we will continue to work with our star wars dataset.
#The dataset can be directly loaded via the dplyr package.

starwars
dplyr::starwars #This is identical

df <- dplyr::starwars

df 

#the starwars dataset is now loaded as a tibble
#You can find more information on tibbles here: https://tibble.tidyverse.org/

is_tibble(df)
is.data.frame(df)

df_dataframe <- as.data.frame(df)

df_dataframe #Base-R dataframe
df #tibble

#Can you spot any difference between tibbles and data frames? 

# ----

# Piped functions as introduced by ` %>% ` are a life saver, as the instruct `R` to store in the temporary memory an object, operate on it, store it again in the temporary memory and finally perform a last operation and this time store the outcome in an object in `R` that can be called, visualized, and so on. In other words, piped functions simplify the work flow greatly!
# Shortcut for Windows: STRG+Shift+M
# Shortcut for Mac: Cmd+Shift+M
# Say, in addition to age, we also collected information on characters assigned biological sex 

## Comparison between Tidyverse and R base: Height between different subgroups
###Base R

unique(df$sex)

df$sex
df$height

# creates vectors containing age information for the categories 'men', 'female', 'hermaphroditic' and 'none'

df_male <- df[which(df$sex=="male"),]
df_female <- df[which(df$sex =="female"),]
df_her <- df[which(df$sex =='hermaphroditic'),]
df_none <- df[which(df$sex=="none"),]

# call each object for inspection
df_male
df_female
df_her
df_none

# we now store the content of the vector height as a separate variable

height_male <- df_male$height
height_female <- df_female$height
height_her <- df_her$height
height_none <- df_none$height

# applies the function mean() to each object
mean_male <- mean(height_male, na.rm=TRUE)
mean_female <- mean(height_female, na.rm=TRUE)
mean_her <- mean(height_her, na.rm=TRUE)
mean_none <- mean(height_none, na.rm=TRUE)

# combine it into a tibble

sex <- c("male","female","hermaphroditic","none")
mean_height <- c(mean_male, mean_female,mean_her,mean_none)

average_heigt_R <- tibble(sex, mean_height)
average_heigt_R

#Though the approach above gave us our intended outcome, it took 5 steps for each category, so many lines of code, to arrive at the desired outcome. 
#The piped functions can simplify this, organize your code, as well as give results faster. 
#Let us now arrive at identical results but using a tidyverse approach. 

# calculates the average height using %>% 
# it first groups for sex
# then it calculates the mean height for each group
average_heigt_tidy <- df %>% 
  group_by(sex) %>%  # step 1
  summarise(mean=mean(height,na.rm=TRUE, ),# step 2
            n = n()) 

# call both results
average_heigt_R
average_heigt_tidy

#- Are the results identical?
#- Did one solution take less time to arrive at the same result?


# This example highlights an important finding. (Nearly) all operations can be done in base R.
# However, using the tidyverse is often faster, more convenient and clearer.
# Throughout the day, we will get to some of the most popular functions and use cases again.

# Exercises ----

## Exercise 1 -------------------

# (1.1) Adjust the code chunks below using base R and the []-Operator, so that the first 20 rows in the tibble are selected

df[1:20,]

# (1.2) Adjust the code chunks below using the ´slice()´ function from dyplyr, so that the first 20 rows in the tibble are selected
#     If you need more information on the slice()-function, please inspect the documentation using '?slice'

slice(df, 1:20)

# (1.3) sample 10 random observations from the ´df´ using the ´slice_sample()´ function from the dplyr-package. 
# If you are unsure about the arguments of the ´slice_sample()´function, have a look at the documentation using ´?slice_sample´

?slice_sample
slice_sample(df, n = 20)


## Exercise 2 -------------------

# Use the `%>%` operator to call the function ´glimpse()´ to the  data frame ´df´

df %>% 
  glimpse()

## Exercise 3 -------------------

# Rewrite the following code using the %>% operator

summary(select(head(df), sex, height))

df %>% 
  head() %>% 
  select(sex, height) %>% 
  summary()

##-------------------

rm(list=setdiff(ls(), "df")) #This deletes all objects in the working directory which do not have the name "df"
