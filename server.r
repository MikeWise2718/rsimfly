# server.r
# SimpleShinyInput Notes: this is a basic simple Shiny program with a few input controls. 
options(rgl.useNULL=TRUE)

library(shiny)
library(ggplot2)
library(shinyRGL)
library(rgl)
library(rglwidget)

shinyServer(function(input, output) 
{
  histdata <- reactive(
    {
      set.seed(input$seed)
      df <- data.frame(x=1:input$cnt,dy=rnorm(input$cnt))
      df$y <- cumsum(df$dy)
      df
    }
  )
  tit <- reactive(
    {
      sprintf("seed:%d",input$seed)
    }
  )
  output$echo = renderText(
    {
      sprintf("the %s is %s and has %d rows and uses the %d seed",
      input$ent,input$clr,nrow(histdata()),input$seed)
    }
  )
  output$dataframe <- renderDataTable({
                           df<-histdata()
                           df$x  <- round(df$x,5)
                           df$y  <- round(df$y,5)
                           df$dy <- round(df$dy,5)
                           df
                          },
                          options = list(
                          pageLength = 100
                        )
  )
  output$trefoil <- renderRglwidget(
    {
       theta <- seq(0,2 * pi,len = 25)
       cen <- cbind(sin(theta) + 2 * sin(2 * theta),
              2 * sin(3 * theta),
              cos(theta) - 2 * cos(2 * theta))

      e1 <- cbind(cos(theta) + 4 * cos(2 * theta),
             6 * cos(3 * theta),
             sin(theta) + 4 * sin(2 * theta))

      knot <- cylinder3d(center = cen,e1 = e1,radius = 0.8,closed = TRUE)

      shade3d(addNormals(subdivision3d(knot,depth = 2)),col = "green")
      rglwidget()
    }
  )
  output$trajectory <- renderRglwidget({
   hdf <- read.csv("tstate_helix.csv")
   lines3d(hdf$x,hdf$y,hdf$z,col = "purple")
   rglwidget()
  }
  )

  output$lineplot <- renderPlot(
    { 
      qplot(data=histdata(),x,y,color=I(input$clr),geom="line")
    }
  )
}
)