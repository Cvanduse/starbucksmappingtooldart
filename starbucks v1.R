#To Clear working environment
rm(list=ls())
graphics.off()

#load packages
library(tidyverse)
library(stringr)
library(leaflet)


#set working directory
setwd("C:/Users/cvandusen/desktop")
setwd("~/Library/Mobile\ Documents/com~apple~CloudDocs/R/Chris/starbucksmappingtooldart")
getwd()

#name csv file as my data
zip <- "zip.csv"
mapdata <- "map.csv"

#read csv and name it data
zipcodes <- read_csv(zip)
mappingdata <- read_csv(mapdata)

#Trim postal code to 5 digits
mappingdata$`Postal Code` <- mappingdata$`Postal Code` %>%
  str_sub(end=5)

mappingdata1 <- mappingdata %>%
  rename(zip_code = `Postal Code`,State = `Country Subdivision`)


joined <- left_join(zipcodes,mappingdata1, by="zip_code")

State <- joined %>%
  filter(State == "MI"|State == "CA"| State == "TX")

test <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(State$longitude, State$latitude,
              popup = paste( "Name:", State$Name, "<br>",
              "Client:", State$Client, "<br>"))

test

#Demo of leaflet
m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
m  # Print the map