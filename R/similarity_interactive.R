#' compstatslib interactive_similarity() function
#'
#' @return
#' @export
#'
#' @examples
interactive_similarity <- function(points=data.frame(), ...) {
    cat("Click on the plot to create data points; hit [esc] to stop")
    repeat {
      plot_sim(points, ...)
      
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
