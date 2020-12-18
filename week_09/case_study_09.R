library(sf)
library(tidyverse)
library(spData)

#Use the API to Download storm data:
dataurl="https://www.ncei.noaa.gov/data/international-best-track-archive-for-climate-stewardship-ibtracs/v04r00/access/shapefile/IBTrACS.NA.list.v04r00.points.zip"
tdir=tempdir()
download.file(dataurl,destfile=file.path(tdir,"temp.zip"))
unzip(file.path(tdir,"temp.zip"),exdir = tdir)
list.files(tdir)
## [1] "IBTrACS.NA.list.v04r00.points.dbf" "IBTrACS.NA.list.v04r00.points.prj"
## [3] "IBTrACS.NA.list.v04r00.points.shp" "IBTrACS.NA.list.v04r00.points.shx"
## [5] "temp.zip"
storm_data <- read_sf(list.files(tdir,pattern=".shp",full.names = T))

#Wrangle the data:
#Filter to storms 1950 to present
storm_data <- storm_data %>%
  filter(SEASON >= 1950) %>%
  #Convert -999.0 to NA in all numeric columns
  mutate_if(is.numeric, function(x) ifelse(x==-999.0,NA,x)) %>%
  #Add a column for decade
  mutate(decade=(floor(year/10)*10))
#Identify the bounding box of the storm data and save as 'region'
region <- st_bbox(storm_data)

#Make the first plot:
#Load world polygon
data(world)
head(storm_data)
#Plot the world polygon layer
ggplot()+
  geom_sf(data=world) +
  geom_point(data=storm_data, aes(LON, LAT)) +
  #Create a panel for each decade
  facet_wrap(~decade) + 
  stat_bin2d(data=storm_data, aes(y=st_coordinates(storm_data)[,2],
                                  x=st_coordinates(storm_data)[,1]),bins=100) +
  #Set the color ramp
  scale_fill_distiller(palette="YlOrRd", trans="log", direction=-1, breaks = c(1,10,100,1000)) +
  #Crop the plot to the region.
  coord_sf(ylim=region[c(2,4)], xlim=region[c(1,3)])

#Calculate table of the five states with most storms
#Reproject us_states to the reference system of the storms object
us_transform = st_transform(us_states, crs = st_crs(storm_data))
#Rename the NAME column in the state data to state to avoid confusion with storm name
state_rename = us_transform %>% select(state = NAME)
#Perform a spatial join between the storm database and the states object
storm_states <- st_join(storm_data, state_rename, join = st_intersects, left = F)
#Group the next step by US state
most_five_states = storm_states %>% group_by(state) %>% 
  #Count how many unique storms occurred in each state
  summarize(storms=length(unique(NAME))) %>%
  #Sort by the number of storms in each state
  arrange(desc(storms)) %>%
  #Keep only the top 5 states 
  slice(1:5)
View(most_five_states)

#Remove unecessary geometry column, as per Bowei, Collin, and Marko
most_five_states <- st_drop_geometry(most_five_states)
View(most_five_states)