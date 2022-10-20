#' compstatslib interactive_regression() function
#' 
#' Interactive visualization function that lets you point-and-click to add data points, while it automatically plots and updates a regression line and associated statistics.
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
#' @param points A dataframe containing coordinates for estimating the regression. 
#' @param ... Further arguments passed to or from other methods.
#' 
#' @return A dataframe containing the points coordinates. Additionally, the following parameters are provided on the plot area:
#'  \item{Raw intercept}{The y-coordinate at which the regression line crosses the y-axis.}
#'  \item{Raw slope}{The value of the slope parameter.}
#'  \item{Correlation}{The strength of the linear relationship.}
#'  \item{SSR}{The sum of squares regression.}
#'  \item{SSE}{The sum of squares error.}
#'  \item{SST}{The sum of squares total.}
#'  \item{R-squared}{The multiple coefficient of determination.}
#' 
#' @usage 
#' interactive_regression(points, ...)
#' 
#' Click on the plotting area to add points and see a corresponding regression line (hitting ESC will stop the simulation).
#'
#' @seealso \code{\link{plot_regr}}
#' 
#' @examples  
#' 
#' # Providing coordinates beforehand:
#' points <- data.frame(x = c(1, 4, 7), y = c(2, 5, 8))
#' 
#' interactive_regression(points)
#' 
#' # Selecting coordinates on the plot area:
#' interactive_regression()
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
