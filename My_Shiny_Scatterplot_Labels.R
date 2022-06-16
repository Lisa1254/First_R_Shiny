#Cumulation of practice apps
#This Shiny constructs a simple scatterplot, then adds a name label for clicked points

library(ggplot2)
library(ggrepel)
library(shiny)

shape_choice <- setNames(c(15,16,17,8), c("Square", "Circle", "Triangle", "Star"))

ui <- fluidPage(
  fluidRow(
    column(6,numericInput("n", "Number of points", value = 10, min = 2, max = 100)),
    column(6,selectInput("shape", "Point Shape", choices = shape_choice))
  ),
  actionButton("plot", "Generate Plot"),
  plotOutput("scatter", click = "plot_click", hover = "plot_hover", dblclick = "plot_reset"),
  verbatimTextOutput("hover")
)

server <- function(input, output, session) {
  
  #On Plot click, generate plot data
  p_n <- eventReactive(input$plot, input$n)
  x_vals <- reactive(rnorm(p_n()))
  y_vals <- reactive(rnorm(p_n()))
  psh <- eventReactive(input$plot, input$shape)
  
  plot_frame <- reactive({
    data.frame(Name=paste0("Gene_", seq(1,p_n())), 
               x_val=x_vals(), 
               y_val=y_vals())
  })
  
  g <- reactive({
    ggplot(data=plot_frame()) +
      geom_point(aes(x=x_val, y=y_val), shape = as.numeric(psh()), size = 3)
  })
  
  #Output mouse hover information
  output$hover <- renderText({
    req(input$plot_hover)
    paste0("Mouse is hovering at:[", round(input$plot_hover$x,2), ", ", round(input$plot_hover$y,2), "]")
  })
  
  #On mouse click, get Near Point data
  nearTable <- reactive({
    req(input$plot_click)
    nearPoints(plot_frame(), input$plot_click)
  })
  
  
  #Use NearPoints to add labels to plot
  selected <- reactiveVal({
    vector()
  })
  
  id_lab <- reactive({
    nearTable()[,1]
  })
  
  observeEvent(input$plot_click,
               selected(c(id_lab(), selected()))  
  )
  #If new plot generated, reset selected info
  observeEvent(input$plot,
               selected(vector()))
  
  #Output Plot
  output$scatter <- renderPlot({
    if (length(selected() > 0)) {
      tf_labels <- ifelse(plot_frame()$Name %in% selected(), TRUE, FALSE)
      g() + 
        geom_text_repel(aes(x=x_val, y=y_val, label=ifelse(tf_labels, Name, '')), 
                        min.segment.length = 0, size = 3, max.overlaps = 15)
    } else {
      g()
    }
  })
  
}

shinyApp(ui, server)