# download terraClimate (https://www.climatologylab.org/terraclimate.html) data
# for a specific lat/lon location using climateR package
# MAC 08/21/21

# load library
library(climateR)
library(sf)

# get catalog and place in dataframe
catalog<-catalog
# sort by id to find terraclim to find var names if necessary

# set latitude/longitude of point of interest
lat<-32
lon<--110

# get terraClimate point time series
pt<-cbind.data.frame("x",lat,lon) # create dataframe
colnames(pt)<-c("loc","lat","lon") # specify column names
pt<- st_as_sf(pt, coords = c("lon","lat")) # create sf point object
pt<-st_set_crs(pt, 4269) # set coord ref system 

# get climate 
ppt<-getTerraClim(AOI=pt,
                  varname = "ppt",
                  startDate = "1958-01-01",
                  endDate =  "2023-12-01",
                  verbose = TRUE)

tmin<-getTerraClim(AOI=pt,
                  varname = "tmin",
                  startDate = "1958-01-01",
                  endDate =  "2023-12-01",
                  verbose = TRUE)

tmax<-getTerraClim(AOI=pt,
                  varname = "tmax",
                  startDate = "1958-01-01",
                  endDate =  "2023-12-01",
                  verbose = TRUE)

# combine into single dataframe
climateData<-cbind.data.frame(ppt,tmin$tmin_total,tmax$tmax_total)
colnames(climateData)[2:4]<-c("precip_mm","tmin_C","tmax_C")
climateData$tmean_C<-(climateData$tmax_C+climateData$tmin_C)/2

# write to csv datafile
write.csv(climateData, file="terraClimate_data.csv", row.names = FALSE)


