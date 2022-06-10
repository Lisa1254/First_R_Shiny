#Given the provided UI, fix each of the following servers
library(shiny)

ui <- fluidPage(
  textInput("name", "What is your name?"),
  textOutput("greeting")
)

#Problem 1
#server1 <- function(input, output, server) {
#  input$greeting <- renderText(paste0("Hello ", name))
#}
#Problem is using input instead of output for renderText, and not specifying input for name
#Fix
#server1 <- function(input, output, session) {
#  output$greeting <- renderText(paste0("Hello ", input$name))
#}

#shinyApp(ui, server1)

#Problem 2
#server2 <- function(input, output, server) {
#  greeting <- paste0("Hello ", input$name)
#  output$greeting <- renderText(greeting)
#}
#Problem is defining greeting without using reactive, and using the same id as the output
#Fix
#server2 <- function(input, output, session) {
#  message <- reactive(paste0("Hello ", input$name))
#  output$greeting <- renderText(message())
#}

#shinyApp(ui, server2)

#Problem 3
#server3 <- function(input, output, server) {
#  output$greting <- paste0("Hello", input$name)
#}
#Problem is misspelling the output variable id and forgetting renderText command for reactive input
#Fix
server3 <- function(input, output, session) {
  output$greeting <- renderText(paste0("Hello ", input$name))
}

shinyApp(ui, server3)
