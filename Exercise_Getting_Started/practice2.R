library(shiny)

animals <- c("cat", "dog", "squirrel", "porcupine", "bird", "snake", "I hate animals")

ui <- fluidPage(
  textInput("see", "You can see this type:"),
  passwordInput("hidden", "This type is hidden:"),
  checkboxGroupInput("animal", "What animals do you like?", animals),
  actionButton("click", "Click me!"),
  actionButton("drink", "Drink me!", icon=icon("cocktail")),
  textOutput("known"),
  textOutput("unknown")
)

server <- function(input, output, session) {
  output$known <- renderText({
    paste("I know what you typed above!", input$see)
  })
  output$unknown <- renderText({
    paste("Oops, I was peeking at this one!", input$hidden)
  })
}

shinyApp(ui, server)