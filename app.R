
library(shiny)

#-----------------------------------------------------------------------
#### Run other code ####

library(maps)
library(mapproj)

source("helpers.R")
counties <- readRDS("data/counties.rds")
library(maps)
library(mapproj)
#-----------------------------------------------------------------------

#### ui.R ####

# # Define UI for application that draws a histogram
ui = fluidPage(
  # Application title
  titlePanel("censusVis"),
  # Sidebar with a slider input for the number of bins
  sidebarLayout(position = "right",
    sidebarPanel('sidebar panel',
                 helpText("Create demographic maps with information from the 2010 US Census."),
                 selectInput("var", 
                             label = "Choose a variable to display",
                             choices = c("Percent White", "Percent Black",
                                         "Percent Hispanic", "Percent Asian"),
                             selected = "Percent White"),
                 sliderInput("range", 
                             label = "Range of interest:",
                             min = 0, max = 100, value = c(0, 100))),
    # Create text
    mainPanel(p("p creates a paragraph of text."),
              p("A new p() command starts a new paragraph. Supply a style attribute to change the format of the entire paragraph.", style = "font-family: 'times'; font-si16pt"),
              strong("strong() makes bold text."),
              em("em() creates italicized (i.e, emphasized) text."),
              br(),
              code("code displays your text similar to computer code"),
              div("div creates segments of text with a similar style. This division of text is all blue because I passed the argument 'style = color:blue' to div", style = "color:blue"),
              br(),
              p("span does the same thing as div, but it works with",
                span("groups of words", style = "color:blue"),
                "that appear inside a paragraph."),
              br(),
              img(src="vu.png", height = 64, width = 341),
              br(),
              # Show a plot of the generated distribution
              plotOutput("map"))
  )
)
#-----------------------------------------------------------------------

#### server.R ####

# # Define server logic required to draw a histogram
server = function(input, output) {
  # Expression that generates a histogram. The expression is wrapped in a call to renderPlot to indicate that:
  #  1) It is "reactive" and therefore should re-execute automatically when inputs change
  #  2) Its output type is a plot
  output$map <- renderPlot({
    args <- switch(input$var,
                   "Percent White" = list(counties$white, "darkgreen", "% White"),
                   "Percent Black" = list(counties$black, "black", "% Black"),
                   "Percent Hispanic" = list(counties$hispanic, "darkorange", "% Hispanic"),
                   "Percent Asian" = list(counties$asian, "darkviolet", "% Asian"))
    
    args$min <- input$range[1]
    args$max <- input$range[2]
    
    do.call(percent_map, args)
  })
}
#-----------------------------------------------------------------------

#### Run shinyApp() ####

shinyApp(ui = ui, server = server)

# create and run test.R with call shinyApp() at the end, you could then run it from the console with:
# print(source("test.R"))
