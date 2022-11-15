#' commpstatslib interactive_sampling() function
#' 
#' Interactive visualization to sample from a population and see how a given sampling statistic (theta) is distributed.
#' 
#' @param population A \code{vector} of values following any population distribution you wish to simulate.
#' @param sample_size The size of each sample to draw from the population
#' @param theta The \code{function} that computes the statistic of interest from each sample (e.g., \code{mean} or \code{median}).
#' 
#' @usage 
#' interactive_sampling()
#' 
#' After running, click on the gears in the top-left of the plotting area to draw more samples or change simulation parameters.
#'
#' @examples
#' \dontrun{
#' interactive_sampling(rnorm(100000))
#' 
#' interactive_sampling(c(rnorm(100000, mean = 4), rnorm(100000, mean=-4)), theta = median)
#' }
#' @export
interactive_sampling <- function(population, sample_size = 10, theta = mean) {
  plot_cache <- NULL

  manipulate::manipulate(
    plot_cache <- plot_sampling(population, sample_size, theta, reps,
                                vars = plot_cache, replot_population = FALSE),
    sample_size = manipulate::picker(10, 100, 500, 1000, 5000, 10000),
    reps = manipulate::picker(1, 5, 10, 50, 100),
    run = manipulate::button("Sample")
  )
  cat("Use the gears icon (top-left of plot) to draw another set of samples.\n")
  cat("Set the size of each of each sample (sample_size) drawn.\n")
  cat("Choose how many repetitions (reps) of each sample should be drawn.\n")
}
