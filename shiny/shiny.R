source("https://raw.githubusercontent.com/RenkoT97/APPR-2018-19/master/uvoz/tabela1.r", encoding="UTF-8")
tabela1 <- na.omit(tabela1)

server <- function(input, output, session) {
  
  selectedData <- reactive({
    tabela1[, c("LETO", input$ycol)]
  })
  
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  
  output$plot1 <- renderPlot({
    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
}

ui <- 
  
  pageWithSidebar(
    headerPanel('Izpusti toplogrednih plinov'),
    sidebarPanel(
      selectInput('ycol', 'Spremenljivka na y osi', tail(names(tabela1),-2),
                  selected=names(tabela1)[[2]]),
      numericInput('clusters', 'Število skupin', 4,
                   min = 1, max = 10)
    ),
    mainPanel(
      plotOutput('plot1')
    )
  )

runGadget(ui, server = server, port = getOption("shiny.port"),
          viewer = paneViewer(), stopOnCancel = TRUE)

