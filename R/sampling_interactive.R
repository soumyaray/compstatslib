#' @export
interactive_sampling <- function(population, sample_size = 10, theta = mean) {
  #   manipulate::manipulate(
  #     plot_t_test(diff, sd, n, alpha),
  #     diff  = manipulate::slider(0, 4, step = 0.1, initial = 0.5),
  #     sd    = manipulate::slider(1, 5, step = 0.1, initial = 4),
  #     n     = manipulate::slider(2, 500, step = 1, initial = 100),
  #     alpha = manipulate::slider(0.01, 0.1, step = 0.01, initial = 0.05)
  #   )

  plot_sampling(population, sample_size, theta)
  # manipulate::manipulate()
}

plot_sampling <- function(population = NA, sample_size = 10,
                          theta = mean, sample_means = c(), plot_vars = NA) {
  xmin <- min(population)
  xmax <- max(population)

  old_par <- par(mfrow = c(3, 1))

  plot(density(population),
       xlim = c(xmin, xmax), xaxt = "n", frame = FALSE)
  axis(1)

  population_sample <- sample(population, sample_size, )
  plot(density(population_sample),
               xlim = c(xmin, xmax), xaxt = "n", frame = FALSE)
  axis(1)

  sample_means <- append(sample_means, theta(population_sample))
  hist(sample_means, xlim = c(xmin, xmax), xaxt = "n")
  axis(1)

  par(old_par)
}

# population = rnorm(1000000)
