#Interactive Plot, add name label
library(ggplot2)
library(ggrepel)
library(shiny)

ui <- fluidPage(
  plotOutput("scatter", click = "plot_click", hover = "plot_hover"),
  verbatimTextOutput("hover"),
  tableOutput("click"),
  print("Label is:"),
  verbatimTextOutput("cl2"),
  print("q vector of names is:"),
  verbatimTextOutput("q_vec"),
  print("Truth values of Name %in% q_vec"),
  verbatimTextOutput("truth_q")
)

server <- function(input, output, session) {
  
  plot_frame <- reactive({
    data.frame(Name=LETTERS[1:10], x_val=rep(1:5,2), y_val=round(rnorm(10,25,5)))
  })
  
  g <- reactive({
    ggplot(data=plot_frame()) +
      geom_point(aes(x=x_val, y=y_val))
  })
  
  q <- reactiveVal({
    vector()
  })
  
  output$q_vec <- renderPrint({
    q()
  })
  
  output$truth_q <- renderPrint({
    plot_frame()[,1] %in% q()
  })
  
  output$scatter <- renderPlot({
  #  g()
    if (length(q() > 0)) {
      g() + 
        geom_text_repel(aes(x=x_val, y=y_val, label=ifelse(Name %in% q(), Name, '')), 
                        min.segment.length = 0, size = 3, max.overlaps = 15)
    } else {
      g()
    }
    
  })
  
  id_lab <- reactive({
    req(input$plot_click)
    nearTable()[,1]
  })
  
  observeEvent(input$plot_click,
               q(c(id_lab(), q()))  
  )
  
  output$hover <- renderText({
    req(input$plot_hover)
    paste0("Mouse is hovering at:[", round(input$plot_hover$x,2), ", ", round(input$plot_hover$y,2), "]")
  })
  

  nearTable <- reactive({
    req(input$plot_click)
    nearPoints(plot_frame(), input$plot_click)
  })
  
  output$click <- renderTable({
    nearTable()
  })
  
  output$cl2 <- renderPrint({
    id_lab()
  })
  
  
}

shinyApp(ui, server)