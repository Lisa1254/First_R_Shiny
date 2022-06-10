#Re-create the Shiny app from Section 2.3.3, this time setting height to 300px and width to 700px. 
#Set the plot “alt” text so that a visually impaired user can tell that its a scatterplot of five random numbers.

#Update the options in the call to renderDataTable() below so that the data is displayed, but all other controls are suppress (i.e. remove the search, ordering, and filtering commands)

library(shiny)

ui <- fluidPage(
  plotOutput("plot", height = "300px", width = "700px"),
  dataTableOutput("table")
)

server <- function(input, output, session) {
  output$plot <- renderPlot(plot(1:5), 
                            alt = "Scatterplot of five random numbers.", 
                            res = 96)
  output$table <- renderDataTable(mtcars, options = list(pageLength = 5,
                                                         ordering = FALSE,
                                                         searching = FALSE))
}

shinyApp(ui, server)