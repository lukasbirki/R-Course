# Live coding ---- 
# Loading 
library(tidyverse) # notice the console. The tidyverse overwrites a small number of base R functions.
# You can access these functions using the package name and the :: notation e.g. stats::filter()

# read in starwars dataframe from csv with function
getwd()
star_1 <- read_csv("day_1/data/starwars.csv") # use tab within the "" to see files in the working directory
# show import dataset tool

# Have a look at the read in file 
star_1 
view(star_1) # equivalent to 

# get data out of a dataframe
# as a vector
star_1$height
star_1[["height"]]

# as a subset - meaning it returns a tibble 
star_1[,2]
star_1[,c(1,2)]
star_1[1:10,]
star_1[1:10,c(1,2)]

# You can perform vector operations on the extracted data
star_1$height # height in cm
star_1$height/100 # height in meter 

# For every read in function there is a write function 
# Lets write some subsetted data to our data folder (the folder is /day_1/data)
sub_setted_data <- star_1[1:10,c(1,2)]

write_csv(x = sub_setted_data,
          file = "day_1/data/sub_setted_data.csv")

# Exercise 7 ----
# Before you start, click on session (in the toolbar on top) and then on "clear workspace".
# Then load the tidyverse 
library(tidyverse)

## 1 Reading in data frames ----
# Use the read_X functions from the readr package to read in the different files in the data folder.
# Assign each of the data sets to a variable.
# To help you find the correct function, navigate to the data folder in the "Files" panel 
# in the bottom right panel. When you are seeing the content of the folder, check out the 
# file extensions (e.g. the .csv part) to get a clue which function you should use.
# If you need more information on the file, click on it in the Files panel. The file
# opens and you can see its contents and maybe guess the encoding of the file.

# If you can't find the correct function, try the "Import Dataset" tool in the top right panel.

# Bonus challange: There is one mystery format which can be read in by one of the functions
# from the readr package


## 2 First steps working with data frames / tibbles ----
# By default, all the data you read in is saved as a tibble 
# Try extracting the height column of "starwars.csv" in three different ways:
# df[["name"]]
# df$name
# df[,n] where n is the column number of the height column 

## 3 Create the following data frame / tibble yourself using the tibble() function ----

# name             height       is_human
# Luke Skywalker	 172          TRUE
# C-3PO	           167          FALSE
# R2-D2	           96	          FALSE
# Darth Vader	     202          TRUE

new_tibble <- tibble(
  
)

# Remember: Each column of a data frame / tibble is just a vector of a certain type.

## 4 Write the data frame / tibble created in the previous exercise to the data folder ----
## using the write_rds function. Don't forget to add the file ending ".rds" to the datapath,
## otherwise RStudio and your operating system won't know what type of file will be written.
