#Practice making a shiny that pretends to log in a customer and adds a delivery order with a little plot showing the order. A message will be printed to the console when the delivery is scheduled

library(shiny)

ui <- fluidPage(
  ##Log in section
  fluidRow(
    column(6, textInput("user", label = "Enter your username here", placeholder = "e.g. John Smith")),
    column(6, passwordInput("pswd", label = "Enter your password here", placeholder = "Password is case sensitive!"))
  ),
  actionButton("login", "Log in"),
  textOutput("log_success"),

  ##Order section
  fluidRow(
    column(8, selectInput("candy", "What kind of candy do you want delivered?",
                       choices = 
                         list(`chocolate` = list("Mars", "Twirly", "Snickers", "Butterfinger"),
                              `chewy` = list("Skittles", "Starburst", "Sodalicious", "Gushers"))
  )),
  column(4, numericInput("candy_box", "How many candy boxes?", value = 5, min = 1, max = 25, step = 1))
  ),
  fluidRow(
    column(8, selectInput("toys", "What kind of toys do you want delivered?", 
                          choices = list(`old stuff` = list("bouncy balls", "puzzle", "cards"),
                                         `electronic` = list("game boy", "playstation1", "n64")))),
    column(4, numericInput("toy_num", "How many toys do you want?", value = 1, min = 0, max = 5, step = 1))
  ),
  actionButton("order", "Order!"),
  plotOutput("order_pie"),
  
  ##Delivery Section
  sliderInput("slide_date", label = "When should we deliver?", min = as.Date("2022-06-16"), max = as.Date("2022-06-30"), value = as.Date("2022-06-17")),
  actionButton("deliver", "Deliver!"),
  textOutput("del_success")
)

server <- function(input, output, session) {
  
  ##Log in
  log_msg <- eventReactive(input$login, {
    paste0("Welcome ", input$user, ".\nSorry for peeking at your password, \"", input$pswd, "\"")
  })
  
  output$log_success <- renderText(log_msg())
  
  #Ordering
  o1 <- eventReactive(input$order, {
    input$candy
  })
  q1 <- eventReactive(input$order, {
    input$candy_box
  })
  o2 <- eventReactive(input$order, {
    input$toys
  })
  q2 <- eventReactive(input$order, {
    input$toy_num
  })
  
  output$order_pie <- renderPlot({
    pie(c(q1(), q2()), labels = c(o1(), o2()), main = "Order Quantities")
  })
  
  #Delivery
  dc <- eventReactive(input$deliver, {
    input$slide_date
  })
  output$del_success <- renderText({
    paste0("Thank you for your order!\nYour delivery will be sent on: ", dc())
  })
  observeEvent(dc(), {
    message("Delivery received")
  })
  
}

shinyApp(ui, server)