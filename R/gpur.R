## Demos power of GPU at matrix multiplication
gpu_demo <- function() {
  library(gpuR)
  
  ORDER = 2000
  
  A = matrix(rnorm(ORDER^2), nrow=ORDER)
  B = matrix(rnorm(ORDER^2), nrow=ORDER)
  
  bench_matrix_mult <- function(A, B) {
    for(i in 1:3) {
      A %*% B
    }
  }
  
  system.time(bench_matrix_mult(A, B))
  # user  system elapsed 
  # 3.187   0.020   3.215  
  
  gpuA = gpuMatrix(A, type="float")
  gpuB = gpuMatrix(B, type="float")
  
  system.time(bench_matrix_mult(gpuA, gpuB))
  # user  system elapsed 
  # 0.073   0.046   0.253 
}