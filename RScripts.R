options(repos = c(CRAN = "https://cran.rstudio.com/"))
# Packages
install.packages("tidyverse")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("scales")

library(tidyverse)
library(lubridate)
library(ggplot2)
library(dplyr)
library(scales)

# Data
q1_2019 <- read_csv("Divvy_Trips_2019_Q1.csv")
q1_2020 <- read_csv("Divvy_Trips_2020_Q1.csv")

# Cleaning Data
colnames(q1_2019)
colnames(q1_2020)

# Matching the column names with necessary data
q1_2019 <- q1_2019 %>%
  rename(
    ride_id = trip_id,
    started_at = start_time,
    ended_at = end_time,
    start_station_id = from_station_id,
    start_station_name = from_station_name,
    end_station_id = to_station_id,
    end_station_name = to_station_name,
    member_casual = usertype
  ) %>%
  # Matching types and values to 2020 data
  mutate(
    ride_id = as.character(ride_id),
    ride_length = period_to_seconds(hms(ride_length)),
    member_casual = ifelse(member_casual == "Subscriber", "member", "casual")
  ) %>%
  # Selecting the necessary data from 2019
  select(
    ride_id, started_at, ended_at, start_station_id, start_station_name,
    end_station_id, end_station_name, member_casual, ride_length, day_of_week
  )

# Selecting necessary data from 2020
q1_2020 <- q1_2020 %>%
  # Confirming matching types
  mutate(
    ride_id = as.character(ride_id),
    ride_length = period_to_seconds(hms(ride_length))
  ) %>%
  select(
    ride_id, 
    started_at, 
    ended_at, 
    start_station_id, 
    start_station_name, 
    end_station_id, 
    end_station_name, 
    member_casual, 
    ride_length, 
    day_of_week
  )

# Aggregating Data
all_data <- bind_rows(q1_2019, q1_2020)

# Filter out NA values in ride_length 
all_data_filtered <- all_data %>%
  filter(!is.na(ride_length))

# Summary statistics
summary_stats <- all_data_filtered %>%
  summarize( 
    mean_ride_length = mean(ride_length),
    max_ride_length = max(ride_length)
  )

# Average ride length for members and casual riders
average_ride_length_members <- all_data_filtered %>%
  group_by(member_casual) %>%
  summarize(
    mean_ride_length = mean(ride_length)
  )

# Average ride length for users by day of the week
average_ride_length_day_member <- all_data_filtered %>%
  group_by(day_of_week, member_casual) %>%
  summarize(
    mean_ride_length = mean(ride_length)
  )

# Number of rides for users by day of the week 
number_rides_day_member <- all_data_filtered %>%
  group_by(day_of_week, member_casual) %>%
  summarize(
    number_of_rides = n()
  ) %>%
  ungroup() %>%
  group_by(day_of_week) %>%
  mutate(total_rides = sum(number_of_rides))

# Combine all descriptive analysis
combined_data <- list(
  summary_stats = summary_stats,
  average_ride_length_members = average_ride_length_members,
  average_ride_length_day_member = average_ride_length_day_member,
  number_rides_day_member = number_rides_day_member
)

# Create a data frame 
combined_df <- bind_rows(
  summary_stats %>% mutate(type = "summary_stats"),
  average_ride_length_members %>% mutate(type = "average_ride_length_members"),
  average_ride_length_day_member %>% mutate(type = "average_ride_length_day_member"),
  number_rides_day_member %>% mutate(type = "number_rides_day_member")
)

# Average Ride Length by Member Type
ggplot(average_ride_length_members, aes(x = member_casual, y = mean_ride_length, fill = member_casual)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Average Ride Length by Member Type", x = "Member Type", y = "Average Ride Length (seconds)") +
  scale_fill_discrete(name = "Member Type") +
  theme(legend.position = "bottom")

# Average Ride Length by Day of the Week and Member Type
ggplot(average_ride_length_day_member, aes(x = factor(day_of_week), y = mean_ride_length, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(title = "Average Ride Length by Day of the Week and Member Type", x = "Day of the Week", y = "Average Ride Length (seconds)") +
  scale_fill_discrete(name = "Member Type") +
  theme(legend.position = "bottom")

# Number of Rides by Day of the Week and Member Type
ggplot(number_rides_day_member, aes(x = factor(day_of_week), y = number_of_rides, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(title = "Number of Rides by Day of the Week and Member Type", x = "Day of the Week", y = "Number of Rides") +
  scale_fill_discrete(name = "Member Type") +
  theme(legend.position = "bottom") +
  scale_y_continuous(labels = comma)
