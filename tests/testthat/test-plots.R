# Linear regression plotting
test_that("Plotting regression points should not produce errors", {
  x <- runif(20) * 50
  y <- (0.5 * x) + rnorm(20)
  points <- data.frame(x, y)
  expect_error(plot_regr(points), NA)
})

# t-test plotting
test_that("Plotting t-test visualization should not produce errors", {
  expect_error(plot_t_test(), NA)
})

# Logit plotting
test_that("Plotting logit points called (x, y) should not produce errors", {
  x <- runif(20) * 50
  y <- sample(c(0, 1), 20, replace=TRUE)
  points <- data.frame(x, y)
  expect_error(plot_logit(points), NA)
})

test_that("Plotting logit points called (ant, out) should not produce errors", {
  ant <- runif(20) * 50
  out <- sample(c(0, 1), 20, replace=TRUE)
  points <- data.frame(out, ant)
  expect_error(plot_logit(points, formula = out ~ ant), NA)
})

# Sampling plotting
test_that("Plotting sampling simulation should not produce errors", {
  expect_error(
    plot_sampling(rnorm(100000), sample_size = 100, reps = 50, theta = median),
    NA)
})

unlink("Rplots.pdf")
