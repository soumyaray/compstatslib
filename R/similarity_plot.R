#' compstatslib plot_sim() function
#'
#' @param points 
#'
#' @return
#' @export
#'
#' @examples
plot_sim <- function(points) {
  max_x <- 5
  if (nrow(points) == 0) {
    plot(NA, xlim=c(0,max_x), ylim=c(0,max_x), xlab="ac1", ylab="ac2")
    return()
  }
  plot(points, xlim=c(0,max_x), ylim=c(0,max_x), pch=19, cex=2, col="gray")
  arrows(x0 = 0, y0 = 0, x1 = points[, 1], y1 = points[, 2], col = "cornflowerblue")

  if (nrow(points) < 2) return()

  data_matrix <- as.matrix(points)
  
  recommend(data_matrix)
}

recommend <- function(data_matrix) {
  cosines <- cosine(data_matrix)
  
  data_transpose <- t(data_matrix)
  
  data_means <- apply(data_transpose, 2, mean)
  data_means_matrix <- t(replicate(nrow(data_matrix), data_means))
  data_means_matrix_mc <- data_transpose - data_means_matrix
  
  cors <- cosine(data_means_matrix_mc)
  
  c(cosines, cors)
}
