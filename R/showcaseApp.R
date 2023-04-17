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


# showcaseApp <- function(){
# # UI ----------------------------------------------------------------------
# 
#   
#   #Color palette page
#   createPalettePage <- fluidPage(
#     useShinyjs(),
#     sidebarLayout(
#       sidebarPanel(
#         h2('Instructions'),
#         p("Welcome to the Photopal showcase app! To get started, either upload an image with a valid extension (.png or .jpeg) or use our app's default image."),
#         fileInput('userPic', 'Upload file'),
#         uiOutput('clearUserPic'),
#         actionButton('useDefault', 'Use default image')
#         
#       ), #end sidebar panel
#       mainPanel(
#         
#         fluidRow(
#           column(width = 6, align = 'center',
#             p('This is where the palette will go'),
#             verbatimTextOutput('test')
#           ),
#           column(width = 6, align = 'center',
#                  p('This is where the input image will go')
#             
#           )
#         )
#         
#       ) #end main panel
#     ) #end sidebar layout
#   ) #end createPalettePage
#   
#   
#   
#   
#   
#   #Colorblind page
#   colorblindPage <- fluidPage(
#     
#   ) #end colorblind page
#   
#   
#   #Color analysis
#   colorAnalysisPage <- fluidPage(
#     
#   ) #end color analysis page
#   
#   
#   
#   #Main page layout
#   ui <- navbarPage("Photopal", theme = shinytheme('flatly'),
#                    tabPanel("Create a palette", createPalettePage),
#                    tabPanel("Colorblind", colorblindPage),
#                    tabPanel("Image color analysis", colorAnalysisPage)
#   )
#   
#   
#   
#   
# 
# # Server ------------------------------------------------------------------
# 
#   server <- function(input, output, session){
#     
#     
#     output$test <- renderPrint(appData$userPhoto) #See file input
#     
#     
#     #Data inputted from user
#     appData <- reactiveValues(
#       userPhoto = NULL
#     )#end
#     
#     
#     
#     #Assign uploaded pic to reactive values
#     observeEvent(input$userPic, { 
#       appData$userPhoto <- input$userPic
#     })#end
#     
#     
#     
#     
#     #Shows button to clear uploaded file only if a file is present
#     output$clearUserPic <- renderUI({ 
#       if(!is.null(appData$userPhoto)){
#         list(actionButton('clearPic', 'Clear uploaded image'),
#              p(' '))
#       }
#     })#end
#     
#     
#     
#     
#     #Reset file and data
#     observeEvent(input$clearPic, { 
#       reset('userPic')
#       appData$userPhoto <- NULL
#     })
#     observeEvent(input$useDefault, { 
#       reset('userPic')
#       appData$userPhoto <- NULL
#     })#end
#     
#     
#   
#     
#     
#     
#     
#     
#   } #end server
#   
#   
#   shinyApp(ui, server) #run app
#   
#   
# } #end function
# 
# showcaseApp()
# 
# 
# 
# 
# 
