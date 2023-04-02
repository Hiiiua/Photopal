#' A function read in an image from url, locally or default build-in image.
#' 
#' @param url A string. 
#' @importFrom imager load.image
#' @export
image2rgb <- function(url = paste('https://topbrunchspots.com', 
                                  '/wp-content/uploads/2022/05/AF1QipM',
                                  '-ql78yz46DGynt2tb1l7i8gK8zOAfN8dCQqiP',
                                  'w1600-h1000-k-no.jpeg', sep='')){
  if (length(url) > 0 ){
    image = imager::load.image(url)
  }
  else{
    image = load('../data/image.rda')
  }
  rgb_df = data.frame(red = as.vector(image[,,,1]),
                      green = as.vector(image[,,,2]),
                      blue = as.vector(image[,,,3]))
  return(rgb_df)
}

