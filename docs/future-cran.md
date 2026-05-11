# Path to CRAN

Remaining work before `compstatslib` can be submitted to CRAN. Based on `R CMD check --as-cran` output and CRAN policy review as of v0.7.1.

## Blockers (CRAN will reject)

### 1. Missing `@examples` for six exported functions

CRAN expects runnable examples on every exported function. Most functions already have them (interactive functions correctly use `\dontrun{}`, plot functions have runnable examples). The following six are missing `@examples` blocks:

- `interactive_matrix_inverse`
- `interactive_pca`
- `interactive_t_test`
- `machine_precision`
- `plot_matrix_inverse`
- `plot_pca`

For the `interactive_*` functions, follow the existing pattern in `interactive_regression.R` (wrap in `\dontrun{}`). For the `plot_*` functions and `machine_precision`, write runnable examples.

## Strongly recommended (NOTEs CRAN may flag)

### 2. Undefined globals NOTE

R CMD check flags many base R functions as undefined globals: `rgb`, `glm`, `binomial`, `lines`, `par`, `legend`, `polygon`, `arrows`, `setNames`, `prcomp`, `abline`, `segments`, `cor`, `rnorm`, `sd`, `density`, `axis`, `text`, `hist`, `dt`, `qt`, `tail`, `points`, `pt`. Add `@importFrom` roxygen tags in each `R/*.R` file, or a single `R/imports.R` with all of them.

Suggested groupings:

- `grDevices`: `rgb`
- `graphics`: `abline`, `arrows`, `axis`, `hist`, `legend`, `lines`, `par`, `points`, `polygon`, `segments`, `text`
- `stats`: `binomial`, `cor`, `density`, `dt`, `glm`, `prcomp`, `pt`, `qt`, `rnorm`, `sd`, `setNames`
- `utils`: `tail`

## Nice-to-haves before submission

- Run `devtools::check_win_devel()` to check against R-devel on Windows.
- Run `devtools::spell_check()` — CRAN runs aspell on DESCRIPTION and Rd files.
- Confirm the `Authors@R` role `"ths"` (thesis advisor) is intentional. It is a valid MARC code but unusual for an R package; not a blocker.
- Consider adding a `cran-comments.md` for the submission.
- Verify the existing GitHub Actions R-CMD-check workflow runs cleanly on macOS, Windows, and Ubuntu against R-release and R-devel.

## Suggested sequencing

1. Add `@importFrom` tags (mechanical) and re-check.
2. Add `@examples` for the six functions missing them.
3. Run `devtools::check_win_devel()` and address any platform-specific issues.
4. Submit via `devtools::release()`.
