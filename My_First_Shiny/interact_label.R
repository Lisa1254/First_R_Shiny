#Interactive Plot, add name label

library(shiny)

ui <- fluidPage(
  plotOutput("scatter", click = "plot_click", hover = "plot_hover"),
  verbatimTextOutput("hover"),
  tableOutput("click")
)

server <- function(input, output, session) {
  
  plot_frame <- reactive({
    data.frame(Name=LETTERS[1:10], x_val=rep(1:5,2), y_val=round(rnorm(10,25,5)))
  })
  
  g <- reactive({
    ggplot(data=plot_frame()) +
      geom_point(aes(x=x_val, y=y_val))
  })
  
  output$scatter <- renderPlot({
    g()
  })
  
  output$hover <- renderText({
    req(input$plot_hover)
    paste0("Mouse is hovering at:[", round(input$plot_hover$x,2), ", ", round(input$plot_hover$y,2), "]")
  })
  
  output$click <- renderTable({
    req(input$plot_click)
    nearPoints(plot_frame(), input$plot_click)
  })
  
  
}

shinyApp(ui, server)