% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rgb.R
\name{color_blindness_palette}
\alias{color_blindness_palette}
\title{create color palette from color-blind simulation images}
\usage{
color_blindness_palette(
  loc = "stadium.rda",
  mode = "red",
  num.color = 5,
  threshold = 25,
  plot_palette = T,
  plot_images = F
)
}
\arguments{
\item{loc}{A string. A valid url or file for the image}

\item{mode}{A string.}

\item{num.color}{An integer. Number of colors needed in the palette}

\item{threshold}{A number. Lower limit of color contrast}

\item{plot_palette}{T/F. Default TRUE to plot the generated palette.}

\item{plot_images}{T/F. Default FALSE not to plot the origin nor simulated color blind image. TRUE to plot both.}
}
\value{
A matrix. Hex codes of a palette and their rgb values.
}
\description{
This function reads an image from a specific location, can be url or local location.
It returns a palette f
}
\examples{
color_blindness_palette(threshold = 0)
}
\author{
Hiiiua
}
