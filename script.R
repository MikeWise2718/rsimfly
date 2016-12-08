library(rgl)

# A trefoil knot 
open3d()
theta <- seq(0,2 * pi,len = 25)

# knot <- cylinder3d(
#   center = cbind(
#     sin(theta) + 2*sin(2*theta),   
#     2*sin(3*theta), 
#     cos(theta) - 2*cos(2*theta)),
#     e1 = cbind(   cos(theta) + 4*cos(2*theta), 6*cos(3*theta), 
#     sin(theta) + 4*sin(2*theta)),
#   radius = 0.8, 
#   closed = TRUE)

cen <- cbind(sin(theta) + 2 * sin(2 * theta),
              2 * sin(3 * theta),
              cos(theta) - 2 * cos(2 * theta))

e1 <- cbind(cos(theta) + 4 * cos(2 * theta),
             6 * cos(3 * theta),
             sin(theta) + 4 * sin(2 * theta))

knot <- cylinder3d(center = cen,e1 = e1,radius = 0.8,closed = TRUE)

shade3d(addNormals(subdivision3d(knot,depth = 2)),col = "purple")