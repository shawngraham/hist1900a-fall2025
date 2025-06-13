#GIS
# https://benmarwick.github.io/How-To-Do-Archaeological-Science-Using-R/using-r-as-a-gis-working-with-raster-and-vector-data.html

require(rgdal) # this one is already installed
require(curl)

# install the following packages by clicking on the packages tab, bottom right panel, then the
# 'install' button. Type the name in. Don't ask me why, it just works better that way than if
# you write the command out yourself. Be patient....it'll take a few minutes.

require(raster)
require(rasterVis)
require(lattice)

# load data
#   Import data - first a 30m DEM from NASA SRTM data
# (http://doi.org/10.5067/MEaSUREs/SRTM/SRTMGL1N.003) in geotiff format
# (though raster() will read any format that rgdal::readGDAL() recognizes),
# and then a point shapefile (a standard ESRI .shp, though rgdal::readOGR() can
# import many other sorts of spatial data also).

# we tell RStudio the url for the file we want
x <- "https://raw.githubusercontent.com/benmarwick/How-To-Do-Archaeological-Science-Using-R/master/05_Contreras/demo_files/areaDEM.tif"

# we load the file into this environment
download.file(x,destfile="areaDEM.tif",method="curl")

# and now we load it as a raster into R
areaDEM <- raster("areaDEM.tif")  # read raster

# It will be easier to work with projected data, so we'll project this to
# UTM using the appropriate proj4 string (http://proj4.org/index.html) for
# the CRS (Coordinate Reference System) that we want.

