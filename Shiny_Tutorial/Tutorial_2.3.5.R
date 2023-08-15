library(shiny)
#library(ggplot2)

ui <- fluidPage(
  verbatimTextOutput("one"),
  textOutput("two"),
  verbatimTextOutput("three"),
  plotOutput("plot", width = "400px"),
  dataTableOutput("table")
)

server <- function(input, output, session) {
  output$one <- renderPrint(summary(mtcars))

output$two <- renderText("Good morning!")

output$three <- renderPrint(t.test(1:5, 2:6))

  output$plot <- renderPlot(plot(1:5), height=300, width=700, res = 96, alt = "This is a graph.")

  output$table <- renderDataTable(mtcars, options = list(pageLength = 5, ordering = FALSE, searching = FALSE))
}

shinyApp(ui, server)