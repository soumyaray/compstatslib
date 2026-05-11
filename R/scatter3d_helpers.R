# Internal helpers shared between plot_scatter3d() and
# interactive_scatter3d(). Not exported.

# Names of numeric columns in a data frame.
scatter3d_numeric_cols <- function(data) {
  names(data)[vapply(data, is.numeric, logical(1))]
}

# Error out if too few numeric columns to populate x / y / z. `fn_label`
# is the name of the caller (e.g. "plot_scatter3d"), used in the message.
scatter3d_require_3_numeric <- function(num_cols, fn_label) {
  if (length(num_cols) < 3) {
    stop(fn_label, "() needs at least 3 numeric columns; got ",
         length(num_cols),
         ". Supply x/y/z explicitly or add numeric columns.",
         call. = FALSE)
  }
}

# Validate the stylistic / view args.
scatter3d_validate_style <- function(aspect, opacity, size, camera) {
  if (!is.numeric(aspect) || length(aspect) != 3) {
    stop("`aspect` must be a numeric vector of length 3.", call. = FALSE)
  }
  if (any(aspect <= 0)) {
    stop("`aspect` values must all be positive.", call. = FALSE)
  }
  if (!is.numeric(opacity) || length(opacity) != 1 ||
      opacity <= 0 || opacity > 1) {
    stop("`opacity` must be a single numeric in (0, 1].", call. = FALSE)
  }
  if (!is.numeric(size) || length(size) != 1 || size <= 0) {
    stop("`size` must be a single positive numeric.", call. = FALSE)
  }
  if (!is.null(camera) && !is.list(camera)) {
    stop("`camera` must be a list (with optional eye/center/up ",
         "components) or NULL.", call. = FALSE)
  }
  invisible(NULL)
}

# Force the promise bound to `axis_name` in `env`, rewriting R's
# "object not found" into a clearer hint about character syntax, and
# checking the type. Returns the validated value (NULL or character).
scatter3d_validate_axis_arg <- function(axis_name, env) {
  val <- tryCatch(
    get(axis_name, envir = env),
    error = function(e) {
      stop(sprintf(
        "`%s` must be a character column name, e.g. `%s = \"colname\"`. ",
        axis_name, axis_name),
        "An unquoted identifier was passed but couldn't be evaluated: ",
        conditionMessage(e),
        call. = FALSE)
    }
  )
  if (!is.null(val) && !is.character(val)) {
    stop(sprintf(
      "`%s` must be NULL or a character column name; got %s.",
      axis_name, paste(class(val), collapse = "/")),
      call. = FALSE)
  }
  val
}
