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

## Current State

- [x] Plan created
- [x] `interactive_sampling` ported and manually tested in Positron
- [ ] `interactive_t_test` — uses `manipulate`, needs porting
- [ ] `interactive_matrix_inverse` — uses `manipulate` (and `library(manipulate)`!), needs porting
- [ ] `interactive_regression` — uses `locator()`, needs porting
- [ ] `interactive_logit` — uses `locator()`, needs porting
- [ ] `interactive_pca` — uses `locator()`, needs porting
- [ ] Remove `manipulate` from DESCRIPTION Imports (already done, but verify no references remain)
- [ ] `devtools::check()` passes

## Key Findings

### Lessons from porting `interactive_sampling`

These patterns and decisions apply to all remaining ports:

**Architecture pattern — Shiny gadget wrapping existing `plot_*` function:**

- Use `miniUI::miniPage` + `miniUI::gadgetTitleBar` + `miniUI::miniContentPanel` for layout
- Title bar provides standard Cancel (returns `NULL`) and Done (returns results) buttons via `input$cancel` and `input$done`
- Place controls (sliders, dropdowns, buttons) in a `tags$div` at the top of `miniContentPanel`, plot below
- Use `shiny::runGadget(ui, server, viewer = shiny::paneViewer())` to open in IDE viewer pane

**Layout — flex column for dynamic sizing:**

- Set `miniContentPanel(padding = 0, ...)` then use a flex column container: `display: flex; flex-direction: column; height: 100%;`
- Controls row: `flex-shrink: 0` so it keeps its natural height
- Plot container: `flex: 1; min-height: 0;` so it fills remaining space
- Do NOT hardcode pixel heights (e.g., `calc(100% - 80px)`) — title bar height varies

**Alignment — controls row:**

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

### Function inventory

| Function                      | Current mechanism                  | Controls                                                 | Plot function              | Notes                                                                          |
| ----------------------------- | ---------------------------------- | -------------------------------------------------------- | -------------------------- | ------------------------------------------------------------------------------ |
| `interactive_sampling`        | ~~`manipulate`~~ **DONE**          | picker (sample_size), picker (reps), button (Sample)     | `plot_sampling()`          | Accumulates `sample_theta` across clicks                                       |
| `interactive_t_test`          | `manipulate`                       | 4 sliders (diff, sd, n, alpha), 1 checkbox (error_matrix) | `plot_t_test()`          | Stateless — no accumulation, re-plots from scratch each time                   |
| `interactive_matrix_inverse`  | `manipulate` + `library(manipulate)` | 4 sliders (x1, y1, x2, y2)                            | `plot_matrix_inverse()`    | Uses `library(manipulate)` instead of `::` — must fix. Stateless               |
| `interactive_regression`      | `locator()`                        | Point-and-click                                          | `plot_regr()`              | Accumulates points. Uses `locator(1)` in repeat loop                           |
| `interactive_logit`           | `locator()`                        | Point-and-click                                          | `plot_logit()`             | Accumulates points. Clamps x, binarizes y                                      |
| `interactive_pca`             | `locator()`                        | Point-and-click                                          | Inline (no `plot_pca()`)   | Accumulates points. Computes PCA inline. Uninitialized `pca` var if < 3 points |

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

- [ ] 1.1a Test: `interactive_t_test` returns a Shiny app object or runs without error
- [ ] 1.2 Port `R/t_statistic_interactive.R`: replace `manipulate` with Shiny gadget using `sliderInput` and `checkboxInput`; sliders should live-update the plot (no trigger/button pattern needed)
- [ ] 1.3 Update roxygen2 docs: remove gear-icon reference
- [ ] 1.4 Manual verification in Positron

### Slice 2: `interactive_matrix_inverse` (manipulate with sliders)

> Also stateless. Has a `library(manipulate)` call that must be removed.

- [ ] 2.1a Test: `interactive_matrix_inverse` returns a Shiny app object or runs without error
- [ ] 2.2 Port `R/matrix_inverse_interactive.R`: remove `library(manipulate)`, replace with Shiny gadget using 4 `sliderInput`s; live-updating
- [ ] 2.3 Update roxygen2 docs: remove gear-icon/slider-bar references
- [ ] 2.4 Manual verification in Positron

### Slice 3: `interactive_regression` (locator-based)

> First `locator()` port. Accumulates clicked points. Uses separate `plot_regr()`.

- [ ] 3.1a Test: `interactive_regression` constructs without error; verify point accumulation logic
- [ ] 3.2 Port `R/regression_interactive.R`: replace `locator()` loop with `plotOutput(click=...)` + `observeEvent(input$plot_click, ...)` reactive pattern
- [ ] 3.3 Update roxygen2 docs: replace "hit ESC" with Done/Cancel instructions
- [ ] 3.4 Manual verification in Positron

### Slice 4: `interactive_logit` (locator-based)

> Similar to regression but with x-clamping and y-binarization on click.

- [ ] 4.1a Test: `interactive_logit` constructs without error
- [ ] 4.2 Port `R/logit_interactive.R`: replace `locator()` with click-based Shiny gadget; preserve clamping/binarization logic in click handler
- [ ] 4.3 Update roxygen2 docs
- [ ] 4.4 Manual verification in Positron

### Slice 5: `interactive_pca` (locator-based, inline plotting)

> Most complex — no separate `plot_pca()`, PCA computation is inline. Extract `plot_pca()` first, then port interactive wrapper.

- [ ] 5.1a Test: `plot_pca` produces correct output for various point counts (0, 1, 2, 3+ points)
- [ ] 5.1b Test: `interactive_pca` constructs without error
- [ ] 5.2 Extract `plot_pca()` into `R/pca_plot.R`: move inline plotting + PCA computation into standalone function; fix uninitialized `pca` variable when < 3 points
- [ ] 5.3 Port `R/pca_interactive.R`: replace `locator()` with click-based Shiny gadget calling `plot_pca()`
- [ ] 5.4 Update roxygen2 docs
- [ ] 5.5 Manual verification in Positron

### Slice 6: Cleanup and verification

- [ ] 6.1 Grep for any remaining `manipulate` references in R/ files
- [ ] 6.2 Grep for any remaining `locator()` references in R/ files
- [ ] 6.3 Run `devtools::document()` to regenerate NAMESPACE and man pages
- [ ] 6.4 Run `devtools::check()` — must pass with no errors
- [ ] 6.5 Verify DESCRIPTION has no `manipulate` dependency

## Completed

- [x] `interactive_sampling` ported to Shiny gadget (prototype slice — established all patterns documented in Key Findings)
- [x] DESCRIPTION updated: `manipulate` replaced with `shiny`, `miniUI`

---

Last updated: 2026-03-08
