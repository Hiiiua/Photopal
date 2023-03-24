


library(shiny)
library(rgl)

#Loading image
image = load.image('https://topbrunchspots.com/wp-content/uploads/2022/05/AF1QipM-ql78yz46DGynt2tb1l7i8gK8zOAfN8dCQqiPw1600-h1000-k-no.jpeg')

#Gather red, green, and blue information (pair is important, not position)
df.rgb <- data.frame(red = as.vector(image[,,,1]),
                     green = as.vector(image[,,,2]),
                     blue = as.vector(image[,,,3]))

#Individual hex code for each pixel (remove from final code, this is just for fun right now)
df.rgb$hex <- mapply(rgb, df.rgb[,'red'], df.rgb[,'green'], df.rgb[,'blue'])



# UI ----------------------------------------------------------------------

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Various Clusters for Omaha Zoo Image"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("clusters",
                        "Number of clusters:",
                        min = 1,
                        max = 25,
                        value = 5),
            actionButton('go', 'Cluster!'),
            plotOutput('image')
        ),

        # Show a plot of the generated distribution
        mainPanel(
          fluidRow(
            column(4,
              plotOutput('palette')),
            column(4,
                   rglwidgetOutput('plot3d'))
            )
        )
    )
)



# Server ------------------------------------------------------------------

# Define server logic required to draw a histogram
server <- function(input, output) {
  try(close3d())
  # vals <- reactiveValues(
  #   num.clusters <- input$clusters
  # )
  # 
  # observeEvent('go', {
  #   vals$num.clusters <- input$clusters
  # })
  
  #kmeans clustering on color
  
  observeEvent(input$go, {
    clust.colors <- kmeans(df.rgb[,c('red', 'green', 'blue')],
                           centers = input$clusters)
    centers <- clust.colors$centers
    cluster <- clust.colors$cluster
    #Convert rgb into hex code
    palColors <- mapply(rgb, centers[,'red'],
                        centers[,'green'],
                        centers[,'blue'])
    
    output$palette <- renderPlot(barplot(sort(table(palColors)),
                                          col = sort(palColors)))
    
    output$plot3d <- renderRglwidget({
      #Plot data with color of nearest center
      plot3d(df.rgb[,c('red', 'green', 'blue')], col = palColors[cluster])
      rglwidget()
    })
  })
  
  

  output$palette <- renderPlot(barplot(sort(table(palColors)),
                                       col = sort(palColors)))

  output$plot3d <- renderRglwidget({
    #Plot data with color of nearest center
    plot3d(df.rgb[,c('red', 'green', 'blue')], col = palColors[cluster])
    rglwidget()
  })
  
  output$image <- renderPlot(plot(image, axes = F))
}

# Run the application 
shinyApp(ui = ui, server = server)
