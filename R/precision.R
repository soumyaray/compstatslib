#' Reports smallest possible number on machine such that 1 + x != 1
#' 
#' @export
machine_precision <- function() {
  .Machine$double.eps
}
