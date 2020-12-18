library(spData)
library(sf)
library(tidyverse)
library(units)

#load 'world' data from spData package
data(world)

# load 'states' boundaries from spData package
data(us_states)

#filter the world dataset to include only name_long=="Canada"
Canada <- world %>% filter(name_long == "Canada")

#transform to the albers equal area projection
albers="+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +
ellps=GRS80 +datum=NAD83 +units=m +no_defs"
Canada_transform <- st_transform(Canada, albers)

#buffer canada to 10km (10000m)
world_buffer = st_buffer(Canada_transform, dist=10000)

plot(Canada_transform)

plot(world_buffer)

head(us_states)

#filter the us_states dataset to include only NAME == "New York"
NY_state <- us_states %>% filter(NAME == "New York")

#transform to the albers equal area projection
NY_transform <- st_transform(NY_state, albers)

#use st_intersection() to intersect the canada buffer with New York (this will be your final polygon)
intersection <- st_intersection(world_buffer, NY_transform)
plot(intersection)
final_polygon <- (intersection)

#use st_area() to calculate the area of this polygon
area <- st_area(final_polygon)

#Convert the units to km^2. You can use set_units(km^2) (from the units library) or some other method
area_km <- set_units(area, km^2)
print(area_km)

#Plot the border area using ggplot() and geom_sf()
ggplot(final_polygon) + geom_sf(data = NY_transform)+geom_sf(data = intersection, fill = "red")

#Collin suggested using tmap
library(tmap)
tm_layout(main.title = "New York Land within 10km") + tm_shape(NY_transform) + tm_graticules() + tm_fill(col = "gray") + tm_shape(final_polygon) + tm_fill(col = "red") + tm_polygons()