areaDEMutm <- projectRaster(areaDEM,
                            crs="+proj=utm +zone=31 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
# Have a quick look at this to make sure nothing has gone terribly wrong - with
# the raster package loaded typing the name of a raster object will give you summary
# data about that object.
areaDEMutm

# load sites
ap1 <- "https://raw.githubusercontent.com/benmarwick/How-To-Do-Archaeological-Science-Using-R/master/05_Contreras/demo_files/areaPoints.shp"
ap2 <- "https://raw.githubusercontent.com/benmarwick/How-To-Do-Archaeological-Science-Using-R/master/05_Contreras/demo_files/areaPoints.dbf"
ap3 <- "https://raw.githubusercontent.com/benmarwick/How-To-Do-Archaeological-Science-Using-R/master/05_Contreras/demo_files/areaPoints.prj"
ap4 <- "https://raw.githubusercontent.com/benmarwick/How-To-Do-Archaeological-Science-Using-R/master/05_Contreras/demo_files/areaPoints.shx"


# we load the file into this environment
# (there's probably a more elegant way to do this, but it works)
download.file(ap1,destfile="areaPoints.shp",method="curl")
download.file(ap2,destfile="areaPoints.dbf",method="curl")
download.file(ap3,destfile="areaPoints.prj",method="curl")
download.file(ap4,destfile="areaPoints.shx",method="curl")

sites <- readOGR(dsn="~", layer="areaPoints") # read .shp ; the ~ means 'home directory'
# (note that to read a shapefile, "the data source name (dsn= argument)
# is the folder (directory) where the shapefile is, and the layer is the
# name of the shapefile (without the .shp extension)" (from the rgdal::readOGR documentation))

sites_sub <- sites[sites$period == "EIA" | sites$period == "GalRom",]
# subset points to eliminate sites of uncertain date - i.e., select from 'sites'
# only those rows in which the 'period' column is "EIA" or "GalRom".

sites_sub$period <- factor(sites_sub$period)
# drop unused levels (not strictly necessary but will avoid messiness when plotting data later)

sites_sub_utm <- spTransform(sites_sub,
                             "+proj=utm +zone=31 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
# project points to UTM

sites_sub_utm
# Check the file (note that it is now a Spatial Points Data Frame, and typing its name will give you an object summary).
# Note that there is a 'type' field that we won't work with here, but which could be incorporated into this kind of
# analysis, e.g., by sub-setting or by grouping data when boxplotting.

# Working with the DEM to derive other measures

# commands: raster::terrain()

area_slope <- terrain(areaDEMutm, opt = 'slope', unit = 'degrees')
#calculate slope

area_aspect <- terrain(areaDEMutm, opt = 'aspect', unit = 'degrees')
#calculate aspect

#Have a quick look at these to see that the results make sense - they are now raster objects
# just like areaDEM and can be examined the same way.
area_slope
area_aspect

# let's visualize our data now
# commands: rasterVis::levelplot(), it's also a function in the lattice pkg,
# so let's specify the namespace just to be sure we are using the right function
# (eg, you don't want to get your commands confused, so )
rasterVis::levelplot(areaDEMutm,
                     margin = list(x = FALSE,
                                   y = TRUE),
                     col.regions = terrain.colors(16),
                     xlab = list(label = "",
                                 vjust = -0.25),
                     sub = list(
                       label = "masl",
                       font = 1,
                       cex = .9,
                       hjust = 1.5))

# make sure our sites fit on our terrain; this also lets you start formulating some ideas about the data
# commands: sp::spplot()
rasterVis::levelplot(areaDEMutm,
                     margin = list(x = F,
                                   y = T),
                     col.regions = terrain.colors(16),
                     xlab = list (label = "",
                                  vjust = -.25),
                     sub = list(
                       label = "masl",
                       font = 1,
                       cex = .9,
                       hjust = 1.5),
                     key = list(       #this time we'll include a legend that identifies the points we'll plot
                       space = "top",
                       points = list(
                         pch = c(18,20),
                         col = c("red","blue")),
                       text = list(
                         c("EIA","GalRom"),
                         cex=.8))
) +
  spplot(sites_sub_utm, # add a layer of points
         zcol = "period",
         cex = .6,
         pch = c(18,20),
         col.regions = c("red","blue")
  )

# ok, so let's get analytical. Raster stacks!
# commands: raster::stack()
terrainstack <- stack(areaDEMutm,
                      area_slope,
                      area_aspect)

terrainstack # have a quick look at resulting object, which shows the number of layers and the min/max values we expect

# extract some values
# commands: raster::extract()
sites_vals <- extract(terrainstack,
                      sites_sub_utm,
                      buffer = 250,
                      fun = mean,
                      sp = TRUE) # extract the mean values w/in a 250m radius around each site for each terrain variable

# commands: summary(), lattice::bwplot()

summary(sites_vals$period)
#check the sample size for each period (I've done this and manually incorporated it in the boxplot labels)

elevplot <- bwplot(areaDEM ~ period,   # Here we're writing the boxplot to an object for later use (if you just want to display it, simply run the code without writing to an object)
                   data = data.frame(sites_vals),
                   notch = TRUE,
                   pch = "|",
                   fill = "grey",
                   box.ratio = 0.25,
                   par.settings = list(
                     box.rectangle = list(
                       col = c("red","blue"))),  #to maintain a visual link to our map, we'll plot the box outlines with the same color scheme
                   ylab = "masl",
                   main="Elevation",
                   scales = list(x = list(labels = c("Early Iron Age\n(n = 94)",
                                                     "Gallo-Roman\n(n = 491)")),
                                 rot=60))
elevplot  #examine the result to make sure everything is in order

#repeat for slope
slopeplot <- bwplot(slope ~ period,
                    data = data.frame(sites_vals),
                    notch = TRUE,
                    pch = "|",
                    fill = "grey",
                    box.ratio = 0.25,
                    par.settings = list(
                      box.rectangle = list(
                        col = c("red","blue"))),
                    ylab = "slope (degrees)",
                    main = "Slope",
                    scales = list(x = list(labels = c("Early Iron Age\n(n = 94)",
                                                      "Gallo-Roman\n(n = 491)")),
                                  rot = 60))
# view the plot
slopeplot

#and then aspect
aspectplot <- bwplot(aspect ~ period,
                     data = data.frame(sites_vals),
                     notch = TRUE,
                     pch = "|",
                     fill = "grey",
                     box.ratio = 0.25,
                     par.settings = list(
                       box.rectangle = list(
                         col = c("red","blue"))),
                     ylab = "aspect (degrees)",
                     main = "Aspect",
                     scales = list(x = list(labels = c("Early Iron Age\n(n = 94)",
                                                       "Gallo-Roman\n(n = 491)")),
                                   rot=60))
# view the plot
aspectplot

# a bonus plotting problem: putting all three of these in one plot
#commands: gridExtra::grid.arrange
require(gridExtra)
grid.arrange(elevplot,
             slopeplot,
             aspectplot,
             nrow = 1,
             ncol = 3)
