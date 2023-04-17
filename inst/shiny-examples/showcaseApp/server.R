library(shiny)
library(rgl)
library(shinyjs)
library(shinythemes)
library(imager)


server <- function(input, output, session){
  
  
  output$test <- renderPrint(appData$userPhoto) #See file input
  
  
  #Data inputted from user
  appData <- reactiveValues(
    userPhoto = NULL
  )#end
  
  
  
  #Assign uploaded pic to reactive values
  observeEvent(input$userPic, { 
    appData$userPhoto <- input$userPic
  })#end
  
  
  
  
  #Shows button to clear uploaded file only if a file is present
  output$clearUserPic <- renderUI({ 
    if(!is.null(appData$userPhoto)){
      list(actionButton('clearPic', 'Clear uploaded image'),
           p(' '))
    }
  })#end
  
  
  
  
  #Reset file and data
  observeEvent(input$clearPic, { 
    reset('userPic')
    appData$userPhoto <- NULL
  })
  observeEvent(input$useDefault, { 
    reset('userPic')
    appData$userPhoto <- NULL
  })#end
  
  
  
  
  
  
  
  
} #end server



