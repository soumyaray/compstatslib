#' @export
interactive_sampling <- function(population, sample_size = 10, theta = mean) {
  # plot_cache <- plot_sampling(population, sample_size, theta)
  plot_cache <- NULL

  manipulate::manipulate(
    plot_cache <- plot_sampling(population, sample_size, theta, reps, vars = plot_cache),
    sample_size = manipulate::picker(10, 100, 500, 1000, 5000, 10000),
    reps = manipulate::picker(1, 5, 10, 50, 100),
    run = manipulate::button("Sample")
  )
}

plot_sampling <- function(population, sample_size,
                          theta, reps = 1, vars = NULL) {
  if (!is.null(vars)) {
    xmin <- vars$xmin
    xmax <- vars$xmax
    sample_means <- vars$sample_means
  } else {
    xmin <- min(population)
    xmax <- max(population)
    sample_means <- c()
  }

  old_par <- par(mfrow = c(3, 1))

  # population_sample <- sample(population, sample_size)
  samples <- replicate(reps, sample(population, sample_size))
  means <- apply(samples, FUN = theta, MARGIN = 2)
  sample_means <- append(sample_means, means)

  # TODO: skip population plot if plotting again?
  plot(density(population),
       xlim = c(xmin, xmax), xaxt = "n", frame = FALSE)
  axis(1)


  plot(density(samples),
               xlim = c(xmin, xmax), xaxt = "n", frame = FALSE)
  axis(1)

  if (length(sample_means) < 3) { breaks <- "Sturges" } else { breaks <- "FD" }

  hist(sample_means, breaks = breaks, xlim = c(xmin, xmax), xaxt = "n")
  axis(1)

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

# population = rnorm(1000000)
