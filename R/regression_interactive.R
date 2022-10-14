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
