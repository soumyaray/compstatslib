#' compstatslib plot_logit() function
#'
#' @export
plot_logit <- function(points, formula = y ~ x, regression = TRUE, stats = TRUE,
                       min_x = 0, max_x = 50, legend_loc = "topleft") {
  # Blank plotting figure if no data yet
  if (nrow(points) == 0) {
    plot_points_logit(NA, min_x, max_x)
    return()
  }

  y_name <- formula[[2]] |> as.character()
  x_name <- formula[[3]] |> as.character()
  if (nrow(points) > 0) max_x <- max(max_x, points[[x_name]])

  # Plot points
  plot_points_logit(points, min_x, max_x)

  if (nrow(points) < 2) return()

  # Plot regression curve if requested
  if (regression) {
    suppressWarnings( # suppress "probabilities numerically 0 or 1 occurred"
      regr <- glm(formula, data = points, family = binomial)
    )

    # Plot curve using predicted values based on model
    newdata <- data.frame(x = seq(min_x, max_x, len = 500))
    names(newdata) <- x_name
    newdata[[y_name]] <- predict(regr, newdata, type = "response")
    lines(formula, newdata, lwd = 2, col = "cornflowerblue")

    # Print stats on plot if requested
    if (stats) {
      regr_summary <- summary(regr)

      par(family = "mono")
      legend(legend_loc, legend = c(
        paste("Intercept  : ", round(regr$coefficients[1], 2), "\n",
              "Coefficient: ", round(regr$coefficients[2], 2), "\n",
              "AIC        : ", round(regr_summary$aic, 2), sep = "")),
        bty = "n")
      par(family = "sans")
    }
  }
}

plot_points_logit <- function(points, min_x = 0, max_x = 50) {
  plot(points, xlim = c(min_x, max_x), ylim = c(0, 1),
       xlab = "x", ylab = "y", pch = 19, cex = 2, col = "gray")

  abline(h = 0.5, lwd = 1, col = "lightgray", lty = "dotted")
}
