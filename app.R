#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

source('funcs.R')
library(shiny)
library(shinythemes)
library(shinydashboard)


# Define UI for application that draws a histogram
ui <- navbarPage(theme = shinytheme('flatly'),
                 tags$head(tags$style(".rightAlign{text-align:right;}")),
                 
                 # Application title
                 title = 'findR',
                 # titlePanel("Old Faithful Geyser Data"),
                 
                 # Sidebar with a slider input for number of bins 
                 sidebarLayout(
                   sidebarPanel(
                 
                     textInput("loc","Search location"),
                     textInput("trm", "Search for businesses:"),
                     sliderInput("searchradius",
                                 "Search Radius (miles):",
                                 min = 1,
                                 max = 20,
                                 value = 5),
                     br(),
                     actionButton("act","Search", class = 'btn-primary btn-lg rightAlign'),
                     br(),
                     #box(title="Additional Options", collapsible=T, status = 'primary', solidHeader=T, width = 12,
                     radioButtons("Rate",
                                  "Minimum Rating:",
                                  choiceNames = list(div(icon("star")),
                                                     div(icon("star"),icon("star")),
                                                     div(icon("star"),icon("star"),icon("star")),
                                                     div(icon("star"),icon("star"),icon("star"),icon("star")),
                                                     div(icon("star"),icon("star"),icon("star"),icon("star"),icon("star"))
                                  ),
                                  choiceValues = list(1,2,3,4,5)
                                  
                                  
                     #)
                     )

                   ),
                   
                   # Show a plot of the generated distribution
                   mainPanel(
                     h3(textOutput("txt")),
                     #plotOutput("distPlot"),
                     #uiOutput("ui_rend"),
                     leafletOutput("map")#,
                     #tableOutput("tb")
                   )
                 )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  
  vals <- reactiveValues(a=NULL)
  
  observeEvent(input$act,{
    
    #vals$c <- business_ny
    #vals$b <- input$searchradius
    vals$a <- get_bus_data(key, location = input$loc, term = input$trm, radius = input$searchradius)
    
  })
  
  output$tb <- renderTable({
    as_tibble(vals$a$businesses)
  })
  
  
  # output$ui_rend({
  #     if(input$act == 0) {
  #         renderText({
  #             h2("Where would you like to search?")
  #         })
  #     }
  #     else renderLeaflet({
  #         
  #         lat = vals$a$region$center$latitude
  #         long = vals$a$region$center$longitude
  #         dps = as_tibble(vals$a$businesses) %>% unnest(cols=coordinates) %>% 
  #             filter(rating>=input$Rate)
  #         
  #         leaflet(dps) %>% addTiles() %>% setView(long, lat, zoom = 12) %>% 
  #             addMarkers(~longitude, ~latitude, popup = ~name)
  #         
  #     })
  
  
  
  # })
  
  output$txt <- renderText({
    if(input$act!=0) {
      paste0("Showing results for ",input$trm," in ",input$loc)
    } else{
    "Where would you like to search today??"}
    
  })
  
  
  
  output$map <- renderLeaflet({
    
    if(input$act==0) {
      return(NULL)
    }
    
    lat = vals$a$region$center$latitude
    long = vals$a$region$center$longitude
    dps = as_tibble(vals$a$businesses) %>% unnest(cols=coordinates) %>% 
      filter(rating>=input$Rate)
    
    leaflet(dps) %>% addTiles() %>% setView(long, lat, zoom = 12) %>% 
      addMarkers(~longitude, ~latitude, popup = paste(dps$name
                                                      , "<br>"
                                                      ,"Rating: "
                                                      ,dps$rating
                                                      , "<br>"
                                                      ,"Price: "
                                                      ,dps$price
                                                      , "<br>"
                                                      ,"Phone: "
                                                      ,dps$phone))
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
