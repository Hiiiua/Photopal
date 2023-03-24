## ---------------------------
##
## Script name: initialScripts.R
##
## Purpose of script:
##
## Author: Tyler Wiederich
##
## Date Created: 2023-03-23
##
## ---------------------------
##
## Notes: A place to layout some starting ideas
##   
##
## ---------------------------

library(rgl)
library(imager)

#Loading image
image = load.image('https://topbrunchspots.com/wp-content/uploads/2022/05/AF1QipM-ql78yz46DGynt2tb1l7i8gK8zOAfN8dCQqiPw1600-h1000-k-no.jpeg')
plot(image)

#Gather red, green, and blue information (pair is important, not position)
df.rgb <- data.frame(red = as.vector(image[,,,1]),
           green = as.vector(image[,,,2]),
           blue = as.vector(image[,,,3]))

#Individual hex code for each pixel (remove from final code, this is just for fun right now)
df.rgb$hex <- mapply(rgb, df.rgb[,'red'], df.rgb[,'green'], df.rgb[,'blue'])





#kmeans clustering on color
num.clusters <- 5
clust.colors <- kmeans(df.rgb[,c('red', 'green', 'blue')], centers = num.clusters)
centers <- clust.colors$centers
cluster <- clust.colors$cluster


#Convert rgb into hex code
palColors <- mapply(rgb, centers[,'red'], centers[,'green'], centers[,'blue'])

barplot(table(palColors), col = palColors)
plot(image)


#Plot individual colors
plot3d(df.rgb[,c('red', 'green', 'blue')], col = df.rgb[,'hex'])

#Plot centers
plot3d(centers[,c('red', 'green', 'blue')], col = palColors,
       size = 20)

#Plot data with color of nearest center
plot3d(df.rgb[,c('red', 'green', 'blue')], col = palColors[cluster])







#All possible color comparisons from centers
comparisons <- expand.grid(1:nrow(centers), 1:nrow(centers))
test = centers[as.numeric(comparisons[5,]),]

#Compute squared distance of distance
distance <- function(colorCompareMatrix){
  sum(apply(colorCompareMatrix, 2, diff)^2)
}

#Storing Euclidean distances
dist.vector <- vector(length = nrow(comparisons))
for(i in 1:nrow(comparisons)){
  dist.vector[i] <- sqrt(distance(centers[as.numeric(comparisons[i,]),]))
}

dist.matrix <- matrix(dist.vector, nrow = nrow(centers), ncol = nrow(centers),
                      dimnames = list(palColors, palColors)) #reminder, smaller is more similar



  