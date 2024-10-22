##Load in data and packages
library(tidyverse)
bike <- read_csv("sfo-bike-modified.csv")

##How do the number of trips differ by starting station? Generate a bar chart of trips by starting stations. Show the top 15 only

trips <- bike %>%
  group_by(start_station_name) %>%
  summarize(num_trips = n()) %>%
  top_n(15, num_trips) %>%
  arrange(desc(num_trips))
##Generates a tibble of the top 15 number of trips based on starting station name

bike %>%
  group_by(start_station_name) %>%
  summarize(num_trips = n()) %>%
  top_n(15, num_trips) %>%
  mutate(start_station_name = reorder(start_station_name, num_trips)) %>%
  ggplot(aes(start_station_name, num_trips)) +
  geom_bar(stat = "identity")
##Graphs the same data as above in a bar plot

##Are there any customers who have gone past their three day temporary pass? If so, who were the top 5 offenders and what was the overall average time over?

customers <- bike %>%
  transmute(subscriber_type, days = duration_sec / 86400) %>%
  filter(subscriber_type == "Customer", days > 3)
#duration_sec / 86400 converts seconds into days
#Creates a new tibble based on subscriber type and time; filters out to only customers and 
#time over 3 days

customers %>%
  top_n(5, days) %>%
  arrange(desc(days))
#Displays largest 5 values of days in descending order

time_over = customers$days - 3
#Calculate the amount of time past 3 day pass
mean(time_over)
#Average all time past 3 days

##How does the number of trips breakdown by time of day (use start hour) ? Generate bar plot.

bike %>%
  group_by(start_hour) %>%
  summarize(num_trips = n())
##Generates a tibble of the number of trips based on starting hours 0-23

bike %>%
  ggplot() +
  geom_bar(aes(start_hour))
options(scipen = 999)
##Graphs the same data as above in a bar plot

##How do the bikes with the most trips compare to the bikes with the longest total trip duration? Show one table that has all of the bikes that fall under top 10 trip count and/or duration.

bike_duration <- bike %>%
  group_by(bike_number) %>%
  summarize(tot_duration = sum(duration_sec)) %>%
  top_n(10, tot_duration) %>%
  arrange(desc(tot_duration))
#Creates a tibble of the total time spent on every bike (in seconds) based on the bike_number

bike_trips <- bike %>%
  group_by(bike_number) %>%
  summarize(num_trips = n()) %>%
  top_n(10, num_trips) %>%
  arrange(desc(num_trips))
#Creates a tibble of the total trips taken on every bike based on the bike_number

full_join(bike_duration, bike_trips)
#Shows the entire relationship between top 10 times and top 10 trips

##What is the most popular month by amount of trips?

library(lubridate)

bike %>%
  group_by(month = month(start_date, label = TRUE)) %>% #Groups every trip into each month
  summarize(month_trips = n()) %>%
  arrange(desc(month_trips))