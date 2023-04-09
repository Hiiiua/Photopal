#' A function read in an image from url, locally or default build-in image.
#' 
#' 
#' @param loc A string. A valid url or file for the image
#' @importFrom imager load.image
#' @export
#' @examples
#' im = image2rgb()
#' head(im)
image2rgb <- function(loc = 'stadium.rda'){
  stadium = paste(strsplit(getwd(), 'Photopal')[[1]][1], 
                  'Photopal/data/stadium.rda', sep = '')
  load(stadium)
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
#' @importFrom farver convert_colour
#' @importFrom graphics image
#' @importFrom grDevices rgb
#' @export
#' @examples 
#' contrast(c(70, 50, 50), c(0,0,0))
#' contrast(c(0.2745098, 0.1960784, 0.1960784),c(0,0,0), maxColorValue = 1)
contrast <- function(c1, c2, maxColorValue = 255){
  if(maxColorValue != 255){
    c1 = c1/maxColorValue * 255
    c2 = c2/maxColorValue * 255
  }
  s1 = farver::convert_colour(t(c1), from = 'rgb', to='lab')
  s2 = farver::convert_colour(t(c2), from = 'rgb', to='lab')
  distance = sqrt(sum((s1-s2)**2))
  
  c = rbind(c1, c2)
  graphics::image(1:nrow(c), 0, as.matrix(1:nrow(c)), 
        col= grDevices::rgb(c[,1], c[,2], c[,3], maxColorValue = 255),
        xlab="", ylab = "", xaxt = "n", yaxt = "n", bty = "n")
  # axes = F)
  # axis(1, at=seq(-1,1, length=2), labels = c('c1','c2'), las=2)
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
#' @importFrom farver convert_colour
#' @importFrom graphics image
#' @importFrom grDevices rgb
#' @export
#' @examples 
#' is_sufficient(c(70, 50, 50), c(0,0,0))
is_sufficient <- function(c1, c2, maxColorValue=255, threshold=35){
  return(contrast(c1, c2, maxColorValue = 255) >= threshold)
}




