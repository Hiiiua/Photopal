## ---------------------
##
## Script: Luminance Checker
## Purpose : Determine if luminance is high enough
##
## Author: C Bonk
##
## DOC: 2023/04/04
##
## ---------------------
## Notes
## Luminance is the 'brightness' of a color
## A contrast ratio is the luminance of a lighter color
## divided by luminance of the darker coloe.
## We are aiming for luminances at or above 4.5
## If a luminance is le 2.5, we need to throw a
## notice that color choices need to be fixed
## Also, try to include a way to find contrast
## ratio for multiple colors at once.
## ---------------------

# get_luminance Function - takes RGB values, returns Lum

get_luminance <- function(R,G,B){
  lum <- 0.2126*R + 0.7152*G + 0.0722*B
  return(lum)
}

## Testing get_luminance

image = load.image('https://topbrunchspots.com/wp-content/uploads/2022/05/AF1QipM-ql78yz46DGynt2tb1l7i8gK8zOAfN8dCQqiPw1600-h1000-k-no.jpeg')
df.rgb <- data.frame(red = as.vector(image[,,,1]),
                     green = as.vector(image[,,,2]),
                     blue = as.vector(image[,,,3]))
df.rgb$hex <- mapply(rgb, df.rgb[,'red'], df.rgb[,'green'], df.rgb[,'blue'])
trunc.rgb <- head(df.rgb,10)

trunc.rgb$lum <- mapply(get_luminance, trunc.rgb[,'red'],trunc.rgb[,'green'], trunc.rgb[,'blue'])


## get_contrast_ratio Function - takes vector of
## luminances and returns an nxn matrix of respective
## contrast ratios
## Q: How can we determine which color is darker?
## A: Lower Lum -> Darker. Also, if CR < 0.22222,
## inverse CR > 4.5 (so that also will be good)

get_contrast_ratio <- function(lum){
  lum.matrix <- matrix(lum, nrow=nrow(lum))
  lum.matrix[lower.tri(lum.matrix)] = t(lum.matrix)[lower.tri(lum.matrix)]
  return(lum.matrix)
}
get_contrast_ratio(trunc.rgb$lum)
m<- 'hi'
lm <-matrix(trunc.rgb$lum,nrow(trunc.rgb),nrow(trunc.rgb))
m[upper.tri(m)]=t(m)[upper.tri(m)]


# I am not sure we should use CIELab because...
plot(image)
plot(RGBtoLab(image))
# All of the colors get wacky.
