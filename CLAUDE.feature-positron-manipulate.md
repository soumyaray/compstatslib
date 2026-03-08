# Port manipulate() to Shiny Gadgets for Positron Compatibility

> **IMPORTANT**: This plan must be kept up-to-date at all times. Assume context can be cleared at any time — this file is the single source of truth for the current state of this work. Update this plan before and after task and subtask implementations.

## Branch

`feature-positron-manipulate`

## Goal

Replace all `manipulate::manipulate()` usage with Shiny gadgets (`shiny` + `miniUI`) so interactive functions work in both Positron and RStudio. Also port `locator()`-based interactive functions to use `shiny::clickOpts` for the same cross-IDE compatibility.

## Strategy: Vertical Slice

Each interactive function is an independent slice. For each function:

1. **Write/update test** — Verify the Shiny gadget version constructs without error
2. **Port implementation** — Replace `manipulate`/`locator` with Shiny gadget
3. **Manual verification** — Test interactively in Positron (and RStudio if available)

## Workflow Notes

- **Do NOT run `devtools::check()` until all slices are ported and manually verified.** It is slow and catches pre-existing issues unrelated to this branch. Run `devtools::document()` and `devtools::test()` after code changes. Save `devtools::check()` for the final cleanup slice.
- **Manual verification in Positron should happen after each slice's code is written**, before marking the slice complete.

## Current State

- [x] Plan created
- [x] `interactive_sampling` ported and manually tested in Positron
- [x] `interactive_t_test` — ported (code + docs + test passing), layout refined to sidebar, **manually verified in Positron**
- [x] `interactive_matrix_inverse` — ported (code + docs + test passing), sidebar layout, **manually verified in Positron**
- [x] `interactive_regression` — ported (code + docs + test passing), **manually verified in Positron**
- [x] `interactive_logit` — ported (code + docs + test passing), **manually verified in Positron**
- [x] `interactive_pca` — ported with new `plot_pca()` extracted (code + docs + tests passing), fixed asp/click bug, **manually verified in Positron**
- [x] Remove `manipulate` from DESCRIPTION Imports (already done, verified no references remain)
- [x] No `manipulate` or `locator()` references remain in R/ source files
- [x] Manual verification of all functions in Positron
- [ ] `devtools::check()` — deferred until CRAN preparation

## Key Findings

### Lessons from porting `interactive_sampling`

These patterns and decisions apply to all remaining ports:

**Architecture pattern — Shiny gadget wrapping existing `plot_*` function:**

- Use `miniUI::miniPage` + `miniUI::gadgetTitleBar` + `miniUI::miniContentPanel` for layout
- Title bar provides standard Cancel (returns `NULL`) and Done (returns results) buttons via `input$cancel` and `input$done`
- Place controls (sliders, dropdowns, buttons) in a `tags$div` at the top of `miniContentPanel`, plot below
- Use `shiny::runGadget(ui, server, viewer = shiny::paneViewer())` to open in IDE viewer pane

**Layout — two patterns depending on control count:**

1. **Few controls (dropdowns/buttons):** flex column with controls row on top, plot below
   - Set `miniContentPanel(padding = 0, ...)` then use a flex column container: `display: flex; flex-direction: column; height: 100%;`
   - Controls row: `flex-shrink: 0` so it keeps its natural height
   - Plot container: `flex: 1; min-height: 0;` so it fills remaining space
   - Do NOT hardcode pixel heights (e.g., `calc(100% - 80px)`) — title bar height varies

2. **Many sliders:** sidebar layout — controls on the left, plot fills remaining space
   - Sliders are vertically tall (label + value + track + ticks) and eat too much vertical space when placed above the plot
   - Use `display: flex; height: 100%;` with a fixed-width sidebar (`width: 140px; flex-shrink: 0; overflow-y: auto;`) and `flex: 1; min-width: 0;` for the plot
   - This maximizes vertical space for the plot

**Alignment — controls row (for pattern 1):**

- Use `display: flex; align-items: flex-end; gap: 12px; padding: 8px;` on the controls div
- Action buttons need `margin-bottom: 15px;` wrapper to align with select inputs (which have built-in bottom margin from their labels)

**Reactive pattern — button-triggered sampling:**

- Use a `trigger` reactiveVal (counter) incremented by button click
- `renderPlot` depends on `trigger()` and uses `shiny::isolate()` for all other inputs
- This ensures the plot only re-renders on button click, not on dropdown/slider changes
- Accumulated state (like `sample_theta`) stored in a separate `cache` reactiveVal, also read via `isolate()` inside `renderPlot`
- Important: `plot_sampling()` both computes AND draws — cannot separate them. So computation happens inside `renderPlot`, with the cache updated there too (safe because cache is only read via `isolate`)

