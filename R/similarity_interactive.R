interactive_similarity <- function() {
  
  # Step 1: insert points
  
  
  # Step 2: interactive visualization
  manipulate::manipulate(
    plot_t_test(diff, sd, n, alpha),
    diff  = manipulate::slider(0, 4, step = 0.1, initial = 0.5),
    sd    = manipulate::slider(1, 5, step = 0.1, initial = 4),
    n     = manipulate::slider(2, 500, step = 1, initial = 100),
    alpha = manipulate::slider(0.01, 0.1, step = 0.01, initial = 0.05)
  )
}