library(shiny)

ui <- fluidPage(

    textInput("name", "What's your name?"),
    textOutput("greeting")

)

server <- function(input, output, session) {

    output$greeting <- renderText({
  paste0("Hello ", input$name)
})

}

shinyApp(ui, server)

#shiny::runApp("\\\\wsl.localhost\\Ubuntu\\home\\jholton\\DFH_Linux\\Tutorial_1.8.1.R")