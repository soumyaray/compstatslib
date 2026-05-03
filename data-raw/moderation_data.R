# Synthetic moderation dataset for compstatslib teaching examples.
#
# Calibrated to show a clear interaction (moderation) effect when visualised
# as a 3D wireframe surface. Bundled as `moderation_data` and used as the
# default for plot_moderation_3d() and interactive_moderation_3d() so that
# running them with no arguments produces a working classroom demonstration.
#
# Re-generate with: source("data-raw/moderation_data.R")

set.seed(42)
n <- 200

x <- rnorm(n, mean = 0, sd = 2)
z <- rnorm(n, mean = 0, sd = 2)
y <- 0.5 * x + 0.3 * z + 0.8 * x * z + rnorm(n, sd = 1)

# `w` is an unrelated noise variable. Drawn independently of x, z, and y;
# any correlation with y is spurious. Useful for showing students that
# adding irrelevant predictors does not change the IV/mod surface and
# for demonstrating the multi-predictor `iv`/`mod` arguments.
w <- rnorm(n, mean = 0, sd = 2)

moderation_data <- data.frame(y = y, x = x, z = z, w = w)

usethis::use_data(moderation_data, overwrite = TRUE)
