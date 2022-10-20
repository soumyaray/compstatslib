#' compstatslib machine_precision() function
#' 
#' 
#' Code function that reports the smallest possible number on the user's machine such that 1 + x != 1.
#' 
#' @return A numeric value representing the smalles possible number that the user's computer can effectively represent.
#' 
#' @usage 
#' machine_precision()
#' 
#' @export
machine_precision <- function() {
  .Machine$double.eps
}
