# Author: QSS Ch. 1 script with edits by Mark Richardson & Benjamin Reese
# Date: 08/24/2023
# Purpose: Introduction to R - GOVT 8001 Lab I

## Part One - Intro to R

#### Arithmetic Operations ####

5 + 3
5 - 3
5 / 3
5 ^ 3
5 * (10 - 3)
sqrt(4)

#### Objects ####

result <- 5 + 3
result
print(result)
result <- 5 - 3
result

Result

kosuke <- "instructor"
kosuke
kosuke <- "instructor and author"
kosuke

Result <- 5
Result + 2
result

class(result)
Result
class(Result)
class(sqrt)

sum(result)

sum(Result)

#### Vectors ####

# Creating vectors

world.pop <- c(2525779, 3026003, 3691173, 4449049, 5320817, 6127700, 6916183)
world.pop

pop.first <- c(2525779, 3026003, 3691173)
pop.second <- c(4449049, 5320817, 6127700, 6916183)
pop.all <- c(pop.first, pop.second)
pop.all

# Accessing elements of a vector

world.pop[2]
world.pop[c(2, 4)] 
world.pop[c(4, 2)] 
world.pop[-3]

# Arithmetic operations on a vector

pop.million <- world.pop / 1000
pop.million

pop.rate <- world.pop / world.pop[1]
pop.rate

pop.increase <- world.pop[-1] - world.pop[-7]
pop.increase

percent.increase <- (pop.increase / world.pop[-7]) * 100
percent.increase

# Can replace individual elements (better way is to use round())

round(percent.increase)

percent.increase[c(1, 2)] <- c(20, 22)
percent.increase

#### Functions ####

length(world.pop)  

min(world.pop)     

max(world.pop)     

range(world.pop)   

mean(world.pop)    

sum(world.pop) / length(world.pop) 

year <- seq(from = 1950, to = 2010, by = 10)
year

seq(to = 2010, by = 10, from = 1950)

seq(1950, 2010, 10)

seq(2010, 1950, -10)

seq(from = 2010, to = 1950, by = -10)
2008:2012
2012:2008

names(world.pop) 
names(world.pop) <- year
names(world.pop)

world.pop

#### Saving data and loading data ####
 
# Create a data set (Table 1.2)
# tibble() is the equivalent of data.frame() tidyverse function from the tibble package
UNpop <- data.frame(world.pop = world.pop,
                    year = year)

# Get basic information about the data set

names(UNpop)

nrow(UNpop)

ncol(UNpop)

dim(UNpop)

summary(UNpop)

UNpop$world.pop

UNpop[, "world.pop"] # extract the column called "world.pop"
UNpop[c(1, 2, 3, 5), ]   # extract the first three rows (and all columns)
UNpop[1:3, "year"]   # extract the first three rows of the "year" column

UNpop$world.pop[seq(from = 1, to = nrow(UNpop), by = 2)]

# File paths and working directory

getwd()

setwd("") # Need to insert your file path here

getwd() # Confirm the change

#### Getting Help: mean() example ####

world.pop <- c(UNpop$world.pop, NA)
world.pop

mean(world.pop)

?mean

mean(world.pop, na.rm = TRUE)

## Part Two - Intro to tidyverse

# Packages

## install.packages("devtools") # install the package
library(devtools) # load the package

## install a package from github
## devtools::install_github("kosukeimai/qss-package", build_vignettes = TRUE)
library(qss) ## loading in qss
## You may need to allow R to update/install additional packages

## Loading in tidyverse
## install.packages("tidyverse")
library(tidyverse)

## Loading in a Dataset
data(UNpop, package = "qss")

## Number of Rows and Columns - Base R
dim(UNpop)

## Number of observation, number of variables, and initial observations - tidyverse
glimpse(UNpop)

## First 6 rows
head(UNpop)

## Last 6 Rows
tail(UNpop)

## Selecting A Variable - Base R
UNpop$world.pop

## subset all rows for the column called "world.pop" from the UNpop data
UNpop[, "world.pop"]
## subset the first three rows (and all columns)
UNpop[c(1, 2, 3),]
## subset the first three rows of the "year" column
UNpop[1:3, "year"]

## Now with tidyverse

## Subset the first three rows of UNpop with tidyverse
slice(UNpop, n = 1:3)

## Extract/subset the world.pop variable (column)
select(UNpop, world.pop)

## Base R subset the first three rows of the year variable
UNpop[1:3, "year"]
## or in tidyverse, combining slice() and select()
select(slice(UNpop, 1:3), year)

## Basic Data Wrangling with the tidyverse using pipes (i.e., %>%)

UNpop %>% # take the UNpop data we have loaded, and then...
  slice(1:3) %>% # subset the first three rows, and then...
  select(year) # subset the year column

UNpop %>%
  slice(seq(1, n(), by = 2)) %>% # using a sequence from 1 to n()
  select(world.pop)

pop.1970 <- UNpop %>% # take the UNpop data and then....
  filter(year == 1970) %>% # subset rows where the year variable is equal to 1970
  select(world.pop) %>% # subset just the world.pop column
  pull() # return a vector, not a tibble

## Print the vector to the console to see it
print(pop.1970)

UNpop.mill <- UNpop %>% # create a new tibble from UNpop
  mutate(world.pop.mill = world.pop / 1000) %>% # create a new variable, world.pop.mill
  select(-world.pop) # drop the original world.pop column

## Adding a variable with if_else
UNpop.mill <- UNpop.mill %>%
  mutate(after.1980 = if_else(year >= 1980, 1, 0))

## Creating a vector of the years of interest
specific.years <- c(1950, 1980, 2000)

## Adding a variable with if_else and %in%
UNpop.mill <- UNpop.mill %>%
  mutate(year.of.interest = if_else(year %in% specific.years, 1, 0))

summary(UNpop.mill)
mean(UNpop.mill$world.pop.mill)

## Add a row where values for all columns is NA
UNpop.mill.wNAs <- UNpop.mill %>%
  add_row(year = NA, world.pop.mill = NA,
          after.1980 = NA,
          year.of.interest = NA)
## Take the mean of world.pop.mill (returns NA)
mean(UNpop.mill.wNAs$world.pop.mill)
## Take the mean of world.pop.mill (ignores the NA)
mean(UNpop.mill.wNAs$world.pop.mill, na.rm = TRUE)

## Other Summary Statistics with tidyverse
UNpop.mill %>%
  summarize(mean.pop = mean(world.pop.mill),
            median.pop = median(world.pop.mill))

UNpop.mill %>%
  group_by(after.1980) %>% # create subset group for each value of after.1980
  summarize(mean.pop = mean(world.pop.mill)) # calculate mean for each group

