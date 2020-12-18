library(tidyverse)

# define the link to the data - you can try this in your browser too.  Note that the URL ends in .csv.
dataurl="https://data.giss.nasa.gov/tmp/gistemp/STATIONS/tmp_USW00014733_14_0_1/station.csv"


temp=read_csv(dataurl,
              skip=1, #skip the first line which has column names
              na="999.90", # tell R that 999.90 means missing in this dataset
              col_names = c("YEAR","JAN","FEB","MAR", # define column names 
                            "APR","MAY","JUN","JUL",  
                            "AUG","SEP","OCT","NOV",  
                            "DEC","DJF","MAM","JJA",  
                            "SON","metANN"))
# renaming is necessary because they used dashes ("-") in the column names and R doesn't like that.
View(temp)
summary(temp)
str(temp)
#Graph the annual mean temperature in June, July and August (JJA) using ggplot
meantempplot <- ggplot(temp, aes(YEAR, JJA))+
  xlab("Year") + ylab(expression(paste("Mean Summer Temperatures (", ~degree, "C)", sep = "")))+
  ggitle("Mean Summer Temperatures in Buffalo, NY") + 
  labs(subtitle = "Summer includes June, July, and August 
       Data from the Global Historical Climate Network
       Red line is a LOESS smooth") + 
  geom_line() +
  geom_smooth(color = "red")
plot(meantempplot)
