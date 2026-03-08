# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package Overview

`compstatslib` is an educational R package providing interactive visualizations and plotting functions for teaching computational statistics concepts. It uses base R graphics and the `manipulate` package for interactivity within RStudio.

## Build & Development Commands

```r
devtools::load_all()      # Load package for development
devtools::document()      # Regenerate NAMESPACE and man/*.Rd from roxygen2 comments
devtools::test()          # Run testthat suite
devtools::check()         # Full R CMD check
```

Run a single test file:
```r
testthat::test_file("tests/testthat/test-plots.R")
```

Install from GitHub:
```r
devtools::install_github("soumyaray/compstatslib")
```

## Architecture

Functions follow a paired pattern: **interactive** + **plot** versions.

- **Interactive functions** (`*_interactive.R`): Use `manipulate::manipulate()` for sliders/pickers and `locator()` for mouse-click data entry. These only work in RStudio.
- **Plot functions** (`*_plot.R`): Standalone visualization functions that accept data and parameters directly. These are the testable, non-interactive counterparts.

Current function pairs: regression, logit, t-test, sampling, sample CI, matrix inverse, PCA.

Standalone utility: `precision.R` (machine precision demonstration).

## Key Conventions

- **R >= 4.0.0** required. Do NOT use native pipe `|>` (requires R 4.1+); use `%>%` or nested calls instead.
- **Base R graphics only** — no ggplot2.
- **roxygen2** generates all documentation: never edit `NAMESPACE` or `man/*.Rd` files directly.
- **testthat edition 3** for tests.
- Build options: `--no-multiarch --with-keep.source`

## Git Workflow

- **main**: release branch
- **develop**: active development branch
- Feature branches branch from and merge back to `develop`
