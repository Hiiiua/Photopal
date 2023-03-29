
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Photopal

<!-- badges: start -->

[![R-CMD-check](https://github.com/Hiiiua/Photopal/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Hiiiua/Photopal/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

The goal of Photopal is to generate palettes from photos.

## Installation

You can install the development version of Photopal from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Hiiiua/Photopal")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(Photopal)
## basic example code
```

## Documentation

[Photopal](https://hiiiua.github.io/Photopal/)

### Brainstorm ideas

-   palette_discrete()

    -   threshold for distance.
    -   <https://rdrr.io/cran/imager/man/imager.colourspaces.html>  
        Look into CIELab space, probably able to use one of these
        converting functions from `imager`

-   palette_continuous()

    -   Look into color theories to see if we can extend the color
        range.  
    -   Warning of not recommending continuous color palette

-   palette_convert_cb(): convert to color-blind safe palette

    -   An argument to choose the color blindness kind.

-   use the original photo and overlay a 3D heatmap that shows which
    areas of the image has the highest intensities of colors from the
    generated palette

    -   Show intensity of one of the colors from generated palette.

-   interaction: showing or saving the hex color code with
    pointing/clicking (maybe Shiny/plotly)

-   palette optimizer function: given a palette, we make it better
