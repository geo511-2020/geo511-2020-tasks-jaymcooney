install.packages("camtrapR")
require(camtrapR)
# load sample camera trap station table
data(camtraps)

# load sample record table
data(recordTableSample)

# familiarize with camtrap layout
# (utm = Universal Transverse Mercator coordinate system)
View(camtraps)

# familiarize with sample table layout / how data is organized, tidied for plotting
# (PBE = Leopard cat, VTA = Malay civet, MNE = Pig-tailed macaque, EGY = Moonrat, TRA = Mouse-deer)
View(recordTableSample)

#Example of plotting spatial data
# Species richness plot (note example used low number of data from camera traps)
Mapstest1 <- detectionMaps(CTtable     = camtraps,
                           recordTable  = recordTableSample,
                           Xcol         = "utm_x",
                           Ycol         = "utm_y",
                           stationCol   = "Station",
                           speciesCol   = "Species",
                           printLabels  = TRUE,
                           richnessPlot = TRUE,    # by setting this argument TRUE
                           speciesPlots = FALSE,
                           addLegend    = TRUE)

# Number of records by species (in this example a single species, PBE = Leopard cat, Prionailurus bengalensis)
recordTableSample_PBE <- recordTableSample[recordTableSample$Species == "PBE",]
Mapstest2 <- detectionMaps(CTtable      = camtraps,
                           recordTable   = recordTableSample_PBE,
                           Xcol          = "utm_x",
                           Ycol          = "utm_y",
                           stationCol    = "Station",
                           speciesCol    = "Species",
                           speciesToShow = "PBE",     # added
                           printLabels   = TRUE,
                           richnessPlot  = FALSE,     # changed
                           speciesPlots  = TRUE,      # changed
                           addLegend     = TRUE)


# My interests are in behavioral ecology, so let's finish with looking at some activity plots
# define species of interest
speciesA_for_activity <- "VTA"    # = Viverra tangalunga, Malay Civet
speciesB_for_activity <- "PBE"    # = Prionailurus bengalensis, Leopard Cat

# create activity overlap plot
activityOverlap (recordTable = recordTableSample,
                 speciesA    = speciesA_for_activity,
                 speciesB    = speciesB_for_activity,
                 writePNG    = FALSE,
                 plotR       = TRUE,
                 add.rug     = TRUE)
# aesthetically-pleasing activity overlap plot
activityOverlap (recordTable = recordTableSample,
                 speciesA    = speciesA_for_activity,
                 speciesB    = speciesB_for_activity,
                 writePNG    = FALSE,
                 plotR       = TRUE,
                 createDir   = FALSE,
                 pngMaxPix   = 1000,
                 linecol     = c("black", "blue"),
                 linewidth   = c(5,3),
                 linetype    = c(1, 2),
                 olapcol     = "darkgrey",
                 add.rug     = TRUE,
                 extend      = "lightgrey",
                 ylim        = c(0, 0.25),
                 main        = paste("Activity overlap: ", speciesA_for_activity, "-", speciesB_for_activity))
