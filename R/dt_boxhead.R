.dt_boxhead_key <- "_boxhead"

dt_boxhead_get <- function(data) {
  dt__get(data, .dt_boxhead_key)
}

dt_boxhead_set <- function(data, boxh) {
  dt__set(data, .dt_boxhead_key, boxh)
}

dt_boxhead_init <- function(data) {

  vars <- colnames(dt_data_get(data = data))

  empty_list <- lapply(seq_along(vars), function(x) NULL)

  boxh_df <-
    dplyr::tibble(
      # Matches to the name of the `data` column
      var = vars,
      # The mode of the column in the rendered table
      # - `default` appears as a column with values below
      # - `stub` appears as part of a table stub, set to the left
      #   and styled differently
      # - `row_group` uses values as categoricals and groups rows
      #   under row group headings
      # - `hidden` hides this column from the final table render
      #   but retains values to use in expressions
      # - `hidden_at_px` similar to hidden but takes a list of
      #   screen widths (in px) whereby the column would be hidden
      type = "default",
      # # The shared spanner label between columns, where column names
      # # act as the keys
      # spanner_label = empty_list,
      # # The label for row groups, which is maintained as a list of
      # # labels by render context (e.g., HTML, LaTeX, etc.)
      # row_group_label = lapply(seq_along(names(data)), function(x) NULL),
      # The presentation label, which is a list of labels by
      # render context (e.g., HTML, LaTeX, etc.)
      column_label = as.list(vars),
      # The alignment of the column ("left", "right", "center")
      column_align = "center",
      # The width of the column in `px`
      column_width = empty_list,
      # The widths at which the column disappears from view (this is
      # HTML specific)
      hidden_px = empty_list
    )

  dt_boxhead_set(boxh = boxh_df, data = data)
}

dt_boxhead_edit <- function(data, var, ...) {

  dt_boxhead <- dt_boxhead_get(data = data)

  var_name <- var

  val_list <- list(...)

  if (length(val_list) != 1) {
    cli::cli_abort("`dt_boxhead_edit()` expects a single value at `...`.")
  }

  check_names_dt_boxhead_expr(expr = val_list)

  check_vars_dt_boxhead(var = var, dt_boxhead = dt_boxhead)

  if (is.list(dt_boxhead[[names(val_list)]])) {
    dt_boxhead[[which(dt_boxhead$var == var_name), names(val_list)]] <- unname(val_list)
  } else {
    dt_boxhead[[which(dt_boxhead$var == var_name), names(val_list)]] <- unlist(val_list)
  }

  dt_boxhead_set(data = data, boxh = dt_boxhead)
}

dt_boxhead_add_var <- function(
    data,
    var,
    type,
    column_label = list(var),
    column_align = "left",
    column_width = list(NULL),
    hidden_px = list(NULL),
    add_where = "top"
) {

  dt_boxhead <- dt_boxhead_get(data = data)

  dt_boxhead_row <-
    dplyr::tibble(
      var = var,
      type = type,
      column_label = column_label,
      column_align = column_align,
      column_width = column_width,
      hidden_px = hidden_px
    )

  if (add_where == "top") {
    dt_boxhead <- dplyr::bind_rows(dt_boxhead_row, dt_boxhead)
  } else if (add_where == "bottom") {
    dt_boxhead <- dplyr::bind_rows(dt_boxhead, dt_boxhead_row)
  } else {
    cli::cli_abort("The `add_where` value must be either `top` or `bottom`.")
  }

  dt_boxhead_set(data = data, boxh = dt_boxhead)
}

dt_boxhead_set_hidden <- function(data, vars) {

  dt_boxhead <- dt_boxhead_get(data = data)

  dt_boxhead[which(dt_boxhead$var %in% vars), "type"] <- "hidden"

  dt_boxhead_set(data = data, boxh = dt_boxhead)
}

dt_boxhead_set_not_hidden <- function(data, vars) {

  dt_boxhead <- dt_boxhead_get(data = data)

  dt_boxhead[which(dt_boxhead$var %in% vars), "type"] <- "default"

  dt_boxhead_set(data = data, boxh = dt_boxhead)
}

