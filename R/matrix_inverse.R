#' Interactive demonstration of matrix determinants
#' Inspired by: https://math.stackexchange.com/questions/295250/geometric-interpretations-of-matrix-inverses/1922830#1922830?newreg=d55776428dd2418e8a6a971dfdbfa17
#' 
#' @export
interactive_matrix_inverse <- function(x1_init=1, y1_init=2, x2_init=2, y2_init=1) {
  library(manipulate)
  
  manipulate(visualize_inverse(x1, y1, x2, y2),
             x1 = slider(min=-2, max=2, initial=x1_init, step=0.1),
             y1 = slider(min=-2, max=2, initial=y1_init, step=0.1),
             x2 = slider(min=-2, max=2, initial=x2_init, step=0.1),
             y2 = slider(min=-2, max=2, initial=y2_init, step=0.1))
}

#' @export
visualize_inverse <- function(x1, y1, x2, y2) {
  A <- matrix(c(x1, y1, x2, y2), nrow = 2)
  Ainv <- solve(A)
  
  A_col <- rgb(1, 0, 0, 0.1)
  Ainv_col <- rgb(0, 0, 1, 0.1)
  
  plot(NA, xlim=c(-3, 3), ylim=c(-3,3), frame.plot = FALSE)
  plot_matrix_det(A, A_col)
  plot_matrix_det(Ainv, Ainv_col)
}

plot_matrix_det <- function(M, col) {
  polygon(c(0,M[1,1], M[1,1]+M[1,2], M[1,2]), 
          c(0,M[2,1], M[2,1]+M[2,2], M[2,2]), 
          col=col, border=rgb(0,0,0,0.3))
  
  arrows(0, 0, M[1,1], M[2,1])
  arrows(0, 0, M[1,2], M[2,2])
}