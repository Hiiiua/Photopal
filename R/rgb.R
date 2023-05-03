#' A function read in an image from url, locally or default build-in image.
#' @author Hiiiua
#' 
#' @importFrom imager load.image
#'  
#' @param loc A string. A valid url or file for the image
#' @returns A 2d dataframe with columns rgb.
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

#' function converts 4d image data to dataframe
#' @author Hiiiua
#' 
#' @param cimg An 4d image tensor
#' @returns A 2d dataframe with columns rgb.
#' @export
#' 
#' @examples 
#' stadium = Photopal::stadium
#' cimg2rgb(stadium)
cimg2rgb <- function(cimg){
  df.rgb = data.frame(red = as.vector(cimg[,,,1]),
                      green = as.vector(cimg[,,,2]),
                      blue = as.vector(cimg[,,,3]))
  return(df.rgb)
}

#' Determine the difference of two colors
#' 
#' This function returns the colors difference. 
#' Passing in two sets of rgb values of two colors, gets returned 
#' delta e color distance and display.
#' @author Hiiiua
#' 
#' @param c1 A numeric list, rgb values of color1. 
#' @param c2 A numeric list, rgb values of color2.
#' @param maxColorValue Maximum color value, mostly 1 or 255
#' @param plot T/F. Default not to display the colors.
#' 
#' @importFrom farver convert_colour
#' @importFrom graphics image
#' @importFrom grDevices rgb
#' @returns A number. Delta e distance of two colors.
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
  
  if(plot == T){
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
#' @author Hiiiua
#' 
#' @param c1 A numeric list, rgb values of color1.
#' @param c2 A numeric list, rgb values of color2.
#' @param maxColorValue Maximum color value, mostly 1 or 255
#' @param threshold A number, threshold for differentiating two colors in delta e.
#' @param plot T/F. Default to display the colors.
#' 
#' @importFrom farver convert_colour
#' @importFrom graphics image
#' @importFrom grDevices rgb
#' @returns T/F. If the color contrast of the two colors are sufficient.
#'
#' @export
#' 
#' @examples 
#' is_sufficient(c(70, 50, 50), c(0,0,0))
is_sufficient <- function(c1, c2, maxColorValue=255, threshold=25, plot = T){
  return(contrast(c1, c2, maxColorValue = maxColorValue, plot = plot) >= threshold)
}


#' A silent stop helper function
#' 
#' This function mutes the Error when calling stop
# stop_quietly <- function() {
#   opt <- options(show.error.messages = FALSE)
#   on.exit(options(opt))
#   stop()
# }



# Following functions are modified on Tyler's script
#'Palette creating function
#'
#'This function creates a palette from an image. The image need to be input in 
#'dataframe of pixels in rgb. If the extracted colors are sufficient for differentiating
#'it automatically generates the pallete, but if the color contrast is less
#'than differentiating threshold, it will throw warning before proceeding.
#' @author Hiiiua
#' 
#' @param num.color An integer. How many colors needed in the palette
#' @param df.rgb A data.frame. This dataframe should have all pixels' rgb information of an image
#' @param threshold A number. To determine the minimum accepted color difference in the palette
#' @param plot T/F. Default to display the colors.
#' @param proceed A testing parameter
#' 
#' @importFrom graphics barplot
#' @importFrom stats kmeans
#' @importFrom grDevices dev.new
#' @importFrom utils menu
#' @importFrom cli cli_warn cli_inform
#' @returns A matrix. Hex codes and their rgb values.
#' @export
#' 
#' @examples
#'df.rgb = image2rgb()
#'palette_create(5, df.rgb, 25)

palette_create <- function(num.color = 5, df.rgb, threshold = 25, plot = T, proceed = NA){
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
    dist[i, 3] = contrast(c1, c2, 1, plot = F)
    dist[i, 4] = is_sufficient(c1, c2, maxColorValue = 1, 
                               threshold = threshold, plot = F)
  }
  min_idx = sort(dist[,3], index.return=T)$ix[num.color+1]
  min_dist = dist[min_idx, 3]
  
  # Raise Warning when there is color contrast less than threshold
  if(min_dist < threshold){
    cli::cli_warn("The colors may be hard to differentiate, do you want to proceed?")
    if (is.na(proceed)){
    proceed = utils::menu(c("Yes, proceed anyway", "No, I want to start over"))}
    
    # options(warn = 1)
    # warning("The colors may be hard to differentiate, do you want to proceed?
    #         \n1: Yes, proceed no matter what \n2: No, I want to start over")
    # proceed = readline(prompt = "Enter any number : ")
    
    if(proceed == 2){
      cli::cli_inform('Please start over.')
      stop()
    }
  }
  
  # creating palette
  palColors <- mapply(rgb, centers[,'red'], centers[,'green'], centers[,'blue'])
  if(plot == T){
    dev.new(width=5, height=4)
    graphics::barplot(table(palColors), col = palColors, space=0, xlab = "",
                      names.arg = palColors, cex.names = 0.7, axes = F)
  }
  palette_with_rgb = cbind(centers, palColors)
  return(palette_with_rgb)
}

