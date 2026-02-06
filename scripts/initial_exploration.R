# Week 1: Initial Data Exploration ====
# Author: [Dayna Arbon]
# Date: [30/01/26]

# Load packages ====
library("tidyverse")
library("here")
library("naniar")
library("janitor")
library("skimr")
# Load data ====
mosquito_egg_raw <- read_csv(here( "data", "mosquito_egg_data.csv"),
                             name_repair = janitor::make_clean_names)

# Basic overview ====
glimpse(mosquito_egg_raw)
summary(mosquito_egg_raw)
skim(mosquito_egg_raw)

# React table====
# view interactive table of data
view(mosquito_egg_raw)


# Counts by site and treatment====

mosquito_egg_raw |> 
  group_by(site, treatment) |> 
  summarise(n = n())

# Observations ====
# Your observations (add as comments below):
# - What biological system is this?
# looking a different species of mosquito
# - What's being measured?
#   mass of mosquito 
# - How many observations?
#   205
# - Anything surprising?
#   there is a -93.0 body mass, there are lower case and upper case letters
# - Any obvious problems?
#   There are 13 missing values in the collector column, looks like id 13 is duplicated 

# identifying missing data ----
naniar::gg_miss_upset(mosquito_egg_raw)

# checking for duplicates ----

mosquito_egg_raw |> 
  get_dupes()

# 4 duplicates. 

mosquito_egg_raw |> mutate(collection_date = as_date(collection_date))
# no error so dates are ok. 


# FIX 1: upper and lower cases ====

# Show the problem:
mosquito_egg_raw |> distinct(treatment)


# Fix it: 
# YOUR CODE HERE
mosquito_egg_data_step1 <- mosquito_egg_raw |>
  mutate(treatment = case_when(
    treatment == "Medium_dose" ~ "medium_dose",
    treatment == "High_dose" ~ "high_dose",
    treatment == "Control" ~ "control",
    treatment == "HIGH_DOSE" ~ "high_dose",
    treatment == "LOW_DOSE" ~ "low_dose",
    treatment == "MEDIUM_DOSE" ~ "medium_dose",
    treatment == "CONTROL" ~ "control",
    treatment == "Low_dose" ~ "low_dose",
    .default = as.character(treatment)))
  
# Verify it worked:
mosquito_egg_data_step1 |> distinct(treatment)
  
  
  # What changed and why it matters:
  # all types of treatment changed to same name - all lower case- so when inputting code r doesnt miss any values.
  # this makes the process of analysing the data in r a much smoother process.
  
  
  # FIX 2:  removing negative and impossible body_mass_mg values ====

# Show the problem:
mosquito_egg_raw |> skim(body_mass_mg)                   

# YOUR CODE
# Fix it:
mosquito_egg_data_step2 <- filter(mosquito_egg_data_step1, body_mass_mg > 0)
  

  # Verify it worked:
mosquito_egg_data_step2 |> skim(body_mass_mg) 
  
  # What changed and why it matters:
  # the values in the negative are impossible.  
  # therefore averages/ means of the data will be inaccurate 










