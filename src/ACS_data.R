library(tidycensus)
library(tidyverse)
library(dplyr)
library(purrr)
library(broom)

# Set your API key
# census_api_key("Your Key Here", install = TRUE, overwrite = TRUE)  # replace 'your_key_here' with your actual API key

# Variables of interest with ACS code
setwd('/Users/babak.jfard/projects/NASA_IMERG_Respiratory/')

vars <- c( # For 2011 -2019
  "B17001_001", "B17001_002", # Poverty: Total, Below poverty line
  
  "B99221_001", "B99221_002",      # Imputed Food Stamp: Total, Imputed
  
  c(paste0("B15002_00", 3:9), paste0("B15002_010")), #Below high school, Male
  "B15002_002",     # Educational attainment over 25: Male Total 
  c(paste0("B15002_0", 20:27)), #Below high school, Female
  "B15002_019"    # Educational attainment over 25: FeMale Total 
)



# Years to retrieve data for (ACS 5-year data available from 2005 onwards)
years <- 2009:2021
# Function to get ACS data for a given year
states = c('CA', 'GA', 'OR', 'SC')

for (state in states){

  get_acs_data_for_year <- function(year) {
    get_acs(geography = "county",
            variables = vars,
            state = state,
            survey = "acs5",
            year = year,
            geometry = FALSE) %>%
      mutate(year = year)  # Add year column to identify the data year
  }
  
  # Retrieve data for all years using map_df to combine into a single data frame
  all_years_data <- map_df(years, get_acs_data_for_year)
  
  # Changing the year into the center of the 5-year estimate
  all_years_data$year <- all_years_data$year - 2
  
  print(paste(">>>>>>>>>>> The State is:", state))
  print(head(all_years_data))
  print(colSums(is.na(all_years_data)))
  print(length(unique(all_years_data$GEOID)))
  
  # Check if some statistics to be consistent for all years
  print(all_years_data %>% group_by(year) %>%
    summarise(Total_rows = n(), counties=length(unique(GEOID)),
              vars= length(unique(variable))))
  
  # Cleaning and spreading the data for readability
  data_cleaned <- all_years_data %>%
    select(GEOID, variable, estimate, year) %>%
    pivot_wider(names_from = variable, values_from = estimate)
  
  final_acs <- data_cleaned %>% mutate(Poverty = B17001_002/B17001_001,
                                       Food_STAMP = B99221_002/B99221_001,
                                       Education = (rowSums(across(B15002_003:B15002_010))+
                                                      rowSums(across(B15002_020:B15002_027)))/
                                                      (B15002_002+B15002_019)) %>%
    select(c(year, GEOID, Poverty, Food_STAMP, Education))
  
  
  # linear regressions to later impute missing years
  fit_p <- list()
  fit_f <- list()
  fit_e <- list()
  
  for (county in unique(final_acs$GEOID)){
    lm_data <- final_acs %>% filter(GEOID == county)
    
    fit_p[[county]] <- lm(Poverty ~ year, data = lm_data)
    fit_f[[county]] <- lm(Food_STAMP ~ year, data = lm_data)
    fit_e[[county]] <- lm(Education ~ year, data = lm_data)
    
  }

  # Adding the required years
  final_acs <- bind_rows(expand_grid(year=2003:2006, GEOID=unique(final_acs$GEOID)), final_acs)
  
  final_acs <- final_acs %>% 
    rowwise() %>% 
    mutate(Poverty = ifelse(is.na(Poverty), fit_p[[GEOID]]$coefficients[2]* year +fit_p[[GEOID]]$coefficients[1], Poverty),
           Food_STAMP = ifelse(is.na(Food_STAMP), fit_f[[GEOID]]$coefficients[2]* year +fit_f[[GEOID]]$coefficients[1], Food_STAMP),
           Education = ifelse(is.na(Education), fit_e[[GEOID]]$coefficients[2]* year +fit_e[[GEOID]]$coefficients[1], Education)) %>% 
    ungroup()

  print(colSums(is.na(final_acs)))
  write_csv(final_acs, paste0('Data/interim/', state,"_acs5.csv"))
}


