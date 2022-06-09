#Practice getting the label for testInput embededded
library(shiny)

ui <- fluidPage(
  textInput("name", label = NULL, placeholder = "Your name"),
  sliderInput("slide_date", label = "When should we deliver?", min = as.Date("2020-09-16"), max = as.Date("2020-09-23"), value = as.Date("2020-09-17")),
  sliderInput("slide_fix", label = "How many boxes of candy would you like?", min = 0, max = 100, value = 0, step = 5, animate = TRUE),
  selectInput("candy", "What is your favourite kind of candy?",
              choices = 
                list(`chocolate` = list("Mars", "Twirly", "Snickers", "Butterfinger"),
                     `chewy` = list("Skittles", "Starburst", "Sodalicious", "Gushers"))
              ),
  textOutput("response")
)

server <- function(input, output, session) {
  output$response <- renderText({
    paste0("Thank you, ", input$name, ". Your order will be delivered on ", input$slide_date, ". You will receive ", input$slide_fix, " boxes of ", input$candy)
  })
}

shinyApp(ui, server)