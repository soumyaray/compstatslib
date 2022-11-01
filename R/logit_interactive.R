#' @export
interactive_logit <- function(points = data.frame(), formula = y ~ x,
                              min_x = 0, max_x = 50, ...) {
  cat("Click on the plot to create data points; hit [esc] to stop")

  y_name <- formula[[2]] |> as.character()
  x_name <- formula[[3]] |> as.character()

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
