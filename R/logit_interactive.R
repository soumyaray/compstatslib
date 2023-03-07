#' compstatslib interactive_logit() function
#'
#' Interactive visualization function that lets you point-and-click to add
#' data points, while it automatically plots and updates a logistic regression
#' curve and associated statistics.
#'
#' @param points An optional \code{dataframe} of x and y points to plot
#' and estimate the regression.
#' If no \code{points} are provided, the user is free to click and create points
#' on the plot area.
#'
#' @param formula A \code{formula} to use in estimating logit
#' (e.g., \code{y ~ x}).
#'
#' @param ... Further arguments passed to the \code{plot_logit()} function that
#' produces the plot.
#'
#' @return A \code{dataframe} containing the points coordinates.
#'
#' @usage
#' interactive_regression(points, ...)
#'
#' *Click on the plotting area to add points and see a corresponding regression
#' curve (hitting ESC will stop the simulation).*
#'
#' @seealso \code{\link{plot_regr}}
#'
#' @examples
#' # Selecting coordinates on the plot area, storing them in 'pts'
#' pts <- interactive_logit()
#'
#' # Replotting the points stored earlier in 'pts', allowing the user to
#' # continue the interactive regression
#' interactive_logit(pts)
#'
#' # Providing coordinates beforehand
#' pts <- data.frame(in = c(1, 4, 7, 10), out = c(0, 0, 1, 1))
#' interactive_regression(pts, formula = out ~ in)
#'
#' @export
interactive_logit <- function(points = data.frame(), formula = y ~ x,
                              min_x = 0, max_x = 50, ...) {
  cat("Click on the plot to create data points; hit [esc] to stop")

  y_name <- as.character(formula[[2]])
  x_name <- as.character(formula[[3]])

  if (nrow(points) > 0) max_x <- max(max_x, points[[x_name]])

  repeat {
    plot_logit(points = points, formula = formula,
               min_x = min_x, max_x = max_x, ...)

    click_loc <- locator(1)
    if (is.null(click_loc)) break

    click_x <- max(0, min(max_x, click_loc$x)) # clamp x within 0..max_x
    click_y <- round(click_loc$y) # binarize y

    new_pt <- data.frame(click_x, click_y)
    names(new_pt) <- c(x_name, y_name)

    if (nrow(points) == 0) {
      points <- new_pt
    } else {
      points <- rbind(points, new_pt)
    }
  }

  return(points)
}
