#' @export
interactive_logit <- function(points=data.frame(), min_x=0, max_x=50, ...) {
  cat("Click on the plot to create data points; hit [esc] to stop")
  repeat {
    plot_logit(points, max_x, ...)
    
    click_loc <- locator(1)
    # browser()
    if (is.null(click_loc)) break
    
    click_x <- max(0, min(max_x, click_loc$x)) # clamp x within 0..max_x
    click_y <- round(click_loc$y) # binarize y
    
    if(nrow(points) == 0 ) {
      points <- data.frame(x=click_x, y=click_y)
    } else {
      points <- rbind(points, c(click_x, click_y))
    }
  }
  
  return(points)
}
