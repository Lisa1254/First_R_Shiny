#Multiply the slider input by 5
#Ex 3 extends this to have second multiplier slider instead of multiply by 5

library(shiny)

ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", label = "and y is", min = 1, max = 50, value = 5),
  "then x times y is",
  textOutput("product")
)

server <- function(input, output, session) {

  output$product <- renderText({
    input$x*input$y
  })
}

shinyApp(ui, server)