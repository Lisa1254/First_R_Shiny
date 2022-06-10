library(shiny)

ui <- fluidPage(
  verbatimTextOutput("a"),
  textOutput("b"),
  verbatimTextOutput("c"),
  verbatimTextOutput("d")
)

server <- function(input, output, session) {
  
  output$a <- renderPrint(summary(mtcars))
  
  output$b <- renderText("Good morning!")
  
  output$c <- renderPrint(t.test(1:5, 2:6))
  
  output$d <- renderPrint(str(lm(mpg ~ wt, data = mtcars)))
  #If pairing with renderText like in the exercise, use textOutput, but it will print to R Console, not the shiny
  #Switching to renderPrint and paring with verbatimTextOutput alows the shiny to show the output for the function as written
  
}

shinyApp(ui, server)