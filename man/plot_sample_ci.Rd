% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sample_ci_plot.R
\name{plot_sample_ci}
\alias{plot_sample_ci}
\title{compstatslib plot_sample_ci() function}
\usage{
plot_sample_ci()
}
\arguments{
\item{num_samples}{Number of the samples to draw from the population.}

\item{sample_size}{Size of each sample drawn from the population.}

\item{pop_size}{Size of the overall population to simulate.}

\item{distr_func}{Random data generation function to simulate the population 
data (e.g., \code{rnorm} or \code{runif}).}

\item{...}{Parameters to pass to the \code{distr_func} function specified.}
}
\description{
Visualize the confidence intervals of samples drawn from a population.
}
\examples{
\dontrun{
plot_sample_ci(sample_size=300, distr_func=rnorm, mean=50, sd=10)
plot_sample_ci(sample_size=300, distr_func=runif, min=17, max=35)
}

}
