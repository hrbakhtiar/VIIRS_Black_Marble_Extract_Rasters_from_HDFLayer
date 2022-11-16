# Bism Allah arrahman arrahim 
## *************************************************************************** ##
## *************************************************************************** ##
#
# 010-HDFLayers_to_Rasters.R
# Purpose of this R script is to convert HDF files from Black Marble to rasters
#
# Written by Hamidreza Bakhtiarizadeh 
# Last Modified in November 2022
#
## *************************************************************************** ##
## *************************************************************************** ##

library(raster)
library(rhdf5)
library(rgdal)
library(dplyr)
library(maps)

rm(list = ls())
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# manually define the working directory containing the Black Marble VNP46A1 files
setwd("../GIS/BlackMarble/RawData")

# List h5 files in the specified directory
files <- list.files(pattern = "\\.h5$")

blackmarble_h5_to_tif <- function(f){
  
  horizontal_tile <- as.numeric(f %>% substr(19,20))
  vertical_tile <- as.numeric(f %>% substr(22,23))
  
  myCrs <- 4261 #CRS should be selected based on the longidtude and latitude of the tile
  
  res <- 2400
  xMin <- (10 * horizontal_tile) - 180
  yMax <- 90 - (10 * vertical_tile)
  yMin <- yMax - 10
  xMax <- xMin + 10
  nRows <- 2400
  nCols <- 2400
  myNoDataValue <- NA
  
  band2Raster <- function(file, noDataValue, xMin, yMin, res, crs){
    # Select a layer in the h5 file to extract
    out <-
      h5read(
        file,
        "/HDFEOS/GRIDS/VIIRS_Grid_DNB_2d/Data Fields/NearNadir_Composite_Snow_Free",
        index = list(1:nCols, 1:nRows)
      )
    
    #transpose data to fix flipped row and column order 
    #depending upon how your data are formatted you might not have to perform this
    out <- t(out)
    
    #assign data ignore values to NA
    out[out == myNoDataValue] <- NA
    
    #turn the out object into a raster
    outr <- raster(out,crs=myCrs)
    
    #create extents class
    rasExt  <- raster::extent(c(xMin,xMax,yMin,yMax))
    
    #assign the extents to the raster
    extent(outr) <- rasExt
    
    #return the raster object
    return(outr)
  }
  
  r = band2Raster(file = f, noDataValue = myNoDataValue, xMin = xMin, yMin = yMin, res = res, crs = myCrs)
  # plot(r, breaks = 0.1*c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1))
  # plot(r)
  
  writeRaster(r, paste0("../Rasters/", gsub(".h5","",f), ".tif"))
}

# # apply the function
lapply(files, blackmarble_h5_to_tif)




