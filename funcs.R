source('Preload.R')
library(jsonlite)
library(yelpr)
library(tidyverse)
#/*



key <- 'fQduaB8yYyw8Fyvfbff93XLtN6a-sJ3fynkYGkVW4SBc74a9a6qShmlNoMELZxR6ASEJ_8NNYw2hybiCiJNozSOEKhtDNcK9ccrrHL1zidAFapQ56j5PqCxngMB_Y3Yx'

business_ny <- business_search(api_key = key,
                               location = 'New York',
                               term = "chinese",
                               limit = 5)

get_bus_data <- function(key,location, term, radius) {
  
  busdata = business_search(api_key = key,
                            location = location,
                            term = term,
                            #category = 'restaurant'
                            radius = radius*1609,
                            limit = 20,
                            locale = 'en_GB')
  
  #busdata = as_tibble(busdata$businesses)
  
  return(busdata)
  
}

bus_dat <- function(busdata){
  bd = as_tibble(busdata$businesses)
  
  
}


#bus_loc <- 

get_bus_data(key,"Canterbury","chinese",2)

as_tibble(jsonlite::fromJSON(jsonlite::toJSON(business_ny)))
