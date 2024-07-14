Google Capstone Project
================
Kaivalya Gupta
2024-07-09

###### My Portfolio

I decided to use RStudio for my capstone project because I enjoyed
learning Rs capabilities and really fond of R Markdown and its ability
to report my analysis. I chose this project for a few reasons but one of
them was purely due to my interest in urban areas.

## Introduction

In this case study, I analyze the usage patterns of annual members and
casual riders of the Cyclistic bike-share program in Chicago, using
historical bike trip data from the first quarters of 2019 and 2020. The
goal is to understand how these two groups use Cyclistic bikes
differently and provide insights for marketing strategies to convert
casual riders into annual members. These insights will help Cyclistic
make strategic decisions to improve marketing efforts and service
offerings, ultimately enhancing customer satisfaction and profitability.

## Business Task

The business task is to understand how annual members and casual riders
use Cyclistic bikes differently. The insights from this analysis will
help design targeted marketing strategies to convert casual riders into
annual members, thereby increasing the company’s profitability.
Additionally, by understanding these different usage patterns, Cyclistic
can make informed decisions to optimize service improvements, tailor
promotions, and enhance overall user experience, leading to better
customer retention and satisfaction.

## Data Sources

The data used for this analysis includes historical bike trip data for a
fictional bike-share company named Cyclistic. This data represents bike
trips in Chicago for the first quarters of 2019 and 2020. The datasets
contain information about individual rides, including start and end
times, trip duration, start and end locations, and user types (member or
casual).

The data covers two distinct time periods:

