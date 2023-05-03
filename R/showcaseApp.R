#' Shiny app calling function
#'
#' @author Tyler Wiederich
#' @import shinythemes
#' @import shiny
#' @import imager
#' @importFrom shinycssloaders withSpinner
#' @export
#' @examples
#' showcaseApp()
#' 
#' 


showcaseApp <- function(){
  appDir <- system.file("shiny-examples", "showcaseApp", package = "Photopal")
  if (appDir == ""){
    stop(paste0("Could not find the directory. ",
                "Try re-install `Photopal`,"), call. = F)
  }
  shiny::runApp(appDir, display.mode = "normal")
} 







showcaseApp <- function(){
# UI ----------------------------------------------------------------------


  #Color palette page
  createPalettePage <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        h2('Instructions'),
        p("Welcome to the Photopal showcase app! To get started, either upload an image with a valid extension (.png or .jpeg) or use our app's default image."),
        fileInput('userPic', 'Upload file',
                  accept = c('.png', '.jpeg')),
        actionButton('useDefault', 'Use default image'),
        h2(' '),
        numericInput('numcols', 'How many colors for palette?', value = 5, min = 1, step = 1),
        actionButton('update', 'Update number of colors')

      ), #end sidebar panel
      mainPanel(

        fluidRow(
          column(width = 4, align = 'center',
            # p('This is where the palette will go'),
            shinycssloaders::withSpinner(plotOutput('palettePlot')),
            shinycssloaders::withSpinner(tableOutput('palette'))
          ),
          column(width = 8, align = 'center',
                 # p('This is where the input image will go'),
                 shinycssloaders::withSpinner(plotOutput('photo'))

          )
        )

      ) #end main panel
    ) #end sidebar layout
  ) #end createPalettePage





  #Colorblind page
  colorblindPage <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        h2('Instructions'),
        p("This page uses the same photo that is specified on the 'Create a palette' page. Select a colorblind option to create a palatte based on the colorblind version of the image."),
        selectizeInput('cb.mode', 'Colorblind mode', choices = c('Red', 'Green', 'Blue'))
        
      ), #end sidebar panel
      mainPanel(
        
        fluidRow(
          shinycssloaders::withSpinner(plotOutput('cb.photo'))
        ),
        fluidRow(
          column(8, align = 'center',
                 shinycssloaders::withSpinner(plotOutput('cb.palette'))),
          column(4, align = 'center',
                 shinycssloaders::withSpinner(tableOutput('cb.palTable')))
        )
        
      ) #end main panel
    ) #end sidebar layout
  ) #end colorblind page






  #Main page layout
  ui <- navbarPage("Photopal", theme = shinytheme('flatly'),
                   tabPanel("Create a palette", createPalettePage),
                   tabPanel("Colorblind", colorblindPage)
  )





# Server ------------------------------------------------------------------

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
      appData$pal <- palette_create(input$numcols, image2rgb(appData$userPhoto[['datapath']]), proceed = T)
    })

    #Observe default button pushed
    observeEvent(input$useDefault, {
      appData$palPhoto <- appData$defaultPhoto
      appData$userPhotoLoc = 'stadium.rda'
      appData$pal <- palette_create(input$numcols, image2rgb(), proceed = T)
    })
    
    #Update number of colors
    observeEvent(input$update, {
      validate(need(!is.null(appData$palPhoto), ' '))
      appData$pal <- palette_create(input$numcols, image2rgb(), proceed = T)
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
                                                  num.color = input$numcols)
      }
      
      if(input$cb.mode == 'Green'){
        appData$cb.pal <- color_blindness_palette(loc = appData$userPhotoLoc,
                                                  mode = 'green', plot_images = F, plot_palette = F,
                                                  num.color = input$numcols)
      }
      
      if(input$cb.mode == 'Blue'){
        appData$cb.pal <- color_blindness_palette(loc = appData$userPhotoLoc,
                                                  mode = 'blue', plot_images = F, plot_palette = F,
                                                  num.color = input$numcols)
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
    
    
    



  } #end server

  shinyApp(ui, server) #run app

} #end function

showcaseApp()





