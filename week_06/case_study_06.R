library(raster)
library(sp)
library(spData)
library(tidyverse)
library(sf)
data(world)  #load 'world' data from spData package
tmax_monthly <- getData(name = "worldclim", var="tmax", res=10)
#Set the appropriate gain() to convert to Degrees C
gain(tmax_monthly)=.1
#Remove “Antarctica”
countries_world <- world %>% filter(continent != "Antarctica")
#Convert the world object to sp format
object_countries<-as(countries_world,"Spatial")
plot(tmax_monthly)
#Create a new object that is the annual maximum temperature in each pixel of the raster stack 
tmax_annual <- max(tmax_monthly)
plot(tmax_annual)
#change the name of the layer in the new object
names(tmax_annual) <- "tmax"
# identify the maximum temperature
tmax_country=raster::extract(tmax_annual,countries_world,fun=max,na.rm=TRUE,small=TRUE,sp=TRUE)
#convert the results of the previous step to sf format
tmax_country_sf=st_as_sf(tmax_country)
#plot the maximum temperature in each country polygon
tmax_percountry_map <- ggplot(tmax_country_sf)+
  geom_sf(aes(fill=tmax))+
  scale_fill_viridis_c(name="Annual Maximum\nTemperature °C")+
  theme(legend.position='bottom',legend.title=element_text(size=16,color='orange'))
plot(tmax_percountry_map)
#use dplyr tools to find the hottest country in each continent
tmax_table<-as.data.frame(tmax_country_sf%>%
                            group_by(continent)%>%
                            top_n(1,tmax))
keep<-c("name_long","continent","tmax")
tmax_final_table<-tmax_table[,(names(tmax_table)%in%keep)]%>%
  arrange(desc(tmax)) %>% st_set_geometry(NULL)

print(tmax_final_table)
