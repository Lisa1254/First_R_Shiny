#Figure out how to identify point coordinates on click

library(shiny)

shape_choice <- setNames(c(15,16,17,8), c("Square", "Circle", "Triangle", "Star"))

ui <- fluidPage(
  fluidRow(
    column(6,numericInput("n", "Number of points", value = 10, min = 2, max = 100)),
    column(6,selectInput("shape", "Point Shape", choices = shape_choice))
  ),
  actionButton("plot", "Generate Plot"),
  plotOutput("scatter", click = "plot_click"),
  verbatimTextOutput("info")
)

server <- function(input, output, session) {
  p_n <- eventReactive(input$plot, input$n)
  x_val <- reactive(seq(1,p_n()))
  y_val <- eventReactive(input$plot, rnorm(input$n))
  
  psh <- eventReactive(input$plot, input$shape)
  
  output$scatter <- renderPlot({
    plot(x=x_val(), y = y_val(), 
         pch = as.numeric(psh()), 
         cex = 3,
         xlab = paste0("Numbers 1 through ", p_n()),
         ylab = "Random values"
    )
  })
  
  output$info <- renderText({
    
    xy_str <- function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("x=", round(e$x, 1), " y=", round(e$y, 1), "\n")
    }
    
    paste0("click: ", xy_str(input$plot_click))
  })
}

shinyApp(ui, server)