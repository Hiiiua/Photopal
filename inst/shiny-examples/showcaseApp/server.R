library(shinythemes)
library(shiny)
library(imager)
library(shinycssloaders)

server <- function(input, output, session){
  
  #Data inputted from user
  appData <- reactiveValues(
    userPhoto = NULL,
    userPhotoLoc = NULL,
    defaultPhoto = stadium,
    palPhoto = NULL,
    pal = NULL,
    cb.pal = NULL
  )#end
  
  #Observe new file upload from user
  observeEvent(input$userPic, {
    appData$userPhoto <- input$userPic
    validate(need(!is.null(appData$userPhoto), 'Photo needs to be uploaded'))
    appData$userPhotoLoc = appData$userPhoto[['datapath']]
    appData$palPhoto <- load.image(appData$userPhoto[['datapath']])
    appData$pal <- palette_create(input$numcols, image2rgb(appData$userPhoto[['datapath']]),
                                  threshold = 0, plot = F)
  })
  
  #Observe default button pushed
  observeEvent(input$useDefault, {
    appData$palPhoto <- appData$defaultPhoto
    appData$userPhotoLoc = 'stadium.rda'
    appData$pal <- palette_create(input$numcols, image2rgb(), threshold = 0, plot = F)
  })
  
  #Update number of colors
  observeEvent(input$update, {
    validate(need(!is.null(appData$palPhoto), ' '))
    appData$pal <- palette_create(input$numcols, image2rgb(), threshold = 0, plot = F)
  })
  
  
  #Plot palette colors
  output$palettePlot <- renderPlot({
    validate(need(!is.null(appData$pal), ' '))
    barplot(sort(table(appData$pal[,'palColors'])), col = sort(appData$pal[,'palColors']), axes = F,
            xaxt="n", yaxt="n")
  })
  
  #Plot palette color names
  output$palette <- renderTable({
    validate(need(!is.null(appData$pal), ' '))
    pal = data.frame(appData$pal[,'palColors'])
    names(pal) <- c('Palette Colors')
    pal
  })
  
  #Plot photo
  output$photo <- renderPlot({
    validate(need(!is.null(appData$palPhoto), ' '))
    plot(appData$palPhoto, axes = F)
  })
  
  
  
  
  
  
  
  
  
  #Colorblind photo comparison
  output$cb.photo <- renderPlot({
    validate(need(!is.null(appData$palPhoto), ' '))
    
    if(input$cb.mode == 'Red'){
      color_blindness_simulation(loc = appData$userPhotoLoc,
                                 mode = 'red')
    }
    
    if(input$cb.mode == 'Green'){
      color_blindness_simulation(loc = appData$userPhotoLoc,
                                 mode = 'green')
    }
    
    if(input$cb.mode == 'Blue'){
      color_blindness_simulation(loc = appData$userPhotoLoc,
                                 mode = 'blue')
    }
    
  })
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  output$cb.palette <- renderPlot({
    if(input$cb.mode == 'Red'){
      appData$cb.pal <- color_blindness_palette(loc = appData$userPhotoLoc,
                                                mode = 'red', plot_images = F, plot_palette = F,
                                                threshold = 0, num.color = input$numcols)
    }
    
    if(input$cb.mode == 'Green'){
      appData$cb.pal <- color_blindness_palette(loc = appData$userPhotoLoc,
                                                mode = 'green', plot_images = F, plot_palette = F,
                                                threshold = 0, num.color = input$numcols)
    }
    
    if(input$cb.mode == 'Blue'){
      appData$cb.pal <- color_blindness_palette(loc = appData$userPhotoLoc,
                                                mode = 'blue', plot_images = F, plot_palette = F,
                                                threshold = 0, num.color = input$numcols)
    }
    
    validate(need(!is.null(appData$cb.pal), 'Error message here'))
    barplot(sort(table(appData$cb.pal[,'palColors'])), col = sort(appData$cb.pal[,'palColors']), axes = F,
            xaxt="n", yaxt="n")
    
    
  })
  
  
  
  output$cb.palTable <- renderTable({
    
    validate(need(!is.null(appData$cb.pal), ' '))
    cb.pal = data.frame(appData$cb.pal[,'palColors'])
    names(cb.pal) <- c('Palette Colors')
    cb.pal
  })
  
  
  # fluidRow(
  #   plotOutput('cb.photo')
  # ),
  # fluidRow(
  #   column(8, align = 'center',
  #          plotOutput('cb.palette')),
  #   column(4, align = 'center',
  #          tableOutput('cb.palTable'))
  # )
  
  
  
  
  
  
}