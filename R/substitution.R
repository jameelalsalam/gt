#' Substitute missing values in the table body
#'
#' @description
#' Wherever there is missing data (i.e., `NA` values) customizable content may
#' present better than the standard `NA` text that would otherwise appear. The
#' `sub_missing()` function allows for this replacement through its
#' `missing_text` argument (where an em dash serves as the default).
#'
#' @details
#' Targeting of values is done through `columns` and additionally by `rows` (if
#' nothing is provided for `rows` then entire columns are selected). Conditional
#' formatting is possible by providing a conditional expression to the `rows`
#' argument. See the Arguments section for more information on this.
#'
#' @inheritParams fmt_number
#' @param missing_text The text to be used in place of `NA` values in the
#'   rendered table.
#'
#' @return An object of class `gt_tbl`.
#'
#' @section Examples:
#'
#' Use [`exibble`] to create a **gt** table. The `NA` values in different
#' columns will be given replacement text with two calls of `sub_missing()`.
#'
#' ```r
#' exibble %>%
#'   dplyr::select(-row, -group) %>%
#'   gt() %>%
#'   sub_missing(
#'     columns = 1:2,
#'     missing_text = "missing"
#'   ) %>%
#'   sub_missing(
#'     columns = 4:7,
#'     missing_text = "nothing"
#'   )
#' ```
#'
#' \if{html}{\out{
#' `r man_get_image_tag(file = "man_sub_missing_1.png")`
#' }}
#'
#' @family data formatting functions
#' @section Function ID:
#' 3-17
#'
#' @import rlang
#' @export
sub_missing <- function(
    data,
    columns = everything(),
    rows = everything(),
    missing_text = "---"
) {

  # Perform input object validation
  stop_if_not_gt(data = data)

  # Pass `data`, `columns`, `rows`, and the formatting
  # functions (as a function list) to `subst()`
  subst(
    data = data,
    columns = {{ columns }},
    rows = {{ rows }},
    fns = list(
      # Any values of `x` that are `NA` get `missing_text` as output; any values
      # that are not missing get `NA` as their output (meaning, the existing
      # output for that value, if it exists, should be inherited)
      html = function(x) {

        missing_text <-
          context_missing_text(
            missing_text = missing_text,
            context = "html"
          )
        ifelse(is.na(x), missing_text, NA_character_)
      },
      latex = function(x) {

        missing_text <-
          context_missing_text(
            missing_text = missing_text,
            context = "latex"
          )
        ifelse(is.na(x), missing_text, NA_character_)
      },
      rtf = function(x) {

        missing_text <-
          context_missing_text(
            missing_text = missing_text,
            context = "rtf"
          )
        ifelse(is.na(x), missing_text, NA_character_)
      },
      default = function(x) {
        ifelse(is.na(x), missing_text, NA_character_)
      }
    )
  )
}

#' Format missing values (deprecated)
#'
#' @inheritParams fmt_number
#' @param missing_text The text to be used in place of `NA` values in the
#'   rendered table.
#'
#' @import rlang
#' @keywords internal
#' @export
fmt_missing <- function(
    data,
    columns = everything(),
    rows = everything(),
    missing_text = "---"
) {

  cli::cli_warn(c(
    "Since gt v0.6.0 the `fmt_missing()` function is deprecated and will
    soon be removed.",
    "*" = "Use the `sub_missing()` function instead."
  ))

  sub_missing(
    data = data,
    columns = columns,
    rows = rows,
    missing_text = missing_text
  )
}

