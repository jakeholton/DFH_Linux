library(shiny)


ui <- fluidPage(
  textInput("name", "What's your name?",placeholder = "Your name goes here :)"),
 sliderInput("num2", "Number two", value = 0, min = 0, max = 100, step = 5, animate = TRUE),
 selectInput("state", "Choose a state:",
      list(`East Coast` = list("NY", "NJ", "CT"),
           `West Coast` = list("WA", "OR", "CA"),
           `Midwest` = list("MN", "WI", "IA"))
    )
)

server <- function(input, output, session) {

}

shinyApp(ui, server)