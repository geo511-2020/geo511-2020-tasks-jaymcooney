library(ggplot2)
library(gapminder)
library(dplyr)
#Use filter() to remove “Kuwait” from the gapminder dataset for reasons noted in the background
gapminderfilter <- gapminder%>%
  dplyr::filter(!country == "Kuwait")
#Plot #1 (the first row of plots)
ggplot(gapminderfilter, aes(x = lifeExp, y = gdpPercap)) +
  #adjust the size of the point with size=pop/100000
  geom_point(aes(size=pop/100000, color=continent)) +
  #get the correct scale on the y-axis
  scale_y_continuous(trans = 'sqrt') + 
  #divide the plot into separate panels
  facet_wrap(~year,nrow=1) + 
  #specify more informative x, y, size, and color keys
  xlab("Life Expectancy") + ylab("GDP per capita") +
  scale_size_continuous("Population (100k)") +
  scale_color_discrete("Continent") +
  theme_bw()
ggsave("casestudy03plot1.png", width = 15, units = 'in')
#Prepare the data for the second plot
gapminder_continent <- gapminderfilter%>%
  #group by continent and year
  group_by(continent, year)%>%
  #calculate the data for the black continent average line on the second plot
    summarize(gdpPercapweighted = weighted.mean(x = gdpPercap, w = pop),
              pop = sum(as.numeric(pop)))
#Plot 2 (the second row of plots)
ggplot(gapminderfilter, aes(x = year, y = gdpPercap, color = continent, group = country, fill = continent, size = pop/100000)) +
    geom_line() +
    geom_point() +
  #inhereit.aes as per Collin's recommendation
    geom_line(data = gapminder_continent, aes(x = year, y = gdpPercapweighted, color = "black", inherit.aes = FALSE)) +
    geom_point(data = gapminder_continent, aes(x = year, y = gdpPercapweighted, size = pop/100000, color = "black", inherit.aes = FALSE)) +
    facet_wrap(~continent,nrow=1) +
    scale_size_continuous("Population (100k)") +
    scale_color_discrete("Continent") +
    xlab("Year") +
    ylab("GDP per capita") +
    labs(x = "Year", y = "GDP per capita", size = "Population (100k)", color = "Continent") +
    theme_bw()
ggsave("casestudy03plot2.png", width=15, units='in')