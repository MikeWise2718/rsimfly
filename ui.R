# ui.R
# SimpleShinyInput Notes: this is a basic simple Shiny program with a few input devices. 
options(rgl.useNULL=TRUE)

library(shiny)
library(shinyRGL)
library(rglwidget)

shinyUI(fluidPage(
  titlePanel("Simple Shiny Input"),

  sidebarLayout(position = "left",
    sidebarPanel(h2("sidebar panel"),
           selectInput("clr","Color:",c("red","blue","green")),
           textInput("ent","Text Input:","Data"),
           sliderInput("cnt","Count:",100,10000,500,5),
           numericInput("seed","Seed:",1234,1,10000,1),
           numericInput("brk","Breaks:",30,1,100,1)

          ),
   mainPanel(h2("main panel"),
     tabsetPanel(
       tabPanel("LinePlot",h3("Random Walk"),plotOutput("lineplot")),
       tabPanel("Trefoil",h3("Trefoil"),rglwidgetOutput("trefoil")),
       tabPanel("Trajectory",h3("Trajectory"),rglwidgetOutput("trajectory")),
       tabPanel("Data",h3("Data Dump"),
                 div(dataTableOutput("dataframe"),class = "table",style = "font-size:80%;font-family:'Lucida Console New'")
                 ),
       tabPanel("Text Output",textOutput('echo'))
                )
       )
  )
))