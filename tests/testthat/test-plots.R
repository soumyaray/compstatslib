test_that("Plotting regression points", {
  x <- runif(20) * 50
  y <- (0.5 * x) + rnorm(20)
  points <- data.frame(x, y)
  expect_error(plot_regr(points), NA)
})

test_that("Plotting t-test visualization", {
  expect_error(t_test_plot(), NA)
})

unlink("Rplots.pdf")