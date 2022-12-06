interactive_similarity <- function() {
  
  # Step 1: insert points
  function(points=data.frame(), ...) {
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
  
  # Step 2: interactive visualization
  manipulate::manipulate(
    plot_t_test(diff, sd, n, alpha),
    diff  = manipulate::slider(0, 4, step = 0.1, initial = 0.5),
    sd    = manipulate::slider(1, 5, step = 0.1, initial = 4),
    n     = manipulate::slider(2, 500, step = 1, initial = 100),
    alpha = manipulate::slider(0.01, 0.1, step = 0.01, initial = 0.05)
  )
}