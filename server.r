# server.r
# SimpleShinyInput Notes: this is a basic simple Shiny program with a few input controls. 
options(rgl.useNULL=TRUE)

library(shiny)
library(ggplot2)
library(shinyFiles)
library(shinyRGL)
library(rgl)
library(mw3dlib)
library(reshape2)

cfobj <- mw3dlib::readCompObjCrazyflie()
inicsvname <- "tstate_helix.csv"
defhdf <- read.csv(inicsvname)

shinyServer(function(input, output,session) 
{
  shinyFileChoose(input = input,id = "trajfile",session = session,roots = c("wd" = '.'))

  mem <- reactiveValues(trajfname = inicsvname)

  hdf <- reactive({
    if (is.null(input$trajfile)) return(defhdf)
    #inFile <- parseFilePaths(roots = c(wd = '.'),input$trajeil)
    #print(sprintf("inFile:%s",inFile))
    lcsvfname <- input$trajfile$files$`0`[[2]]
    print(lcsvfname)
    newhdf <- read.csv(lcsvfname)
    mem$trajfname <- lcsvfname
    return(newhdf)  
  })
  tit <- reactive(
    {
      sprintf("seed:%d",input$seed)
    }
  )
  output$echo = renderText(
    {
      sprintf("file %s and has %d rows",mem$trajfname,nrow(hdf()))
    }
  )
  output$dataframe <- renderDataTable({hdf()},options = list(pageLength = 100))
  output$gtrefoil <- renderRglwidget(
    {
      print("rendering green trefoil")
      theta <- seq(0,2 * pi,len = 25)
      cen <- cbind(sin(theta) + 2 * sin(2 * theta),
                                2 * sin(3 * theta),
                   cos(theta) - 2 * cos(2 * theta))

      e1 <- cbind(cos(theta) + 4 * cos(2 * theta),
                               6 * cos(3 * theta),
                  sin(theta) + 4 * sin(2 * theta))

      knot <- cylinder3d(center = cen,e1 = e1,radius = 0.8,closed = TRUE)
      try(rgl.close())
      shade3d(addNormals(subdivision3d(knot,depth = 2)),col = "green")
      print("done rendering trefoil")
      rglwidget()
    }
  )
  output$trajectory <- renderRglwidget(
    {
      print("render trajectory")
#      print(rgl.dev.list())
#      rgl.close()
      try(rgl.close())
      lines3d(hdf()$x,hdf()$y,hdf()$z,col = "purple")
      rglwidget()
    }
  )
  output$crazyflie <- renderRglwidget({
    print("rendering crazyflie")
    try(rgl.close())
    mw3dlib::renderCompObj3d(cfobj)
    print("done rendering crazyflie")
    rglwidget()
  }
  )

  output$lineplot <- renderPlot(
    {
      ddf <- hdf()
      mdf <- melt(ddf,id.vars = "t",,variable.name = "coord",value.name="val")
      ggplot(mdf) + geom_line(aes(t,val,color=coord)) + 
                   labs(title=mem$trajfname)
    }
  )
}
)