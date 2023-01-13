#' compstatslib interactive_t_test() function
#' 
#' Interactive visualization function that allows one to *manipulate* the parameters that affect hypothesis testing in order to see how their variation influences the null t and alternative t distributions, and statistical power.
#' 
#' @param diff The test difference.
#' @param sd Population standard deviation.
#' @param n Sample size.
#' @param alpha Significance level.
#' 
#' @usage 
#' interactive_t_test()
#' 
#' One can click on the gear icon on the top-left corner of the plotting area to open the parameter settings.
#' The movement of the alternative t-statistics distribution with respect to the null distribution will be visible, as well as the consequent change in statistical power.
#' 
#' @seealso \code{\link{plot_t_test}}
#' 
#' @export
interactive_t_test <- function() {
  manipulate::manipulate(
    plot_t_test(diff, sd, n, alpha, error_matrix),
    diff  = manipulate::slider(0, 4, step = 0.1, initial = 0.5),
    sd    = manipulate::slider(1, 5, step = 0.1, initial = 4),
    n     = manipulate::slider(2, 500, step = 1, initial = 100),
    alpha = manipulate::slider(0.01, 0.1, step = 0.01, initial = 0.05),
    error_matrix = manipulate::checkbox(initial = FALSE, label = "Error Matrix")
  )
}
