#' compstatslib plot_sim() function
#'
#' @param points 
#'
#' @return
#' @export
#'
#' @examples
plot_sim <- function(points) {
  max_x <- 50
  if (nrow(points) == 0) {
    plot(NA, xlim=c(-5,max_x), ylim=c(-5,max_x), xlab="x", ylab="y")
    return()
  }
  plot(points, xlim=c(-5,max_x), ylim=c(-5,max_x), pch=19, cex=2, col="gray")
  arrows(x0 = 0, y0 = 0, x1 = points[, 1], y1 = points[, 2], col = "cornflowerblue")
  
  if (nrow(points) < 2) return()

}
