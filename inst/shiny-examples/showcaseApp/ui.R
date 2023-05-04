library(shinythemes)
library(shiny)
library(imager)
library(shinycssloaders)

createPalettePage <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      h2('Instructions'),
      p("Welcome to the Photopal showcase app! To get started, either upload an image with a valid extension (.png or .jpeg) or use our app's default image."),
      fileInput('userPic', 'Upload file',
                accept = c('.png', '.jpeg', '.JPG')),
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