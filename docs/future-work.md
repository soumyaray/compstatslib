# Future work

Planning notes for features deferred from past branches. Each entry is a
seed, not a spec — flesh out before starting work.

## `plot_moderation()` — 2D companion to `plot_moderation_3d()`

### Motivation

`plot_moderation_3d()` requires both the IV and the moderator to be
numeric. Categorical (especially binary) moderators are common in the
applied literature — treatment vs. control, male vs. female, before vs.
after — and the standard textbook visualization for them is a 2D plot
with one regression line per moderator level on shared axes. Adding a
2D companion lets the package cover both common moderation cases with a
consistent API.

No interactive version is needed. The interactivity in
`interactive_moderation_3d()` exists to expose viewing angles of a 3D
surface; a 2D plot has no analogous control surface worth exposing.

### Sketch

```r
plot_moderation(
  formula = y ~ x * z,
  data    = moderation_data,
  iv      = NULL,    # required when formula has 3+ predictors
  mod     = NULL,    # required when formula has 3+ predictors
  mod_at  = NULL,    # see "Open questions"
  ...
)
```

Behavior by moderator type:

- **Binary or factor moderator**: one regression line per level, drawn
  in distinct colors with a legend. The IV varies along the x-axis; the
  DV is on the y-axis.
- **Continuous moderator**: three regression lines at "low / mean /
  high" slices of the moderator. The Aiken & West convention is
  mean ± 1 SD; an alternative is quartiles (25th / 50th / 75th
  percentile).

Other predictors (when the formula has more than IV and moderator) are
held at their typical values, identical to `plot_moderation_3d()`.
Console message follows the same one-line convention.

### Open questions

1. **Slice selection for continuous moderators.** Aiken & West
   (mean ± 1 SD) is the most-cited convention, but quartiles or
   user-specified values are common too. Default to mean ± 1 SD and
   accept a `mod_at` numeric vector to override?
2. **Categorical moderator with 3+ levels.** Plot one line per level
   (could get crowded above ~5 levels). Cap or warn?
3. **Confidence bands.** Skip in v1 (matches the 3D version's no-CI
   behavior), or include a translucent band per slope from
   `predict.lm(..., interval = "confidence")`? This is the single
   biggest "publication-ready" gap in the 3D version too.
4. **Plotting backend.** Base R graphics (per package convention) is
   sufficient — `plot()` for the points, `abline()` per slope, custom
   legend. No new dependency required.
5. **Naming.** `plot_moderation()` (no suffix) reads naturally as the
   default 2D case, with `plot_moderation_3d()` as the special-purpose
   3D variant. Alternative: `plot_moderation_2d()` for symmetry.
   Recommend the no-suffix form.

### Out of scope (for the branch that builds this)

- Interactive Shiny gadget version (no useful slider).
- Higher-order moderation (3-way interactions).
- Standardized vs. raw coefficient toggle.
- Johnson-Neyman regions of significance overlay.

### Related

- Current `plot_moderation_3d()` rejects categorical iv/mod with a
  clear error pointing nowhere — this function is the eventual
  destination for that case.
- The `moderation_data` bundled dataset (continuous `x`, `z`, `w`)
  works as the default example for the continuous-moderator branch;
  the binary-moderator branch needs either a small bundled binary
  dataset or a `factor(z > 0)` derivation in the examples.
