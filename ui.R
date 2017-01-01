# ui.R
options(rgl.useNULL=TRUE)

library(shiny)
library(shinyRGL)
library(shinyFiles)
library(rgl)

shinyUI(fluidPage(
  titlePanel("Simple Shiny Input"),

  sidebarLayout(position = "left",
    sidebarPanel(h2("sidebar panel"),
       shinyFilesButton(id = "trajfile","Trajectory file","Choose a file",multiple = F),
       selectInput("clr","Color:",c("red","blue","green")),
       textInput("ent","Text Input:","Data"),
       sliderInput("cnt","Count:",100,10000,500,5),
       numericInput("seed","Seed:",1234,1,10000,1),
       uiOutput("choose_columns")
      ),
   mainPanel(h2("main panel"),
     tabsetPanel(
       tabPanel("LinePlot",h3("Random Walk"),plotOutput("lineplot")),
       tabPanel("Green Trefoil",h3("Trefoil"),rglwidgetOutput("gtrefoil")),
       tabPanel("Trajectory",h3("Trajectory"),rglwidgetOutput("trajectory")),
       tabPanel("Crazyflie",h3("Crazyflie"),rglwidgetOutput("crazyflie")),
       tabPanel("Data",h3("Data Dump"),
                 div(dataTableOutput("dataframe"),class = "table",style = "font-size:80%;font-family:'Lucida Console New'")
                 ),
       tabPanel("Text Output",textOutput('echo'))
                )
       )
  )
))