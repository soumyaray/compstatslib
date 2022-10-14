#' @export
interactive_pca <- function(meancenter = TRUE) {
  cat("Click on the plot to create data points; hit [esc] to stop")
  
  old_par <- par(no.readonly = TRUE)
  par(pty='s')
  plot(NA, xlim=c(-50,50), ylim=c(-50,50), asp=1)
  points = data.frame()
  
  repeat {
    click_loc <- locator(1)
    if (is.null(click_loc)) break
    # z <- rnorm(1)
    
    if(nrow(points) == 0 ) {
      # points <- data.frame(x=click_loc$x, y=click_loc$y, z=z)
      points <- data.frame(x=click_loc$x, y=click_loc$y)
    } else {
      # points <- rbind(points, c(click_loc$x, click_loc$y, z))
      points <- rbind(points, c(click_loc$x, click_loc$y))
    }
    
    # mean-center points
    if (meancenter && nrow(points) > 1) {
      mc_diff <- sapply(points, mean)
      mc_points <- sweep(points, 2, mc_diff)
    } else {
      mc_diff <- c(x=0, y=0)
      mc_points <- points
    }
    
    # Plot points
    plot(points[c("x", "y")], xlim=c(-50,50), ylim=c(-50,50), pch=19, cex=2, col="gray")
    
    # Plot PC vectors
    if (nrow(points) >= 3) {
      pca <- prcomp(mc_points, scale. = FALSE)
      egvec <- pca$rotation[, c('PC1', 'PC2')]  # eigenvectors
      sv <- pca$sdev[1:2]                       # singular values
      vec <- egvec %*% diag(sv)                 # scale vectors up proportionally
      rownames(vec) <- c('x', 'y')
      colnames(vec) <- c('PC1', 'PC2')
      
      arrows( -vec['x',]+mc_diff['x'], -vec['y',]+mc_diff['y'], 
               vec['x',]+mc_diff['x'],  vec['y',]+mc_diff['y'], 
               lty=c("solid", "dotted"), length = 0.1)
    }
  }
  
  par(old_par)
  
  return(list(
    points = points,
    pca = pca
  ))
}