#' Substitute zero values in the table body
#'
#' @description
#' Wherever there is numerical data that are zero in value, replacement text may
#' be better for explanatory purposes. The `sub_zero()` function allows for this
#' replacement through its `zero_text` argument.
#'
#' @details
#' Targeting of values is done through `columns` and additionally by `rows` (if
#' nothing is provided for `rows` then entire columns are selected). Conditional
#' formatting is possible by providing a conditional expression to the `rows`
#' argument. See the Arguments section for more information on this.
#'
#' @inheritParams fmt_number
#' @param zero_text The text to be used in place of zero values in the rendered
#'   table.
#'
#' @return An object of class `gt_tbl`.
#'
#' @section Examples:
#'
#' Let's generate a simple, single-column tibble that contains an assortment of
#' values that could potentially undergo some substitution.
#'
#' ```{r}
#' tbl <- dplyr::tibble(num = c(10^(-1:2), 0, 0, 10^(4:6)))
#'
#' tbl
#' ```
#'
#' With this table, the zero values in will be given replacement text with a
#' single call of `sub_zero()`.
#'
#' ```r
#' tbl %>%
#'   gt() %>%
#'   fmt_number(columns = num) %>%
#'   sub_zero()
#' ```
#'
#' \if{html}{\out{
#' `r man_get_image_tag(file = "man_sub_zero_1.png")`
#' }}
#'
#' @family data formatting functions
#' @section Function ID:
#' 3-18
#'
#' @import rlang
#' @export
sub_zero <- function(
    data,
    columns = everything(),
    rows = everything(),
    zero_text = "nil"
) {

  # Perform input object validation
  stop_if_not_gt(data = data)

  # Pass `data`, `columns`, `rows`, and the formatting
  # functions (as a function list) to `subst()`
  subst(
    data = data,
    columns = {{ columns }},
    rows = {{ rows }},
    fns = list(
      # Any values of `x` that are exactly 0 get `zero_text` as output;
      # any values that aren't 0 won't be affected
      html = function(x) {
        zero_text <- process_text(zero_text, context = "html")
        ifelse(is.numeric(x) & x == 0, zero_text, NA_character_)
      },
      rtf = function(x) {
        zero_text <- process_text(zero_text, context = "rtf")
        ifelse(is.numeric(x) & x == 0, zero_text, NA_character_)
      },
      latex = function(x) {
        zero_text <- process_text(zero_text, context = "latex")
        ifelse(is.numeric(x) & x == 0, zero_text, NA_character_)
      },
      default = function(x) {
        zero_text <- process_text(zero_text, context = "default")
        ifelse(is.numeric(x) & x == 0, zero_text, NA_character_)
      }
    )
  )
}

#' Substitute small values in the table body
#'
#' @description
#' Wherever there is numerical data that are very small in value, replacement
#' text may be better for explanatory purposes. The `sub_small_vals()` function
#' allows for this replacement through specification of a `threshold`, a
#' `small_pattern`, and the sign of the values to be considered.
#'
#' @details
#' Targeting of values is done through `columns` and additionally by `rows` (if
#' nothing is provided for `rows` then entire columns are selected). Conditional
#' formatting is possible by providing a conditional expression to the `rows`
#' argument. See the Arguments section for more information on this.
#'
#' @inheritParams fmt_number
#' @param threshold The threshold value with which values should be considered
#'   small enough for replacement.
#' @param small_pattern The pattern text to be used in place of the suitably
#'   small values in the rendered table.
#' @param sign The sign of the numbers to be considered in the replacement. By
#'   default, we only consider positive values (`"+"`). The other option (`"-"`)
#'   can be used to consider only negative values.
#'
#' @return An object of class `gt_tbl`.
#'
#' @section Examples:
#'
#' Let's generate a simple, single-column tibble that contains an assortment of
#' values that could potentially undergo some substitution.
#'
#' ```{r}
#' tbl <- dplyr::tibble(num = c(10^(-4:2), 0, NA))
#'
#' tbl
#' ```
#'
#' The `tbl` contains a variety of smaller numbers and some might be small
#' enough to reformat with a threshold value. With `sub_small_vals()` we can
#' do just that:
#'
#' ```r
#' tbl %>%
#'   gt() %>%
#'   fmt_number(columns = num) %>%
#'   sub_small_vals()
#' ```
#'
#' \if{html}{\out{
#' `r man_get_image_tag(file = "man_sub_small_vals_1.png")`
#' }}
#'
#' Small and negative values can also be handled but they are handled specially
#' by the `sign` parameter. Setting that to `"-"` will format only the small,
#' negative values.
#'
#' ```r
#' tbl %>%
#'   dplyr::mutate(num = -num) %>%
#'   gt() %>%
#'   fmt_number(columns = num) %>%
#'   sub_small_vals(sign = "-")
#' ```
#'
#' \if{html}{\out{
#' `r man_get_image_tag(file = "man_sub_small_vals_2.png")`
#' }}
#'
#' You don't have to settle with the default `threshold` value or the default
#' replacement pattern (in `small_pattern`). This can be changed and the
#' `"{x}"` in `small_pattern` (which uses the `threshold` value) can even be
#' omitted.
#'
#' ```r
#' tbl %>%
#'   gt() %>%
#'   fmt_number(columns = num) %>%
#'   sub_small_vals(
#'     threshold = 0.0005,
#'     small_pattern = "smol"
#'   )
#' ```
#'
#' \if{html}{\out{
#' `r man_get_image_tag(file = "man_sub_small_vals_3.png")`
#' }}
#'
#' @family data formatting functions
#' @section Function ID:
#' 3-19
#'
#' @import rlang
#' @export
sub_small_vals <- function(
    data,
    columns = everything(),
    rows = everything(),
    threshold = 0.01,
    small_pattern = if (sign == "+") "<{x}" else md("<*abs*(-{x})"),
    sign = "+"
) {

  # Perform input object validation
  stop_if_not_gt(data = data)

  # Check that the `sign` value is an acceptable value
  check_sub_fn_sign(sign = sign)

  if (sign == "+") {
    op_fn_threshold <- `<`
    op_fn_zero_away <- `>`
  } else {
    op_fn_threshold <- `>`
    op_fn_zero_away <- `<`
  }

  # Get the absolute value of the supplied `threshold`
  threshold <- abs(threshold)

  sub_replace_small_vals <- function(
    x,
    threshold,
    sign,
    small_pattern,
    context
  ) {

    if (!is.numeric(x)) {
      return(rep_len(NA_character_, length(x)))
    }

    ifelse(
      !is.na(x) &
        x != 0 &
        op_fn_threshold(x, threshold * ifelse(sign == "-", -1, 1)) &
        op_fn_zero_away(x, 0),
      process_text(
        resolve_small_vals_text(
          threshold = threshold,
          small_pattern = small_pattern
        ),
        context = context
      ),
      NA_character_
    )
  }

  # Pass `data`, `columns`, `rows`, and the formatting
  # functions (as a function list) to `subst()`
  subst(
    data = data,
    columns = {{ columns }},
    rows = {{ rows }},
    fns = list(
      # Any values of `x` that are below the threshold will be processed
      # according to the `small_pattern`, the `threshold` value (interacts with
      # the `small_pattern`, and the sign (changes the default `small_pattern`))
      html = function(x) {

        sub_replace_small_vals(
          x,
          threshold = threshold,
          sign = sign,
          small_pattern = small_pattern,
          context = "html"
        )
      },
      rtf = function(x) {

        sub_replace_small_vals(
          x,
          threshold = threshold,
          sign = sign,
          small_pattern = small_pattern,
          context = "rtf"
        )
      },
      latex = function(x) {

        sub_replace_small_vals(
          x,
          threshold = threshold,
          sign = sign,
          small_pattern = small_pattern,
          context = "latex"
        )
      },
      default = function(x) {

        sub_replace_small_vals(
          x,
          threshold = threshold,
          sign = sign,
          small_pattern = small_pattern,
          context = "default"
        )
      }
    )
  )
}

