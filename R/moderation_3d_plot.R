#' compstatslib plot_moderation_3d() function
#'
#' Non-interactive visualization of a moderated regression. Fits an
#' \code{lm()} from the supplied formula and data, predicts the outcome
#' over a regular grid of the two predictors, and renders the fitted
#' surface as a 3D wireframe with a height-mapped colour gradient.
#'
#' @param formula A model formula naming exactly three variables in
#'   DV/IV/Mod order — e.g. \code{y ~ x * z} for the interaction model
#'   or \code{y ~ x + z} for the additive comparison. The first
#'   right-hand-side variable is treated as the IV, the second as the
#'   moderator.
#' @param data A data frame containing the three variables named in
#'   \code{formula}. Defaults to the bundled
#'   \code{\link{moderation_data}} so the function can be called with
#'   no arguments.
#' @param z_rot Numeric. Rotation about the vertical axis, in degrees
#'   (lattice's \code{screen$z}). Default 40. Try 0 to align the IV
#'   slope plane with the screen, or 270 for the moderator slope plane.
#' @param x_rot Numeric. Rotation about the horizontal axis, in degrees
#'   (lattice's \code{screen$x}). Default -70.
#' @param zlim Numeric length-2 vector. Vertical-axis range. Default
#'   \code{NULL}, which uses the union of the actual outcome's range
#'   in \code{data} and the fitted-surface range over the prediction
#'   grid. This keeps slopes visually proportionate to observed
#'   variability when predictions sit inside the data range (common
#'   for weak / moderate effects), while preventing the surface from
#'   being clipped when extreme corners of a strong interaction model
#'   extrapolate past the data extent.
#' @param ... Further arguments forwarded to
#'   \code{\link[lattice]{wireframe}}.
#'
#' @return A \code{trellis} object (lattice surface). Print or assign to
#'   render.
#'
#' @details
#' The user's \code{formula} is fitted as-is via \code{lm()}, so any
#' structure R's formula language supports works (\code{x * z},
#' \code{x + z}, \code{x:z}, transformations, etc.). \code{predict()}
#' evaluates the fitted model at every point of an \code{expand.grid()}
#' over the IV and moderator ranges (15 steps each). The resulting
#' fitted surface is passed to \code{lattice::wireframe()} with
#' \code{drape = TRUE} for a height-mapped colour gradient.
#'
#' Note that the \emph{vertical} axis of the rendered plot depicts the
#' outcome (DV) regardless of variable naming. With the bundled
#' \code{moderation_data} the moderator is named \code{z}, but \code{z}
#' appears on a horizontal plot axis, not the vertical "z-axis" of the
#' wireframe.
#'
#' This function uses a formula API (rather than column-name strings)
#' because \code{predict.lm()} evaluates the user's formula natively
#' over the prediction grid: writing \code{y ~ x + z} versus
#' \code{y ~ x * z} switches between additive and interaction models
#' with no special-casing inside the function.
#'
#' @seealso \code{\link{interactive_moderation_3d}} for the rotatable
#'   Shiny gadget version; \code{\link{moderation_data}} for the
#'   bundled teaching dataset.
#'
#' @examples
#' # Default synthetic example
#' plot_moderation_3d()
#'
#' # Additive model — flat surface, no twist
#' plot_moderation_3d(y ~ x + z, moderation_data)
#'
#' # User's own data and naming
#' set.seed(1)
#' my_df <- data.frame(
#'   score = rnorm(100),
#'   time  = rnorm(100),
#'   dose  = rnorm(100)
#' )
#' plot_moderation_3d(score ~ time * dose, my_df)
#'
#' @importFrom stats lm predict reformulate
#' @export
plot_moderation_3d <- function(formula = y ~ x * z,
                               data    = moderation_data,
                               z_rot   = 40,
                               x_rot   = -70,
                               zlim    = NULL,
                               ...) {
  vars <- all.vars(formula)
  if (length(vars) != 3) {
    stop("`formula` must name exactly three variables (DV, IV, moderator). ",
         "Got: ", paste(vars, collapse = ", "))
  }
  dv  <- vars[1]
  iv  <- vars[2]
  mod <- vars[3]

  missing_cols <- setdiff(vars, names(data))
  if (length(missing_cols) > 0) {
    stop("`data` is missing columns named in formula: ",
         paste(missing_cols, collapse = ", "))
  }

  fit <- lm(formula, data = data)

  grid <- setNames(
    expand.grid(
      seq(min(data[[iv]]),  max(data[[iv]]),  length.out = 15),
      seq(min(data[[mod]]), max(data[[mod]]), length.out = 15)
    ),
    c(iv, mod)
  )
  grid[[dv]] <- predict(fit, grid)

  if (is.null(zlim)) zlim <- range(c(data[[dv]], grid[[dv]]))

  lattice::wireframe(
    reformulate(c(iv, mod), response = dv),
    data     = grid,
    drape    = TRUE,
    colorkey = FALSE,
    scales   = list(arrows = FALSE),
    screen   = list(z = z_rot, x = x_rot),
    zlim     = zlim,
    ...
  )
}
