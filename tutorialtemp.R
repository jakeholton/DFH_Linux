library(shiny)

ui <- fluidPage(
verbatimTextOutput("one"),
  textOutput("two"),
  verbatimTextOutput("three")
)

server <- function(input, output, session) {

output$one <- renderPrint(summary(mtcars))

output$two <- renderText("Good morning!")

output$three <- renderPrint(t.test(1:5, 2:6))

}

shinyApp(ui, server)

#shiny::runApp("\\\\wsl.localhost\\Ubuntu\\home\\jholton\\DFH_Linux\\tutorialtemp.R")