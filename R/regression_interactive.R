#' interactive_regression() runs a regression simulation.
#' Click on the plotting area to add points and see a corresponding regression line
#'  (hitting ESC will stop the simulation). 
#'
#' You can supply the following parameter:
#'   old_pts - dataframe of x,y points to start interacting with
#'
#' You will also see three numbers: 
#'   intercept – where the regression line intercepts the y-axis
#'   regression coefficient – the slope of x on y
#'   correlation - correlation of x and y
#'   r-squared - R^2 of y
#'   
#' @export
interactive_regression <- function(points=data.frame(), ...) {
  cat("Click on the plot to create data points; hit [esc] to stop")
  repeat {
    plot_regr(points, ...)
    
    click_loc <- locator(1)
    if (is.null(click_loc)) break
    
    if(nrow(points) == 0 ) {
      points <- data.frame(x=click_loc$x, y=click_loc$y)
    } else {
      points <- rbind(points, c(click_loc$x, click_loc$y))
    }
  }
  
  return(points)
}

#'#' plot_regr(points) plots given points, regression line, stats
#'
#' params:
#'   points - dataframe of x,y points to plot
#'   
#' @export
plot_regr <- function(points, regression=TRUE, stats=TRUE) {
  max_x <- 50
  if (nrow(points) == 0) {
    plot(NA, xlim=c(-5,max_x), ylim=c(-5,max_x), xlab="x", ylab="y")
    return()
  }
  plot(points, xlim=c(-5,max_x), ylim=c(-5,max_x), pch=19, cex=2, col="gray")
  if (nrow(points) < 2) return()
  
  if (regression) {
    mean_x <- mean(points$x)
    mean_y <- mean(points$y)
    segments(0, mean_y, max_x, mean_y, lwd=1, col="lightgray", lty="dotted")
    segments(mean_x, 0, mean_x, mean_y, lwd=1, col="lightgray", lty="dotted")
    regr <- lm(points$y ~ points$x)
    abline(regr, lwd=2, col="cornflowerblue")
    
    if (stats) {  
      regr_summary <- summary(regr)
      ssr <- sum((regr$fitted.values - mean(points$y))^2)
      sse <- sum((points$y - regr$fitted.values)^2)
      sst <- sum((points$y - mean(points$y))^2)
      
      par(family="mono")
      legend("topleft", legend = c(
        paste(" Raw intercept: ", round(regr$coefficients[1], 2), "\n",
              "Raw slope    : ", round(regr$coefficients[2], 2), "\n",
              "Correlation  : ", round(cor(points$x, points$y), 2), "\n",
              "SSR          : ", round(ssr, 2), "\n",
              "SSE          : ", round(sse, 2), "\n",
              "SST          : ", round(sst, 2), "\n",
              "R-squared    : ", round(regr_summary$r.squared, 2))),
        bty="n")
      par(family="sans")
    }
  }
}