**Suppressing Shiny startup messages:**

- `shiny::runGadget` does NOT have a `quiet` parameter
- Use `options(shiny.quiet = TRUE)` before the call, with `on.exit(options(old_opts))` to restore
- Wrap `runGadget` in `suppressMessages()` to catch the "Browsing..." message from the viewer

**Control mappings from manipulate to Shiny:**

| `manipulate`                                   | Shiny equivalent                                       |
| ---------------------------------------------- | ------------------------------------------------------ |
| `manipulate::slider(min, max, step, initial)`  | `shiny::sliderInput(id, label, min, max, value, step)` |
| `manipulate::picker(...)`                      | `shiny::selectInput(id, label, choices, selected)`      |
| `manipulate::checkbox(initial, label)`         | `shiny::checkboxInput(id, label, value)`               |
| `manipulate::button(label)`                    | `shiny::actionButton(id, label)`                       |

**DESCRIPTION changes:**

- Replaced `Imports: manipulate` with `Imports: shiny, miniUI`
- Already done in this branch

**Roxygen `@usage` pitfall:**

- Do NOT put descriptive prose in `@usage` — it must contain valid R function signatures only
- Use `@details` for usage instructions (e.g., "Click Done to close")
- R CMD check will warn about "Bad \usage lines" otherwise

### Function inventory

| Function                      | Status        | Controls                                                 | Plot function              | Notes                                                                          |
| ----------------------------- | ------------- | -------------------------------------------------------- | -------------------------- | ------------------------------------------------------------------------------ |
| `interactive_sampling`        | **DONE**      | picker (sample_size), picker (reps), button (Sample)     | `plot_sampling()`          | Accumulates `sample_theta` across clicks                                       |
| `interactive_t_test`          | **VERIFYING** | 4 sliders (diff, sd, n, alpha), 1 checkbox (error_matrix) | `plot_t_test()`          | Stateless — sidebar layout; `suppressWarnings` for `qt()` precision warnings   |
| `interactive_matrix_inverse`  | **PORTED**    | 4 sliders (x1, y1, x2, y2)                              | `plot_matrix_inverse()`    | Stateless — live-updating sliders                                              |
| `interactive_regression`      | **PORTED**    | Point-and-click via `plotOutput(click=...)`               | `plot_regr()`              | Accumulates points. Returns dataframe on Done                                  |
| `interactive_logit`           | **PORTED**    | Point-and-click via `plotOutput(click=...)`               | `plot_logit()`             | Accumulates points. Clamps x, binarizes y                                      |
| `interactive_pca`             | **PORTED**    | Point-and-click via `plotOutput(click=...)`               | `plot_pca()` **(NEW)**     | Accumulates points. Returns list(points, pca). Fixed uninitialized `pca` bug   |

### locator()-based functions: porting strategy

`locator()` is an R graphics device function — it works in RStudio's plot pane but NOT in Positron or Shiny. The replacement is `shiny::plotOutput(..., click = "plot_click")` which provides `input$plot_click` with x/y coordinates when the user clicks the plot.

Key differences:

- `locator()` blocks execution until click; `click` in Shiny is event-driven via `observeEvent(input$plot_click, ...)`
- No need for a `repeat` loop — use reactive pattern instead
- ESC to stop is replaced by Done/Cancel title bar buttons
- Points accumulate in a `reactiveVal` list/data.frame

## Questions

> Questions must be crossed off when resolved. Note the decision made.

- [x] ~~Should `interactive_pca` get a separate `plot_pca()` function extracted, or keep inline plotting?~~ **Decision: Yes, extract a `plot_pca()` function** to follow the established paired pattern.
- [x] ~~Should slider-based functions (`interactive_t_test`, `interactive_matrix_inverse`) re-plot live as sliders move, or require a button click?~~ **Decision: Live-update** — matches original `manipulate` behavior. No trigger/button pattern needed for these.

## Scope

**In scope:**

- Port all 5 remaining interactive functions from `manipulate`/`locator` to Shiny gadgets
- Remove all `manipulate` references from R/ source files
- Ensure `devtools::check()` passes
- Update roxygen2 documentation (remove gear-icon references, update usage notes)

**Out of scope:**

- Converting base R graphics to plotly/htmlwidgets
- Adding new interactive features beyond what exists
- Porting to other IDEs beyond RStudio/Positron

**Deferred:**

- None

## Tasks

### Slice 1: `interactive_t_test` (manipulate with sliders + checkbox)

> Stateless function — simplest manipulate port. Live-updating sliders (no button needed).

