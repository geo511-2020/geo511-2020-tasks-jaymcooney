install.packages("nycflights13")
library(tidyverse)
library(dplyr)
library(nycflights13)

View(flights)
View(airports)

airports <- nycflights13::airports

#Amendments reached working with groupmates Bowei, Collin, and Marko
flights <- nycflights13::flights %>% filter(origin =="JFK"|origin == "EWR" |origin == "LGA")
ordered_distance <- arrange(flights, desc(distance))
farthest_airport <- ordered_distance[1,c(13,14,16)]
print(farthest_airport)
names(airports)[1] = "dest"
farthest_fullname = farthest_airport %>% left_join(airports, by = "dest") %>% select(name)
print(farthest_fullname)