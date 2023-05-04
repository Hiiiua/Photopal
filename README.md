
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Photopal

<!-- badges: start -->

[![R-CMD-check](https://github.com/Hiiiua/Photopal/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Hiiiua/Photopal/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/Hiiiua/Photopal/branch/main/graph/badge.svg)](https://app.codecov.io/gh/Hiiiua/Photopal?branch=main)
<!-- badges: end -->

The goal of Photopal is to generate palettes from photos.

## Installation

You can install the development version of Photopal from
[GitHub](https://github.com/Hiiiua/Photopal) with:

``` r
# install.packages("devtools")
devtools::install_github("Hiiiua/Photopal")
```

## Example

To create a palette from the internal data

``` r
library(Photopal)
# get the data ready in 2d dataframe with columns of red, green and blue
df.rgb = image2rgb()
# create a palette of 5 colors regardless the similarity
palette = palette_create(num.color = 5, df.rgb, threshold = 0, plot = T)
```

To simulate an image with blue color deficiency

``` r
blue_simulation = color_blindness_simulation(mode = "blue", plot = T)
```

To create a palette for people with blue color deficiency

``` r
simulated_palette = Photopal::color_blindness_palette(mode = 'blue',threshold = 0, plot_images = T)
```

## Website

[Photopal](https://hiiiua.github.io/Photopal/)

### To be implemented ideas

-   palette_continuous()

    -   Look into color theories to see if we can extend the color
        range.  
    -   Warning of not recommending continuous color palette

-   use the original photo and overlay a 3D heatmap that shows which
    areas of the image has the highest intensities of colors from the
    generated palette

    -   Show intensity of one of the colors from generated palette.

-   interaction: showing or saving the hex color code with
    pointing/clicking (maybe Shiny/plotly)

-   palette optimizer function

-   more on color blindness

-   extending a palette
