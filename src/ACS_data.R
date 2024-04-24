library(tidycensus)
library(tidyr)
library(dplyr)
library(purrr)

# Set your API key
census_api_key("your_key_here")  # replace 'your_key_here' with your actual API key

# Variables of interest with ACS code

vars <- c( # For 2011 -2019
  Poverty_Total = "B17001_001", Poverty_below = "B17001_002", 
  
  FedAssist = "B19058_002", FedAssist_Total = "B19058_001",
  
  NoHighSchool = c(paste0("B15003_00", 2:9), paste0("B15003_0", 10:16)),
  Education_total = "B15003_001",
  
  # Health Coverage
  Total_Pop_Insurance = "B27001_001",
  Not_Insured = c(paste0("B27001_00", seq(5, 8, 3)),
                    paste0("B27001_0", seq(11, 29, 3), "E"),
                    paste0("B27001_0", seq(33, 57,3), "E")),
  
  Unemployment_civilian = "B23025_005", #Total! In labor Force! Civilian labor force! Unemployed!
  labor_force_civilian = "B23025_003"
)

vars <- c( # For 2005 -2010
  Poverty_Total = "B17001_001", Poverty_below = "B17001_002", 
  
  FedAssist = "B19058_002", FedAssist_Total = "B19058_001",
  
  NoHighSchool = c(paste0("B15003_00", 2:9), paste0("B15003_0", 10:16)),
  Education_total = "B15003_001",
  
  # Health Coverage
  Total_Pop_Insurance = "B27001_001",
  Not_Insured = c(paste0("B27001_00", seq(5, 8, 3)),
                  paste0("B27001_0", seq(11, 29, 3), "E"),
                  paste0("B27001_0", seq(33, 57,3), "E")),
  
  Unemployment_civilian = "B18120_012",   # Estimate!!Total!!In the labor force!!Unemployed
  labor_force_civilian = "B18120_002"     # Estimate!!Total!!In the labor force
)

# Years to retrieve data for (ACS 1-year data available from 2005 onwards)
years <- list(2)
years[[1]] <- 2005:2010
years[[2]] <- 2011:2019

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
all_years_data <- map_df(years[[1]], get_acs_data_for_year)

head(all_years_data)
colSums(is.na(all_years_data))
length(unique(all_years_data$GEOID))

# Cleaning and spreading the data for readability
data_cleaned <- all_years_data %>%
  select(NAME, variable, estimate, moe, year) %>%
  spread(key = variable, value = estimate)

# View the cleaned data
print(data_cleaned)