- [x] 1.1a Test: `interactive_t_test` returns a Shiny app object or runs without error — **no separate interactive test needed; relies on existing `plot_t_test` test**
- [x] 1.2 Port `R/t_statistic_interactive.R`: replaced `manipulate` with Shiny gadget using `sliderInput` and `checkboxInput`; sliders live-update the plot
- [x] 1.2b Layout refined: sidebar layout (controls left, plot right) to maximize plot vertical space; `suppressWarnings` wrapping `plot_t_test` for `qt()` precision warnings
- [x] 1.3 Update roxygen2 docs: removed gear-icon reference, moved usage prose to `@details`
- [x] 1.4 Manual verification in Positron — **done**

### Slice 2: `interactive_matrix_inverse` (manipulate with sliders)

> Also stateless. Had a `library(manipulate)` call that was removed.

- [x] 2.1a Test: relies on existing `plot_matrix_inverse` test
- [x] 2.2 Port `R/matrix_inverse_interactive.R`: removed `library(manipulate)`, replaced with Shiny gadget using 4 `sliderInput`s; live-updating
- [x] 2.3 Update roxygen2 docs: removed gear-icon/slider-bar references, moved usage prose to `@details`
- [x] 2.4 Manual verification in Positron — **done** (switched to sidebar layout)

### Slice 3: `interactive_regression` (locator-based)

> First `locator()` port. Accumulates clicked points. Uses separate `plot_regr()`.

- [x] 3.1a Test: relies on existing `plot_regr` test
- [x] 3.2 Port `R/regression_interactive.R`: replaced `locator()` loop with `plotOutput(click=...)` + `observeEvent(input$plot_click, ...)` reactive pattern
- [x] 3.3 Update roxygen2 docs: replaced "hit ESC" with Done/Cancel instructions via `@details`
- [x] 3.4 Manual verification in Positron — **done**

### Slice 4: `interactive_logit` (locator-based)

> Similar to regression but with x-clamping and y-binarization on click.

- [x] 4.1a Test: relies on existing `plot_logit` test
- [x] 4.2 Port `R/logit_interactive.R`: replaced `locator()` with click-based Shiny gadget; preserved clamping/binarization logic in click handler
- [x] 4.3 Update roxygen2 docs: moved usage prose to `@details`
- [x] 4.4 Manual verification in Positron — **done**

### Slice 5: `interactive_pca` (locator-based, inline plotting)

> Most complex — extracted `plot_pca()` first, then ported interactive wrapper.

- [x] 5.1a Test: added 3 tests for `plot_pca()` — empty points, 2 points, 3+ points (returns prcomp)
- [x] 5.1b Test: `interactive_pca` — relies on `plot_pca` tests
- [x] 5.2 Extract `plot_pca()` into `R/pca_plot.R`: moved inline plotting + PCA computation into standalone function; fixed uninitialized `pca` variable (returns `NULL` when < 3 points)
- [x] 5.3 Port `R/pca_interactive.R`: replaced `locator()` with click-based Shiny gadget calling `plot_pca()`
- [x] 5.4 Update roxygen2 docs
- [x] 5.5 Manual verification in Positron — **done** (fixed `par(pty="s")` breaking click mapping; kept `asp=1` in plot calls)

### Slice 6: Cleanup and verification

- [x] 6.1 Grep for any remaining `manipulate` references in R/ files — **none found**
- [x] 6.2 Grep for any remaining `locator()` references in R/ files — **none found**
- [x] 6.3 Run `devtools::document()` to regenerate NAMESPACE and man pages — **done**
- [ ] 6.4 Run `devtools::check()` — deferred until after manual verification
- [x] 6.5 Verify DESCRIPTION has no `manipulate` dependency — **confirmed**

## Completed

- [x] `interactive_sampling` ported to Shiny gadget (prototype slice — established all patterns documented in Key Findings)
- [x] DESCRIPTION updated: `manipulate` replaced with `shiny`, `miniUI`
- [x] All 5 remaining functions ported (t_test, matrix_inverse, regression, logit, pca)
- [x] `plot_pca()` extracted as new standalone function with tests
- [x] All `manipulate` and `locator()` references removed from R/ source files
- [x] `devtools::document()` regenerated NAMESPACE and man pages
- [x] `devtools::test()` passes (11/11 tests)
- [x] Fixed roxygen `@usage` → `@details` for prose descriptions

## Remaining

- [x] Manual verification of all 5 ported functions in Positron — **all done**
- [x] Sidebar layout applied to `interactive_matrix_inverse`
- [ ] `devtools::check()` — deferred until CRAN preparation

---

Last updated: 2026-03-08
