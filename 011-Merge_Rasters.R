# Bism Allah arrahman arrahim 
## *************************************************************************** ##
## *************************************************************************** ##
#
# 011-Merge_Rasters.R
# Purpose of this R script is to merges all blocks of each year into a single 
# raster
#
# Written by Hamidreza Bakhtiarizadeh 
# Last Modified in November 2022
#
## *************************************************************************** ##
## *************************************************************************** ##

library(gdalUtils)
library(raster)
library(rgdal)
library(dplyr)
library(maps)

rm(list = ls())
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# manually define the working directory containing the Black Marble VNP46A1 files
setwd("../GIS/BlackMarble/Rasters")

for(year in c(2012:2021)){
  # Define file names
  # Should be modified based on the raster file names
  files <- 
    list.files(pattern = paste0("^VNP46A4.A", year))
  
  # Read rasters
  rasters <- 
    lapply(files, raster)
  
  # Merge rasters
  merged_blocks <- 
    do.call(merge, c(rasters, tolerance = 1))
  
  # Save the output
  writeRaster(merged_blocks, 
              paste0("MergedBlocks/", 
                     "Merged_Blocks_",
                     year,
                     ".tif"))
}







