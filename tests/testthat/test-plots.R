# Linear regression plotting
test_that("Plotting regression points", {
  x <- runif(20) * 50
  y <- (0.5 * x) + rnorm(20)
  points <- data.frame(x, y)
  expect_error(plot_regr(points), NA)
})

# t-test plotting
test_that("Plotting t-test visualization", {
  expect_error(plot_t_test(), NA)
})

# Logit plotting
test_that("Plotting logit points called (x, y)", {
  x <- runif(20) * 50
  y <- sample(c(0, 1), 20, replace=TRUE)
  points <- data.frame(x, y)
  expect_error(plot_logit(points), NA)
})

test_that("Plotting logit points called (ant, out)", {
  ant <- runif(20) * 50
  out <- sample(c(0, 1), 20, replace=TRUE)
  points <- data.frame(out, ant)
  expect_error(plot_logit(points, formula = out ~ ant), NA)
})

unlink("Rplots.pdf")
