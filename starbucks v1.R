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

# Not sue if this is necessary
State1 <- State %>% group_by(Client)

test <- leaflet() %>% addTiles() %>%
  addEasyButton(easyButton(
    icon="fa-globe", title="Zoom to Level 1",
    onClick=JS("function(btn, map){ map.setZoom(3); }"))) %>%
  addMarkers(State$longitude, State$latitude,
             popup = paste( "Name:", State$Name),
             popup = )

test


# Colored label -----------------------------------------------------------
leafIcons <- icons(
  iconUrl = ifelse(State1$Client == "PROSPECT",
                   "http://leafletjs.com/examples/custom-icons/leaf-green.png",
                   "http://leafletjs.com/examples/custom-icons/leaf-red.png"
  ),
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)

leaflet(State1) %>% addTiles() %>%
  addMarkers(
    State1$longitude, State1$latitude,
    icon = ~leafIcons
  )

