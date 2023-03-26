
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
-   palette_continuous()
-   palette_convert_cb(): convert to color-blind safe palette
-   use the original photo and overlay a 3D heatmap that shows which
    areas of the image has the highest intensities of colors from the
    generated palette
-   interaction: showing or saving the hex color code with
    pointing/clicking (maybe Shiny/plotly)
-   palette optimizer function: given a palette, we make it better
