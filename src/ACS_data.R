library(tidycensus)
library(dplyr)
library(purrr)

# Set your API key
census_api_key("your_key_here")  # replace 'your_key_here' with your actual API key

# Variables of interest with ACS code
vars <- c(
  Poverty_Total = "B17001_001", Poverty_below = "B17001_001", 
  FedAssist = "B19058_002", FedAssist_Total = "B19058_001"
  Unemployment = "B23025_005", #Total! In labor Force! Civilian labor force! Unemployed!
  labor_force = "B23025_003"  #
  
  NoHighSchool = "B15003_002",
  EngBarriers = "B16004_002",
  HealthInsurance = "B27001_002"
)

# Years to retrieve data for (ACS 1-year data available from 2005 onwards)
years <- 2005:2019

# Function to get ACS data for a given year
get_acs_data_for_year <- function(year) {
  get_acs(geography = "county",
          variables = vars,
          state = "CA",
          survey = "acs1",
          year = year) %>%
    mutate(year = year)  # Add year column to identify the data year
}

# Retrieve data for all years using map_df to combine into a single data frame
all_years_data <- map_df(years, get_acs_data_for_year)

# Cleaning and spreading the data for readability
data_cleaned <- all_years_data %>%
  select(NAME, variable, estimate, moe, year) %>%
  spread(key = variable, value = estimate)

# View the cleaned data
print(data_cleaned)