#' Substitute large values in the table body
#'
#' @description
#' Wherever there are numerical data that are very large in value, replacement
#' text may be better for explanatory purposes. The `sub_large_vals()` function
#' allows for this replacement through specification of a `threshold`, a
#' `large_pattern`, and the sign (positive or negative) of the values to be
#' considered.
#'
#' @details
#' Targeting of values is done through `columns` and additionally by `rows` (if
#' nothing is provided for `rows` then entire columns are selected). Conditional
#' formatting is possible by providing a conditional expression to the `rows`
#' argument. See the Arguments section for more information on this.
#'
#' @inheritParams fmt_number
#' @inheritParams sub_small_vals
#' @param threshold The threshold value with which values should be considered
#'   large enough for replacement.
#' @param large_pattern The pattern text to be used in place of the suitably
#'   large values in the rendered table.
#'
#' @return An object of class `gt_tbl`.
#'
#' @section Examples:
#'
#' Let's generate a simple, single-column tibble that contains an assortment of
#' values that could potentially undergo some substitution.
#'
#' ```{r}
#' tbl <- dplyr::tibble(num = c(0, NA, 10^(8:14)))
#'
#' tbl
#' ```
#'
#' The `tbl` object contains a variety of larger numbers and some might be
#' larger enough to reformat with a threshold value. With `sub_large_vals()` we
#' can do just that:
#'
#' ```r
#' tbl %>%
#'   gt() %>%
#'   fmt_number(columns = num) %>%
#'   sub_large_vals()
#' ```
#'
#' \if{html}{\out{
#' `r man_get_image_tag(file = "man_sub_large_vals_1.png")`
#' }}
#'
#' Large negative values can also be handled but they are handled specially
#' by the `sign` parameter. Setting that to `"-"` will format only the large
#' values that are negative. Notice that with the default `large_pattern`
#' value of `">={x}"` the `">="` is automatically changed to `"<="`.
#'
#' ```r
#' tbl %>%
#'   dplyr::mutate(num = -num) %>%
#'   gt() %>%
#'   fmt_number(columns = num) %>%
#'   sub_large_vals(sign = "-")
#' ```
#'
#' \if{html}{\out{
#' `r man_get_image_tag(file = "man_sub_large_vals_2.png")`
#' }}
#'
#' You don't have to settle with the default `threshold` value or the default
#' replacement pattern (in `large_pattern`). This can be changed and the
#' `"{x}"` in `large_pattern` (which uses the `threshold` value) can even be
#' omitted.
#'
#' ```r
#' tbl %>%
#'   gt() %>%
#'   fmt_number(columns = num) %>%
#'   sub_large_vals(
#'     threshold = 5E10,
#'     large_pattern = "hugemongous"
#'   )
#' ```
#'
#' \if{html}{\out{
#' `r man_get_image_tag(file = "man_sub_large_vals_3.png")`
#' }}
#'
#' @family data formatting functions
#' @section Function ID:
#' 3-20
#'
#' @import rlang
#' @export
sub_large_vals <- function(
    data,
    columns = everything(),
    rows = everything(),
    threshold = 1E12,
    large_pattern = ">={x}",
    sign = "+"
) {

  # Perform input object validation
  stop_if_not_gt(data = data)

  # Check that the `sign` value is an acceptable value
  check_sub_fn_sign(sign = sign)

  if (sign == "+") {
    op_fn <- `>=`
  } else {
    op_fn <- `<=`
  }

  # Get the absolute value of the supplied `threshold`
  threshold <- abs(threshold)

  sub_replace_large_vals <- function(
    x,
    threshold,
    large_pattern,
    sign,
    context
  ) {

    if (!is.numeric(x)) {
      return(rep_len(NA_character_, length(x)))
    }

    ifelse(
      !is.na(x) &
        op_fn(x, threshold * ifelse(sign == "-", -1, 1)),
      process_text(
        context_large_vals_text(
          threshold = threshold,
          large_pattern = large_pattern,
          sign = sign,
          context = context
        ),
        context = context
      ),
      NA_character_
    )
  }

  # Pass `data`, `columns`, `rows`, and the formatting
  # functions (as a function list) to `subst()`
  subst(
    data = data,
    columns = {{ columns }},
    rows = {{ rows }},
    fns = list(
      # Any values of `x` that are above the threshold will be processed
      # according to the `large_pattern`, the `threshold` value (interacts with
      # the `large_pattern`, and the sign (changes the default `large_pattern`))
      html = function(x) {

        sub_replace_large_vals(
          x,
          threshold = threshold,
          sign = sign,
          large_pattern = large_pattern,
          context = "html"
        )
      },
      rtf = function(x) {

        sub_replace_large_vals(
          x,
          threshold = threshold,
          sign = sign,
          large_pattern = large_pattern,
          context = "rtf"
        )
      },
      latex = function(x) {

        sub_replace_large_vals(
          x,
          threshold = threshold,
          sign = sign,
          large_pattern = large_pattern,
          context = "latex"
        )
      },
      default = function(x) {

        sub_replace_large_vals(
          x,
          threshold = threshold,
          sign = sign,
          large_pattern = large_pattern,
          context = "default"
        )
      }
    )
  )
}

check_sub_fn_sign <- function(sign) {

  if (!(sign %in% c("+", "-"))) {
    cli::cli_abort(c(
      "The `sign` option should either be \"+\" or \"-\".",
      "*" = "With \"+\", we consider only positive large values.",
      "*" = "Using \"-\" means that the focus is on negative values."
    ))
  }
}

subst <- function(
    data,
    columns = everything(),
    rows = everything(),
    fns
) {

  # Perform input object validation
  stop_if_not_gt(data = data)

  #
  # Resolution of columns and rows as character vectors
  #

  resolved_columns <-
    resolve_cols_c(
      expr = {{ columns }},
      data = data,
      excl_stub = FALSE
    )

  resolved_rows_idx <-
    resolve_rows_i(
      expr = {{ rows }},
      data = data
    )

  # If a single function is supplied to `fns` then
  # repackage that into a list as the `default` function
  if (is.function(fns)) {
    fns <- list(default = fns)
  }

  # Create the `subst_list`, which is a bundle of
  # substitution functions for specific columns and rows
  subst_list <-
    list(
      func = fns,
      cols = resolved_columns,
      rows = resolved_rows_idx
    )

  dt_substitutions_add(data = data, substitutions = subst_list)
}
