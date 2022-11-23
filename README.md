
<!-- README.md is generated from README.Rmd. Please edit that file -->

# compstatslib

<!-- badges: start -->
<!-- badges: end -->

This R Package is a collection of interactive tools and helper functions
that help teachers and learners learn concepts in computational
statistics. Useful for homework, in-class demonstrations, or
self-learning.

## Major Functions

Three types of functions are made available:

- **Interactive functions** let you use your mouse and/or keyboard to
  interact with a visualization of a technique (e.g., regression, PCA)
- **Plot functions** functions produce plots of data, distributions, or
  particular statistical concepts (often a non-interactive counterpart
  to an interactive function)
- **Code functions** are provided as examples of code that one might
  want to see (they are executable, but the major value is in seeing
  their code)

### Statistical Tests

- `interactive_t_test()` Interactive visualization function that will
  show you a simulation of null and alternative distributions of the
  t-statistic. You will be able to play with the different parameters
  that affect hypothesis tests in order to see how their variation
  influences the null t and alternative t distributions, as well as
  statistical power.

### Statistical Sampling

- `interactive_sampling()` Interactive sampling simulation that will
  sample given population data to show how a sampling statistic is
  distributed across repetitions of sampling exercise.

### Linear Regression

- `interactive_regression()` Interactive visualization function that
  lets you point-and-click to add data points, while it automatically
  plots and updates a regression line and associated statistics.
- `plot_regr()` Non-interactive function that takes a dataframe of
  points (x, y) and plots them with a regression line and associated
  statistics.

### Logistic Regression

- `interactive_logit()` Interactive visualization function that lets you
  point-and-click to add data points, while it automatically plots and
  updates a logistic regression line and associated statistics.
- `plot_logit()` Non-interactive function that takes a dataframe of
  points (x, y) and plots them with a logistic regression curve and
  associated statistics.

### Principal Components Analysis

- `interactive_pca()` Interactive visualization function that lets you
  point-and-click to add data points, while it automatically plots and
  updates principal component vectors.

### Precision

- `machine_precision()` Code function that shows how to find the
  smallest number your computer can effectively represent

### Linear Algebra

- `interactive_matrix_inverse()` Interactive function that allows one to
  *manipulate* a matrix inversion.
- `plot_matrix_inverse()` Non-interactive plotting function that helps
  visualize an inverse.

## Installation

You can install the current development version from
[GitHub](https://github.com/) using the `devtools` package:

``` r
# install.packages("devtools")
devtools::install_github("soumyaray/compstatslib")
```

Feel free to send open issues or send pull requests. Happy hacking!
