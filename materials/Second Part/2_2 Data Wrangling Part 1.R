####################################
### Day 2: GESIS Fall Seminar
### Session 2: Data Wrangling Part I
####################################

#Loading Packages

library(tidyverse)

df <- dplyr::starwars

# ------------------------------------
## Coding 

# dplyr - select ----------------------------------------------------------

names(df)
View(df)

# For better handling it is recommended to limit the data set to relevant
# variables. This is done with 'select()' in dplyr

?select

select(df, name) # select only the variable 'district'.
select(df, name, height) # also works with multiple variables, however, the df should be the first argument

# Reminder Base R:
# select single variable with base R is done using the dollar sign '$'
# Or square brackets
df$name #with $ operator
df[,1] #with square bracket
df[,'name'] 
df[,"name"]
df[,c('name')]
df[,c('name', "height")]
df[,'name', "height"] #Throws an Error

# Notice. Without an assignment (<-) we don't create anything new / change anything!

# Now let's limit the data set to the most important variables

select(df, name, height, mass, homeworld, skin_color) # Within select functions can be passed!

# negation of single variables is also often useful

select(df, -vehicles) # - excludes the variable

#Save the result

df_limited <- select(df, name, height, mass, homeworld, skin_color) # Within select functions can be passed!
df_limited
View(df_limited)

# dplyr - filter ----------------------------------------------------------

# Now we have limited ourselves to the interesting variables. Filter helps us
# now filter rows

filter(df, homeworld == "Tatooine") # only people from Tatooine (don't forget the double equal signs)

filter(df, homeworld != "Tatooine") # no people from Tatooine

filter(df, !is.na(homeworld)) #characters without NAs
filter(df, is.na(homeworld)) #characters with NAs

# Filter is very flexible and powerful!

# all people with a height over 100 cm
filter(df, height > 100)

# Select specific homeworlds
# Reminder: | ist the OR operator
filter(df, homeworld == 'Tatooine' | homeworld == 'Alderaan' |
         homeworld == 'Naboo')

# More elegant solution 
filter(df, homeworld %in% c('Tatooine', 'Alderaan', 'Naboo'))

# dplyr - arrange ----------------------------------------------------------

# arrange helps us to reorder and sorting data frame rows

df
df_arranged <- arrange(df, height)
View(df_arranged)

# This also works with two variables

arrange(df, homeworld, height )

# This gets a little messy to look at. Lets try this the tidy way

df %>% 
  arrange(homeworld, height) %>% 
  select(name, homeworld, height) %>% 
  head(20)

#Looks good. All people are now sorted according to their height grouped by their homeworld

#'arrange()' can also sort descending. Here, we have to wrap the argument variable in the 'desc()' function

arrange(df, desc(height))

df %>% 
  arrange(homeworld, desc(height)) %>% 
  select(name, homeworld, height) %>% 
  head(20)

# dplyr - rename ----------------------------------------------------------

#'rename()' does what it says. It renames the variables (columns) of a data set
df
rename(df, "Character" = "name")

# Non-syntactic names (e.g., with spaces) should be wrapped around 'back quotes'

rename(df, `Star Wars Character` = "name") #However, non-syntactic names are not very clean 

#Renaming is also possible with multiple variables

rename(df, "Person" = "name", "eyes" = "eye_color", "origin" = "homeworld") %>% 
  select(Person, eyes, origin)

# dplyr - drop_na ----------------------------------------------------------

df

#As you can see, there are some values with missing cases ("NA")
#Let us first inspect, how many missing cases there are in the variable "birth_year"

df$birth_year
table(df$birth_year, useNA = "always")
table(df$birth_year)
table(df$birth_year, useNA = "ifany")

#the amount of "NA"s can also be calculated using the 'is_na()' function, which gives a vector 
#of "TRUE" or "FALSE", if a value is "NA"

is.na(df$height)
table(is.na(df$height)) 

#we can even create a new variable with the amount of "NA"s for the whole dataframe

df$count_na <- rowSums(is.na(df)) 
df %>% select(name, count_na) %>% head(20)

#But what do we do if we want to get rid of all observations with missing values in a specific variable?
#Well, we can call 'drop_na'

df_not_NA_height <- df %>% 
  drop_na(height) 

is.na(df_not_NA_height$height)

#We can do this also for the whole dataset

df %>% 
  drop_na()

#However, this deletes all rows with at least one "NA". 
#This leaves us with only 29 observations. 

#Pro Tip: There are also ways to impute values for missing cases (instead of dropping them altogether).
#We will cover some techniques for doing so in Part II of this section. 

# dplyr - slice() and sample_n() ----------------------------------------------------------

# the 'nrow()' function tells us the number of rows in a dataframe
nrow(df) 

# As we can see, the data frame has 87 rows 
# Howvever, sometimes we want to create a smaller subset of the data
# This can be done using 'slice()' and 'slice_sample()'

#It is always important to have a look at the function arguments

?slice_sample

#'slice_sample()', on the one hand, draws a random sample from the data


slice_sample(df,20) #This is not working
slice_sample(df,n =20) #This is working

#'slice()', on the other hand, slices the data frame in the order of the dataframe
# Note, that the format to provide the numeric argument is different from the 'slice_sample()' function.
# This can happen and this is why you often have to check the documentation of functions.

slice(df, 20) #row 20
slice(df, 1:20) #row 1 to 20
slice(df, 20:87) #row 20 to 87

#Looking again at base R

df[20,]
df[1:20,]
df[20:87, ]

df[20:87, c("name")]
df[20:87, 1]
df[20:87, c("name", "mass")]
df[20:87, c(1,2)]
df[20:87, "name", "mass"] #This throws an error. Can you spot why?

# Is there a difference in the complexity of the code? 
# What could be the advantage of the tidyverse 'slice()'function compared to the R base approach?

rm(list=setdiff(ls(), "df")) #This deletes all objects in the working directory which do not have the name "df"

# Exercises ----

## Exercise 1 -------------------
# create a pipeline using the '%>%' operator to 
#a) select the variables 'name', 'gender', 'skin_color' and 'mass'
#b) drop all NA's for the variable 'gender'
#c) rename the variable 'skin_color' to 'skin'
#d) and take a random sample of 3 Star Wars Characters

df 

## Exercise 2 -------------------
# create a pipeline using the '%>%' operator to 
#a) select all variables that start with the letter "h". 
#b) delete all rows with missing cases for the variable "hair_color"
#c) report the length of the new dataframe using the ´str()´ function
# Tip: you can Google the combination of the ´select()´ and ´starts_with()´ function for step a)

df 

## Exercise 3 -------------------

# If you have time left, please build your own data pipeline using the functions presented.
# Could you think of any other functions which are needed to transform the dataset 'df'? 
# Is there already an interesting finding you can find in the data? Feel free to present it
# to the group in the discussion


