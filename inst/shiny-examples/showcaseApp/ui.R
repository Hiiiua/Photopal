library(shiny)
library(rgl)
library(shinyjs)
library(shinythemes)
library(imager)


#Color palette page
createPalettePage <- fluidPage(
  useShinyjs(),
  sidebarLayout(
    sidebarPanel(
      h2('Instructions'),
      p("Welcome to the Photopal showcase app! To get started, either upload an image with a valid extension (.png or .jpeg) or use our app's default image."),
      fileInput('userPic', 'Upload file'),
      uiOutput('clearUserPic'),
      actionButton('useDefault', 'Use default image')
      
    ), #end sidebar panel
    mainPanel(
      
      fluidRow(
        column(width = 6, align = 'center',
               p('This is where the palette will go'),
               verbatimTextOutput('test')
        ),
        column(width = 6, align = 'center',
               p('This is where the input image will go')
               
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

