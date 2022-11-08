#' @example
#' # pop = rnorm(100000)
#' # interactive_sampling(pop)
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
  cat("finished")
}

plot_sampling <- function(population, sample_size, theta, reps = 1,
                          vars = NULL, replot_population = TRUE) {
  if (!is.null(vars)) {
    xmin <- vars$xmin
    xmax <- vars$xmax
    sample_means <- vars$sample_means
  } else {
    xmin <- min(population)
    xmax <- max(population)
    sample_means <- c()
  }

  # Preplotting computations needed on each plot
  samples <- replicate(reps, sample(population, sample_size))
  means <- apply(samples, FUN = theta, MARGIN = 2)
  sample_means <- append(sample_means, means)
  popd <- density(population)
  samd <- density(samples)

  old_par <- par(mfrow = c(3, 1), mar=c(2, 2, 1, 1), cex=0.5)

  plot(popd, lty = "dotted", lwd = 2, xlim = c(xmin, xmax), xaxt = "n",
       yaxt = "n", frame = FALSE, main = NA)
  axis(1)
  text(xmin, max(popd$y)/2, boldly("Population Distribution"), adj = 0)

  plot(samd, lty = "solid", lwd = 2, xlim = c(xmin, xmax), xaxt = "n",
       yaxt = "n", frame = FALSE, main = NA)
  axis(1)
  text(xmin, max(samd$y)/2, boldly("Sample Distribution"), adj = 0)

  # TODO: all user to fix bin size
  # TODO: use some fraction of population hist height
  # if (length(sample_means) < 3) { breaks <- "Sturges" } else { breaks <- "FD" }
  samh <- hist(sample_means, border = FALSE,
               xlim = c(xmin, xmax), xaxt = "n", yaxt = "n", main = NA)
  axis(1)
  means_count <- paste("Sampling Means", "\n(", length(sample_means), ")")
  text(xmin, max(samh$counts)/2, means_count, adj = 0)

  par(old_par)

  vars <- list(
    population = population,
    xmin = xmin,
    xmax = xmax,
    sample_size = sample_size,
    theta = theta,
    sample_means = sample_means
  )

  class(vars) <- append(class(vars), c("compstats", "sampling"))

  vars
}

boldly <- function(str) {
  substitute(paste(bold(str)))
}
