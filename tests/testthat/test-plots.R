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

# Inverse matrix plotting
test_that("Plotting matrix inverse should not produce errors", {
  expect_error(
    plot_matrix_inverse(1, 2, 2, 1), NA)
})

# PCA plotting
test_that("Plotting PCA with no points should not produce errors", {
  expect_error(plot_pca(), NA)
})

test_that("Plotting PCA with 2 points should not produce errors", {
  points <- data.frame(x = c(1, 2), y = c(3, 4))
  expect_error(plot_pca(points), NA)
})

test_that("Plotting PCA with 3+ points should return prcomp result", {
  points <- data.frame(x = c(1, 2, 3, 4), y = c(2, 4, 5, 8))
  result <- plot_pca(points)
  expect_s3_class(result, "prcomp")
})

# 3D moderation plotting
test_that("Plotting 3D moderation with defaults should not produce errors", {
  expect_error(plot_moderation_3d(), NA)
})

test_that("Plotting 3D moderation with additive formula should not error", {
  expect_error(plot_moderation_3d(y ~ x + z, moderation_data), NA)
})

test_that("Plotting 3D moderation with custom column names should not error", {
  set.seed(1)
  df <- data.frame(
    out  = rnorm(50),
    pred = rnorm(50),
    modr = rnorm(50)
  )
  expect_error(plot_moderation_3d(out ~ pred * modr, df), NA)
})

test_that("Plotting 3D moderation returns a trellis object", {
  result <- plot_moderation_3d()
  expect_s3_class(result, "trellis")
})

test_that("Plotting 3D moderation with explicit zlim should not error", {
  expect_error(plot_moderation_3d(zlim = c(-5, 10)), NA)
})

test_that("Plotting 3D moderation with multi-predictor formula and explicit iv/mod", {
  set.seed(2)
  df <- data.frame(
    y  = rnorm(60),
    a  = rnorm(60),
    b  = rnorm(60),
    c  = rnorm(60),
    d  = rnorm(60)
  )
  expect_error(
    plot_moderation_3d(y ~ a + b + c + d + c:d, df, iv = "c", mod = "d"),
    NA
  )
})

test_that("Plotting 3D moderation with bundled data and `w` covariate works", {
  expect_error(
    plot_moderation_3d(y ~ x + z + w + x:z, moderation_data,
                       iv = "x", mod = "z"),
    NA
  )
})

test_that("Plotting 3D moderation emits a hold-out note when extra predictors present", {
  expect_message(
    plot_moderation_3d(y ~ x + z + w + x:z, moderation_data,
                       iv = "x", mod = "z"),
    "held at their typical values"
  )
})

test_that("Plotting 3D moderation is silent when only IV and moderator are present", {
  expect_no_message(
    plot_moderation_3d(y ~ x * z, moderation_data)
  )
})

test_that("Plotting 3D moderation rejects categorical variable on a plot axis", {
  set.seed(6)
  df <- data.frame(
    y     = rnorm(40),
    iv    = rnorm(40),
    group = factor(sample(c("ctrl", "treat"), 40, replace = TRUE))
  )
  expect_error(
    plot_moderation_3d(y ~ iv * group, df),
    "does not support categorical"
  )
})

test_that("Plotting 3D moderation with multi-predictor formula errors when iv/mod missing", {
  set.seed(3)
  df <- data.frame(
    y = rnorm(40), a = rnorm(40), b = rnorm(40), c = rnorm(40)
  )
  expect_error(
    plot_moderation_3d(y ~ a + b + c, df),
    "must specify"
  )
})

test_that("Plotting 3D moderation errors when iv name not in formula predictors", {
  set.seed(4)
  df <- data.frame(
    y = rnorm(40), a = rnorm(40), b = rnorm(40), c = rnorm(40)
  )
  expect_error(
    plot_moderation_3d(y ~ a + b + c, df, iv = "q", mod = "b"),
    "not a predictor"
  )
})

test_that("Plotting 3D moderation holds factor covariate at first level", {
  set.seed(5)
  df <- data.frame(
    y     = rnorm(80),
    iv    = rnorm(80),
    mod   = rnorm(80),
    group = factor(sample(c("ctrl", "treat"), 80, replace = TRUE))
  )
  expect_error(
    plot_moderation_3d(y ~ group + iv + mod + iv:mod, df,
                       iv = "iv", mod = "mod"),
    NA
  )
})

unlink("Rplots.pdf")
