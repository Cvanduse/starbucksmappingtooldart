#To Clear working environment
rm(list=ls())
graphics.off()

#load packages
library(tidyverse)
library(stringr)
library(leaflet)


#set working directory
setwd("C:/Users/cvandusen/desktop")
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
  filter(State == "AL"|State == "AK"| State == "AZ" | State == "AR"|State == "CA"| State == "CO" |State == "CT"| State == "DE" | State == "FL"|State == "GA"| State == "HI" | State == "ID"|State == "IL"| State == "IN" |State == "IA"| State == "KS" | State == "KY"|State == "LA"| State == "ME"| State == "MD" | State == "MA"|State == "MI"| State == "MN" |State == "MS"| State == "MO" | State == "MT"|State == "NE"| State == "NV" | State == "NH"|State == "NJ"| State == "NM" |State == "NY"| State == "NC" | State == "KY"|State == "ND"| State == "OH"|State == "OK"| State == "OR" | State == "PA"|State == "RI"| State == "SC" | State == "SD"|State == "TN"| State == "TX" |State == "UT"| State == "VT" | State == "VA"|State == "WA"| State == "WV"| State == "WI" | State == "WY")
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
                   "C:/Users/cvandusen/desktop/dartblack.png",
                   "C:/Users/cvandusen/desktop/dartred.png"
  ),
  iconWidth = 15, iconHeight = 15,
  iconAnchorX = 22, iconAnchorY = 40,
  shadowUrl = "",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)

leaflet(State1) %>% addTiles() %>%
  addEasyButton(easyButton(
    icon="fa-globe", title="Zoom to Level 1",
    onClick=JS("function(btn, map){ map.setZoom(4); }"))) %>%
  addMarkers(
    State1$longitude, State1$latitude,
    icon = ~leafIcons,
    label = paste( "Name:", State$Name,"Phone:" , State$Phone),
    popup = paste( "Name:", State$Name,"HDMA:" , State$HMDA, "Contact:", paste(State$`FIRST NAME`,State$`LAST NAME`) , "Title:", State$TITLE , "Address:" , paste(State$`Street Combined`,State$city, State$State, State$zip_code),"Phone:" , State$Phone),
    clusterOptions = markerClusterOptions())