dt_boxhead_set_stub <- function(data, var) {

  dt_boxhead <- dt_boxhead_get(data = data)

  dt_boxhead[which(dt_boxhead$var == var), "type"] <- "stub"
  dt_boxhead[which(dt_boxhead$var == var), "column_align"] <- "left"

  dt_boxhead_set(data = data, boxh = dt_boxhead)
}

dt_boxhead_set_row_group <- function(data, vars) {

  dt_boxhead <- dt_boxhead_get(data = data)

  dt_boxhead[which(dt_boxhead$var %in% vars), "type"] <- "row_group"
  dt_boxhead[which(dt_boxhead$var %in% vars), "column_align"] <- "left"

  dt_boxhead_set(data = data, boxh = dt_boxhead)
}

dt_boxhead_edit_column_label <- function(data, var, column_label) {

  dt_boxhead_edit(
    data = data,
    var = var,
    column_label = column_label
  )
}

dt_boxhead_get_vars <- function(data) {
  dt_boxhead_get(data = data)$var
}

dt_boxhead_get_vars_default <- function(data) {
  df <- dt_boxhead_get(data = data)
  df$var[df$type == "default"]
}

dt_boxhead_get_var_stub <- function(data) {

  res <- dt_boxhead_get_var_by_type(data = data, type = "stub")
  # FIXME: don't return NA_character_ here, just return res or NULL
  if (length(res) == 0) {
    NA_character_
  } else {
    res
  }
}

dt_boxhead_get_vars_groups <- function(data) {

  res <- dt_boxhead_get_var_by_type(data = data, type = "row_group")
  # FIXME: don't return NA_character_ here, just return res or NULL
  if (length(res) == 0) {
    NA_character_
  } else {
    res
  }
}

dt_boxhead_get_alignments_in_stub <- function(data) {

  stub_layout <- get_stub_layout(data = data)

  c(
    if ("group_label" %in% stub_layout) {
      dt_boxhead_get_alignment_by_var(
        data = data,
        dt_boxhead_get_vars_groups(data = data)
      )
    },
    if ("rowname" %in% stub_layout) {
      dt_boxhead_get_alignment_by_var(
        data = data,
        dt_boxhead_get_var_stub(data = data)
      )
    }
  )
}

dt_boxhead_get_var_by_type <- function(data, type) {
  boxhead <- dt_boxhead_get(data = data)
  boxhead$var[boxhead$type == type]
}

dt_boxhead_get_vars_labels_default <- function(data) {
  boxhead <- dt_boxhead_get(data = data)
  unlist(boxhead$column_label[boxhead$type == "default"])
}

dt_boxhead_get_vars_align_default <- function(data) {
  boxhead <- dt_boxhead_get(data = data)
  boxhead$column_align[boxhead$type == "default"]
}

dt_boxhead_get_alignment_by_var <- function(data, var) {
  boxhead <- dt_boxhead_get(data = data)
  boxhead$column_align[boxhead$var == var]
}

check_names_dt_boxhead_expr <- function(expr) {

  if (!all(names(expr) %in% c(
    "type", "column_label", "column_align", "column_width", "hidden_px"
  ))) {
    cli::cli_abort("Expressions must use names available in `dt_boxhead`.")
  }
}

check_vars_dt_boxhead <- function(var, dt_boxhead) {

  if (!(var %in% dt_boxhead$var)) {
    cli::cli_abort("The `var` value must be value in `dt_boxhead$var`.")
  }
}

dt_boxhead_build <- function(data, context) {

  boxh <- dt_boxhead_get(data = data)

  boxh$column_label <-
    lapply(boxh$column_label, function(label) process_text(label, context))

  dt_boxhead_set(data = data, boxh = boxh)
}

dt_boxhead_set_var_order <- function(data, vars) {

  boxh <- dt_boxhead_get(data = data)

  if (
    length(vars) != nrow(boxh) ||
    length(unique(vars)) != nrow(boxh) ||
    !all(vars %in% boxh$var)
  ) {
    cli::cli_abort("The length of `vars` must equal the row count of `_boxh`.")
  }

  order_vars <- vapply(vars, function(x) {which(boxh$var == x)}, numeric(1))

  boxh <- boxh[order_vars, ]

  dt_boxhead_set(data = data, boxh = boxh)
}
