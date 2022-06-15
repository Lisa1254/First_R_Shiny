##Identify using ggplot instead of plot

library(shiny)
library(ggplot2)

ui <- fluidPage(
  plotOutput("scatter", click = "plot_click", hover = "plot_hover"),
  verbatimTextOutput("hover"),
  verbatimTextOutput("click")
)

server <- function(input, output, session) {

  plot_frame <- reactive({
    data.frame(Name=LETTERS[1:10], x_val=rep(1:5,2), y_val=round(rnorm(10,25,5)))
  })

  output$scatter <- renderPlot({
    ggplot(data=plot_frame()) +
      geom_point(aes(x=x_val, y=y_val))
  })
  
  output$hover <- renderText({
    paste0("Mouse is hovering at:\nx=", round(input$plot_hover$x,2), "\ny=", round(input$plot_hover$y,2))
  })
  
  output$click <- renderPrint({
    x_near <- round(input$plot_click$x)
    y_near <- round(input$plot_click$y)
    find_x <- plot_frame()[which(plot_frame()$x_val == x_near),]
    find_xy <- find_x[which(find_x$y_val == y_near),]
    find_xy
  })
  
}

shinyApp(ui, server)