# https://ixora.io/projects/colorblindness/color-blindness-simulation-research/
#' different color-blind simulations
#' 
#' This function takes in an image, transforming it to simulate color-blind vision
#' @author Hiiiua
#' 
#' @param loc A string. A location of an image
#' @param mode A string. Specify color blind type
#' @param compare T/F. True for displaying both normal and color-blind vision to compare.
#' 
#' @importFrom cli cli_warn
#' @importFrom imager load.image cimg
#' @importFrom graphics plot par
#' @importFrom Matrix solve
#' @returns cimg df. simulated cimg.
#' @param plot T/F. Default to display the colors.
#' 
#' @export
#' 
#' @examples 
#' color_blindness_simulation()

color_blindness_simulation <- function(loc = 'stadium.rda', mode = 'red', compare = T, plot =T){
  # red-blind = protanopia
  if(mode == 'red'){ 
    s = matrix(c(0, 1.05118294, -0.05116099,
                 0, 1, 0,
                 0, 0, 1), byrow = T, ncol = 3)
  }
  
  # green-blind = deuteranopia
  else if(mode == 'green'){
    s = matrix(c(1, 0, 0,
                 0.9513092, 0, 0.04866992,
                 0, 0, 1), byrow = T, ncol = 3)
  }

  # blue-blind = triamopia
  else if(mode == 'blue'){
  s = matrix(c(1, 0, 0,
               0, 1, 0,
               -0.86744736, 1.86727089, 0), byrow = T,  ncol = 3)
  }
  else{
    cli::cli_warn("Wrong color-blind mode")
    stop()
  }
  
  # transfer matrix from linear rgb [0,1] to LMS
  t = matrix(c(0.31399022, 0.15537241, 0.01775239,
               0.63951294, 0.75789446, 0.10944209,
               0.04649755, 0.08670142, 0.87256922),  nrow = 3) 
  ti = Matrix::solve(t)
  
  # simulation matrix, missing corresponding cones
  t_sim = ti %*% s %*% t # transform matrix from normal rgb to color-blind rgb
  
  # load data
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
  
  # convert 4d to 2d for transforming
  # if(dim(stadium)[4]==4){
  #   stadium = stadium[,,,1:3] #remove 4th column if present
  # }
  
  im_rgb = stadium[,,,1:3]
  
  row = dim(im_rgb)[1]
  col = dim(im_rgb)[2]
  im_rgb.flat = matrix(im_rgb, prod(row, col), dim(im_rgb)[3])
  im_rgb.2d = t(im_rgb.flat) # transpose to have columns as rgb
  # transform
  protan.2d = t(t_sim %*% im_rgb.2d) # transform back with transpose
  # back to image object for plotting
  protan.3d = array(protan.2d, c(row, col, 3))
  im_protan = imager::as.cimg(protan.3d, c(row, col, 3)) # back to image for plot
  
  if(plot == T){
    if(compare == T){
      graphics::par(mfrow=c(1,2)) 
      i1 = graphics::plot(im_protan, axes = F)
      i2 = graphics::plot(stadium, axes = F)}
    else(
      graphics::plot(im_protan, axes = F)
    )}
  
  return(im_protan)
}




#' create color palette from color-blind simulation images
#' 
#' This function reads an image from a specific location, can be url or local location.
#' It returns a palette f
#' @author Hiiiua
#' 
#' @param loc A string. A valid url or file for the image
#' @param mode A string.
#' @param threshold A number. Lower limit of color contrast
#' @param num.color An integer. Number of colors needed in the palette 
#' @param plot_palette T/F. Default TRUE to plot the generated palette.
#' @param plot_images T/F. Default FALSE not to plot the origin nor simulated color blind image. TRUE to plot both.
#' @returns A matrix. Hex codes of a palette and their rgb values.
#' 
#' @export
#' 
#' @examples 
#' color_blindness_palette(threshold = 0)
color_blindness_palette <- function(loc = 'stadium.rda', 
                                    mode = 'red', num.color = 5, threshold = 25,
                                    plot_palette = T, plot_images = F){
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
  
  simulate = Photopal::color_blindness_simulation(loc = loc, mode = mode,
                                                  compare = plot_images, plot = T)
  df.rgb = Photopal::cimg2rgb(simulate)
  palette = Photopal::palette_create(num.color = num.color, 
                                     df.rgb = df.rgb, threshold = threshold,
                                     plot = plot_palette)
  return(palette)
}


