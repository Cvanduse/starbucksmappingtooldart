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

#To Clear working environment
rm(list=ls())
graphics.off()
#load packages
library(tidyverse)
library(stringr)
library(leaflet)
library(tibble)
library(htmltools)
library(htmlwidgets)
library(leaflet.extras)

#set working directory
setwd("/Users/christophervandusen/Desktop/")
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
mappingdata2 <- mappingdata %>%
  rename(FIRST = `FIRST NAME`,LAST= `LAST NAME`)

data1 <- mappingdata2 %>%
  select(`Street Combined`,`City`,`Country Subdivision`,`Postal Code`)
State <- joined %>%
  filter(State == "WA")

test <- leaflet() %>% addTiles() %>%
  addEasyButton(easyButton(
    icon="fa-globe", title="Zoom to Level 1",
    onClick=JS("function(btn, map){ map.setZoom(3); }"))) %>%
  addMarkers(State$longitude, State$latitude,
             popup = paste( "Name:", State$Name))

test

outline <- status[chull(State$longitude, State$latitude),]

map <- leaflet(status) %>%
  # Base groups
  addTiles(group = "OSM (default)") %>%
  # Overlay groups
  addCircles(data = State$Status, lng = ~long, lat = ~lat,
             fill = F, weight = 2, color = "#FFFFCC", group = "CLIENT") %>%
  addPolygons(data = State$Status, lng = ~long, lat = ~lat,
              fill = F, weight = 2, color = "#FFFFCC", group = "PROSPECT") %>%
  # Layers control
  addLayersControl(
    overlayGroups = c("CLIENT", "PROSPECT"),
    options = layersControlOptions(collapsed = FALSE)
  )
map