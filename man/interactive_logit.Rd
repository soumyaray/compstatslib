% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/logit_interactive.R
\name{interactive_logit}
\alias{interactive_logit}
\title{compstatslib interactive_logit() function}
\usage{
interactive_regression(points, ...)

*Click on the plotting area to add points and see a corresponding regression
curve (hitting ESC will stop the simulation).*
}
\arguments{
\item{points}{An optional \code{dataframe} of x and y points to plot
and estimate the regression.
If no \code{points} are provided, the user is free to click and create points
on the plot area.}

\item{formula}{A \code{formula} to use in estimating logit
(e.g., \code{y ~ x}).}

\item{...}{Further arguments passed to the \code{plot_logit()} function that
produces the plot.}
}
\value{
A \code{dataframe} containing the points coordinates.
}
\description{
Interactive visualization function that lets you point-and-click to add
data points, while it automatically plots and updates a logistic regression
curve and associated statistics.
}
\examples{
# Selecting coordinates on the plot area, storing them in 'pts'
pts <- interactive_logit()

# Replotting the points stored earlier in 'pts', allowing the user to
# continue the interactive regression
interactive_logit(pts)

# Providing coordinates beforehand
mydata <- data.frame(in = c(1, 4, 7, 10), out = c(0, 0, 1, 1))
interactive_regression(mydata, formula = out ~ in)

}
\seealso{
\code{\link{plot_regr}}
}