- [Divvy 2019
  Q1](https://docs.google.com/spreadsheets/d/1uCTsHlZLm4L7-ueaSLwDg0ut3BP_V4mKDo2IMpaXrk4/template/preview?resourcekey=0-dQAUjAu2UUCsLEQQt20PDA#gid=1797029090)
- [Divvy 2020
  Q1](https://docs.google.com/spreadsheets/d/179QVLO_yu5BJEKFVZShsKag74ZaUYIF6FevLYzs3hRc/template/preview#gid=640449855)

These datasets were provided as part of a capstone project for the
Google Data Analytics Professional Certificate course. They were used to
apply data cleaning, manipulation, and analysis techniques learned
during the course to a real-world scenario. Although Cyclistic is a
fictional company, the data is based on real-world bike-share data from
the Divvy system in Chicago, which adds realism to the project.

## Data Cleaning

The data cleaning process involved several steps to ensure the data was
ready for analysis. This included preprocessing in Google Sheets and
further cleaning in R.

1.  Preprocessing in Google Sheets:

- Calculated columns for ride length and day of the week.
- Converted raw time data to ensure consistency.

2.  Cleaning in R:

- Renamed columns for consistency.
- Converted data types to ensure compatibility.
- Handled missing values and filtered out irrelevant data.

To combine our data the column headers needed to match.

``` r
# Matching the column names with necessary data
q1_2019 <- q1_2019 %>%
  rename(    ride_id = trip_id,
             started_at = start_time,
             ended_at = end_time,
             start_station_id = from_station_id,
             start_station_name = from_station_name,
             end_station_id = to_station_id,
             end_station_name = to_station_name,
             member_casual = usertype
  ) %>%
```

To avoid type errors I needed to confirm that ride IDs were characters
and ride length would be in seconds.

``` r
  # Matching types and values to 2020 data
  mutate(
    ride_id = as.character(ride_id),
    ride_length = period_to_seconds(hms(ride_length)),
    member_casual = ifelse(member_casual == "Subscriber", "member", "casual")
  ) %>%
  
  # Confirming matching types
  q1_2020 <- q1_2020 %>%
  mutate(
    ride_id = as.character(ride_id),
    ride_length = period_to_seconds(hms(ride_length))
  ) %>%
```

I made sure to only select the columns necessary for analysis from the
raw datasets. This step ensured that I focused on the most relevant
information, reducing noise and errors.

``` r
  # Selecting the necessary data from 2019
q1_2019 <- q1_2019 %>%
  select(
    ride_id, started_at, ended_at, start_station_id, start_station_name,
    end_station_id, end_station_name, member_casual, ride_length, day_of_week
  )
# Selecting necessary data from 2020
q1_2020 <- q1_2020 %>%
  select(
    ride_id, started_at,ended_at, start_station_id, start_station_name,  end_station_id, 
    end_station_name, member_casual, ride_length, day_of_week
  )
```

To ensure the accuracy functionality of my analysis I filtered out any
possible ‘NA’ values.

``` r
# Filter out NA values in ride_length 
all_data_filtered <- all_data %>%
  filter(!is.na(ride_length))
```

## Analysis

I conducted analysis with the cleaned and prepared data using
descriptive statistics and visualizations. Considering average ride
length by member type, average ride length for users by day of the week,
and the number of rides for users by day of the week I was able to
uncover that

1.  Average Ride Length by Member Type:
    - Casual riders have a significantly longer average ride length
      compared to annual members.
    - Casual Riders: 2,185 seconds (approximately 36 minutes)
    - Annual Members: 685 seconds (approximately 11 minutes)
2.  Average Ride Length by Day of the Week:
    - Casual riders consistently have longer average ride lengths across
      all days of the week compared to annual members.
    - The longest average ride length for casual riders occurs on
      Sunday, with an average of 2,451 seconds (approximately 41
      minutes).
    - The shortest average ride length for annual members occurs on
      Tuesday, with an average of 666 seconds (approximately 11
      minutes).
3.  Number of Rides by Day of the Week:
    - Annual members take more rides than casual riders on any given day
      of the week.
    - The highest number of rides for both casual riders and annual
      members occurs on Tuesday, with annual members taking 121,879
      rides and casual riders taking 8,348 rides.
    - Casual riders show a significant increase in the number of rides
      on weekends compared to weekdays, indicating a preference for
      leisure activities.

#### Average Ride Length by Member Type

Casual riders have a significantly longer average ride length compared
to annual members. This indicates that casual riders may use the bikes
more for leisure and longer trips, whereas members might be using them
more for short, routine trips.

#### Number of Rides by Day of the Week and Member Type

Annual members take more rides than casual riders on any given day of
the week. The highest number of rides for both casual riders and annual
members occurs on Tuesday, which could be a key day for targeted
promotions or service enhancements.

## Visualizations

My findings can be seen with…

- This bar chart shows the average ride length for both casual riders
  and annual members. It clearly illustrates that casual riders tend to
  take longer trips.

![](Screenshot 2024-07-14 145006.png)<!-- -->

- The bar chart below shows the average ride length by day of the week
  for both casual riders and annual members. Casual riders consistently
  have longer average ride lengths across all days of the week.

![](Screenshot 2024-07-14 145052.png)<!-- -->

- The bar chart below shows the number of rides taken by casual riders
  and annual members on different days of the week. It highlights that
  annual members have a higher number of rides overall.

![](Screenshot 2024-07-14 145114.png)<!-- -->

## Recommendations

These findings suggest that annual members and casual riders have
different usage patterns. Annual members appear to use the bikes more
for regular, shorter trips throughout the week, likely for commuting or
errands. In contrast, casual riders are more likely to use the bikes for
longer trips, particularly on weekends, indicating a preference for
leisure activities.

Implications for Marketing Strategies

1.  Targeted Marketing Campaigns: Develop campaigns highlighting the
    cost benefits and convenience of annual memberships for frequent,
    short trips. This could attract casual riders who might benefit from
    a membership for regular commuting or errands.

2.  Weekend Promotions: Offer weekend promotions to casual riders,
    showcasing the benefits of membership for leisure activities.

3.  Flexible Membership Options: Consider offering flexible membership
    options that cater to both commuting and leisure usage patterns to
    appeal to a broader audience.

The analysis provides valuable insights into the different usage
patterns of annual members and casual riders. By tailoring marketing
strategies to these patterns, Cyclistic can effectively convert more
casual riders into annual members, driving future growth and
profitability.
