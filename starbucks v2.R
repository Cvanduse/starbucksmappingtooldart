#To Clear working environment
rm(list=ls())
graphics.off()

#load packages
library(tidyverse)
library(stringr)
library(leaflet)
library(htmltools)
library(htmlwidgets)


#set working directory
setwd("C:/Users/cvandusen/desktop")
getwd()

#name csv file as my data
zip <- "zip.csv"
mapdata <- "map.csv"

#read csv and name it data
zipcodes <- read_csv(zip)
mappingdata <- read_csv(mapdata)

#Trim postal code to 5 digits
mappingdata['Postal Code'] <- mappingdata['Postal Code'] %>%
  str_sub(end=5)

mappingdata1 <- mappingdata %>%
  rename(zip_code = `Postal Code`,State = `Country Subdivision`)


joined <- left_join(zipcodes,mappingdata1, by="zip_code")

State <- joined %>%
  filter(State == "CA")

test <- leaflet() %>% 
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addEasyButton(easyButton(
    icon="fa-globe", title="Zoom to Level 1",
    onClick=JS("function(btn, map){ map.setZoom(1); }"))) %>%
  addMarkers(State (longitude, latitude),
             popup = paste( "Name:", State[Name],"Status:", State[Client], "Contact", State[`FIRST NAME`],"Contact", State[`LAST NAME`],
                            "Title:", State[TITLE] , "Address:" , State[`Street Combined`]),  clusterOptions = markerClusterOptions())

test