#' A function read in an image from url, locally or default build-in image.
#' 
#' 
#' @param loc A string. A valid url or file for the image
#' 
#' @importFrom imager load.image
#' 
#' @export
#' 
#' @examples
#' im = image2rgb()
#' head(im)
image2rgb <- function(loc = 'stadium.rda'){
  stadium = Photopal::stadium
  if(loc != 'stadium.rda'){
    e = try(imager::load.image(loc), silent = T)
    if("try-error" %in% class(e) ){
      stop("Not a valid url or location, will proceed with default image.")
    }
    else{
      stadium = imager::load.image(loc)
    }
  }
    
  rgb_df = data.frame(red = as.vector(stadium[,,,1]),
                      green = as.vector(stadium[,,,2]),
                      blue = as.vector(stadium[,,,3]))
  return(rgb_df)
}



#' Determine the difference of two colors
#' 
#' This function returns the colors difference. 
#' Passing in two sets of rgb values of two colors, gets returned 
#' delta e color distance and display.
#' 
#' @param c1 A numeric list, rgb values of color1. 
#' @param c2 A numeric list, rgb values of color2.
#' @param maxColorValue Maximum color value, mostly 1 or 255
#' @param plot T/F. Default not to display the colors.
#' 
#' @importFrom farver convert_colour
#' @importFrom graphics image
#' @importFrom grDevices rgb
#' 
#' @export
#' 
#' @examples 
#' contrast(c(70, 50, 50), c(0,0,0))
#' contrast(c(0.2745098, 0.1960784, 0.1960784),c(0,0,0), maxColorValue = 1)
contrast <- function(c1, c2, maxColorValue = 255, plot = F){
  if(maxColorValue != 255){
    c1 = c1/maxColorValue * 255
    c2 = c2/maxColorValue * 255
  }
  s1 = farver::convert_colour(t(c1), from = 'rgb', to='lab')
  s2 = farver::convert_colour(t(c2), from = 'rgb', to='lab')
  distance = sqrt(sum((s1-s2)**2))
  
  if(plot == TRUE){
  c = rbind(c1, c2)
      graphics::image(1:nrow(c), 0, as.matrix(1:nrow(c)), 
            col= grDevices::rgb(c[,1], c[,2], c[,3], maxColorValue = 255),
            xlab="", ylab = "", xaxt = "n", yaxt = "n", bty = "n")
      # axes = F)
      # axis(1, at=seq(-1,1, length=2), labels = c('c1','c2'), las=2)
  }
  return(distance)
}


# https://www.researchgate.net/post/Human_eye_color_change_sensibility_in_CIELAB_units
# To get cie delta e, we need to go with cie 1976, for now we set the threshold as 35.
#' Tell if the difference is sufficient for human eye to perceive
#' 
#' This function returns whether the colors difference is sufficient for human eye 
#' to detect or not.
#' 
#' @param c1 A numeric list, rgb values of color1.
#' @param c2 A numeric list, rgb values of color2.
#' @param maxColorValue Maximum color value, mostly 1 or 255
#' @param threshold A number, threshold for differentiating two colors in delta e.
#' 
#' @importFrom farver convert_colour
#' @importFrom graphics image
#' @importFrom grDevices rgb
#' 
#' @export
#' 
#' @examples 
#' is_sufficient(c(70, 50, 50), c(0,0,0))
is_sufficient <- function(c1, c2, maxColorValue=255, threshold=35){
  return(contrast(c1, c2, maxColorValue = maxColorValue) >= threshold)
}


#' A silent stop helper function
#' 
#' This function mutes the Error when calling stop
stop_quietly <- function() {
  opt <- options(show.error.messages = FALSE)
  on.exit(options(opt))
  stop()
}



# Following functions are modified on Tyler's script
#'Palette creating function
#'
#'This function creates a palette from an image. The image need to be input in 
#'dataframe of pixels in rgb. If the extracted colors are sufficient for differentiating
#'it automatically generates the pallete, but if the color contrast is less
#'than differentiating threshold, it will throw warning before proceeding.
#'
#'@param num.color An integer. How many colors needed in the palette
#'@param df.rgb A data.frame. This dataframe should have all pixels' rgb information of an image
#'@param threshold A number. To determine the minimum accepted color difference in the palette
#'
#'@importFrom graphics barplot
#'@importFrom stats kmeans
#'@importFrom grDevices dev.new
#'
#'@export
#'
#'@examples
#'df.rgb = image2rgb()
#'palette_create(5, df.rgb, 25)
palette_create <- function(num.color = 5, df.rgb, threshold = 25){
  clust.colors <- stats::kmeans(df.rgb[,c('red', 'green', 'blue')], centers = num.color)
  centers <- clust.colors$centers
  cluster <- clust.colors$cluster
  
  # look pairwise distance
  dist = expand.grid(seq(1:num.color), seq(1:num.color))
  colnames(dist) = c('c1', 'c2')
  for(i in seq(1:dim(dist)[1])){
    c1_idx = dist[i, 1]
    c2_idx = dist[i, 2]
    c1 = centers[c1_idx,]
    c2 = centers[c2_idx,]
    dist[i, 3] = contrast(c1, c2, 1)
    dist[i, 4] = is_sufficient(c1, c2, maxColorValue = 1, threshold = 35)
  }
  min_idx = sort(dist[,3], index.return=T)$ix[num.color+1]
  min_dist = dist[min_idx, 3]
  
  # Raise Warning when there is color contrast less than threshold
  if(min_dist < threshold){
    options(warn = 1)
    warning("The colors may be hard to differentiate, do you want to proceed?
            \n1: Yes, proceed no matter what \n2: No, I want to start over")
    
    proceed = readline(prompt = "Enter any number : ")
    if(proceed == 2){
      print('Please start over.')
      stop_quietly()
      }
    if((proceed != 1) & (proceed != 2)){
      print('Wrong input, please start over')
      stop_quietly()
    }
  }
  
  # creating palette
  palColors <- mapply(rgb, centers[,'red'], centers[,'green'], centers[,'blue'])
  dev.new(width=5, height=4)
  graphics::barplot(table(palColors), col = palColors, space=0, xlab = "",
                    names.arg = palColors, cex.names = 0.7, axes = F)
  return(palColors)
}


