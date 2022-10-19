#' @export
plot_logit <- function(points, regression=TRUE, stats=TRUE, min_x=0, max_x=50) {
  # Blank plotting figure if no data yet
  if (nrow(points) == 0) {
    plot_points_logit(NA)
    return()
  }
  
  # Plot points
  plot_points_logit(points)
  
  if (nrow(points) < 2) return()
  
  # Plot regression curve if requested
  if (regression) {
    suppressWarnings( # suppress "probabilities numerically 0 or 1 occurred"
      regr <- glm(y ~ x, data=points, family=binomial)
    )
    
    # Plot curve using predicted values based on model
    newdata <- data.frame(x=seq(min_x, max_x, len=500))
    newdata$y = predict(regr, newdata, type="response")
    lines(y ~ x, newdata, lwd=2, col="cornflowerblue")
    
    # Print stats on plot if requested    
    if (stats) {  
      # regr_summary <- summary(regr)
      # ssr <- sum((regr$fitted.values - mean(points$y))^2)
      # sse <- sum((points$y - regr$fitted.values)^2)
      # sst <- sum((points$y - mean(points$y))^2)
      
      # par(family="mono")
      # legend("topleft", legend = c(
      #   paste(" Raw intercept: ", round(regr$coefficients[1], 2), "\n",
      #         "Raw slope    : ", round(regr$coefficients[2], 2), "\n",
      #         "Correlation  : ", round(cor(points$x, points$y), 2), "\n",
      #         "SSR          : ", round(ssr, 2), "\n",
      #         "SSE          : ", round(sse, 2), "\n",
      #         "SST          : ", round(sst, 2), "\n",
      #         "R-squared    : ", round(regr_summary$r.squared, 2))),
      #   bty="n")
      # par(family="sans")
    }
  }
}

plot_points_logit <- function(points, min_x=0, max_x=50) {
  plot(points, xlim=c(min_x, max_x), ylim=c(0, 1), 
       xlab="x", ylab="y", pch=19, cex=2, col="gray")

  abline(h=0.5, lwd=1, col="lightgray", lty="dotted")
}