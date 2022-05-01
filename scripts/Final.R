## SET UP WORKSPACE ##
install.packages("opendatatoronto")
install.packages("lubridate")
install.packages("knitr")
install.packages("janitor")
install.packages("tidyverse")
install.packages("tidyr")
install.packages("dplyr")

library(knitr)
library(janitor)
library(lubridate)
library(opendatatoronto)
library(tidyverse)
library(tidyr)
library(dplyr)

## GET RESOURCES AND WRITE TABLE ## 

covid_cases <- # what i want to name my data frame
  list_package_resources("64b54586-6180-4485-83eb-81e8fae3b8fe") |> 
  # the green code within the quotation is the ID for my data frame, can be found under "For Developers" section on OpenData webpage 
  filter(row_number()==1) |> 
  get_resource()

write_csv(
  x = covid_cases, # name of the data frame chosen above
  file = "covid_cases.csv"
)

## CHECK THE TABLE ##
head(covid_cases)

## CLEAN UP DATA ##

covid_cases_clean <- # renamed data frame with the desired columns
  clean_names(covid_cases) |> 
  select(age_group, source_of_infection, episode_date, reported_date, outcome,
         client_gender) |>
  drop_na(age_group)
# I chose these headings/columns

## CHECK CLEANED DATA ## 
head(covid_cases_clean)

## WRITE TABLE FOR CLEANED DATA ##
write_csv(
  x = covid_cases_clean, 
  file = "covid_cases_clean.csv"
)

covid_cases_clean <- 
  read_csv(
    "covid_cases_clean.csv",
    show_col_types = FALSE
  )

## CHECK CLEANEAD DATA AGAIN##
head(covid_cases_clean)

##--------------------------------------------------##

## SET UP THE GRAPH 1##

covid_cases_clean |> # this is the name of my cleaned dataframe
  ggplot(mapping = aes(x = outcome, y = age_group, fill = client_gender)) +
  
  # the above identifies how I want my graph will be: aes means aesthetic of the graph
  # state x and y variables by recalling their name from the csv table 
  # fill means the variable that will determine the colour
  # in this case, different bars will have different colours depending on year_stage
  
  geom_bar(stat="identity", position = "dodge") +
  
  # this means that I am creating a bar graph
  # dodge means the bars won't be stacked, they will be side by side
  
  labs(title = "Reported COVID-19 Case Outcomes Based on Gender and Age", 
       x = "Case Outcome", 
       y = "Age Group",
       fill = "Gender") +
  # labs means labels!! 
  
  theme_classic() +
  scale_fill_brewer(palette = "Set1")
# theme is the background and scale brewer are used for bar colours!!

## GRAPH1 WITHOUT THE COMMENTS ##

covid_cases_clean |> 
  ggplot(mapping = aes(x = outcome, y = age_group, fill = client_gender)) +
  geom_bar(stat="identity", position = "dodge") +
  labs(title = "COVID-19 Outcomes Based on Gender and Age", 
       x = "Case Outcome", 
       y = "Age Group",
       fill = "Gender") +
  theme_classic() +
  scale_fill_brewer(palette = "Set1")

#GRAPH 2
covid_cases_clean |> 
  ggplot(mapping = aes(x = source_of_infection, y = age_group, fill = outcome)) +
  geom_bar(stat="identity", position = "dodge") +
  labs(title = "COVID-19 Outcomes Based on Gender and Age", 
       x = "Source of Infection", 
       y = "Age Group",
       fill = "Outcome") +
  theme_classic() +
  scale_fill_brewer(palette = "Set1")



