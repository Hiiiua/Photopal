#' Shiny app calling function
#'
#' @importFrom shiny runApp
#' @export


showcaseApp <- function(){
  appDir <- system.file("shiny-examples", "showcaseApp", package = "Photopal")
  if (appDir == ""){
    stop(paste0("Could not find the directory. ",
                "Try re-install `Photopal`,"), call. = F)
  }
  shiny::runApp(appDir, display.mode = "normal")
} 




library(shiny)
library(shinyjs)
library(Photopal)
library(shinythemes)
library(imager)
library(stringr)


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

  ) #end colorblind page


  #Color analysis
  colorAnalysisPage <- fluidPage(

  ) #end color analysis page



  #Main page layout
  ui <- navbarPage("Photopal", theme = shinytheme('flatly'),
                   tabPanel("Create a palette", createPalettePage),
                   tabPanel("Colorblind", colorblindPage),
                   tabPanel("Image color analysis", colorAnalysisPage)
  )





# Server ------------------------------------------------------------------

  server <- function(input, output, session){

    #Data inputted from user
    appData <- reactiveValues(
      userPhoto = NULL,
      defaultPhoto = stadium,
      palPhoto = NULL,
      pal = NULL
    )#end
    
    #Observe new file upload from user
    observeEvent(input$userPic, {
      appData$userPhoto <- input$userPic
      validate(need(!is.null(appData$userPhoto), 'Photo needs to be uploaded'))
      appData$palPhoto <- load.image(appData$userPhoto[['datapath']])
      appData$pal <- palette_create(input$numcols, image2rgb(appData$userPhoto[['datapath']]), proceed = T)
    })

    #Observe default button pushed
    observeEvent(input$useDefault, {
      appData$palPhoto <- appData$defaultPhoto
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









  } #end server

  shinyApp(ui, server) #run app

} #end function

showcaseApp()





