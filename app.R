#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

###############################################################################
##                               WELCOME TO PhotoPal                         ##
##                           Better plots for your work!                     ##
##                               ENJOY YOUR STAY!                            ##
## ------------------------------------------------------------------------- ##
##                                                                           ##
###############################################################################

## WARNING: This will check for installed packages and install if they are not.

requiredPackages <- c('shiny','shinythemes','tidyverse','patchwork','DT', 'highcharter')
for(package in requiredPackages){
  if(package %in% rownames(installed.packages()) == FALSE) {install.packages(package)}
}




library(shiny)
library(shinythemes)
library(tidyverse)
library(patchwork)
library(DT)
library(highcharter)



### UI ###
ui <- fluidPage(
  theme = shinytheme('yeti'),
  navbarPage(
    # App. title
    title = 'PhotoPal',
    # Main Tabs
    tabPanel(
      "Normal Pallet"
    ),
    tabPanel(
      "Colorblind Safe Pallet"
    )
  )
)

## End of UI ##

### SERVER ###
server <- function(input, output){
  
}


shinyApp(ui=ui, server=server)





