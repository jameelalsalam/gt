.dt_stub_df_key <- "_stub_df"

dt_stub_df_get <- function(data) {
  dt__get(data, .dt_stub_df_key)
}

dt_stub_df_set <- function(data, stub_df) {
  dt__set(data, .dt_stub_df_key, stub_df)
}

dt_stub_df_init <- function(
    data,
    rowname_col,
    groupname_col,
    row_group.sep
) {

  data_tbl <- dt_data_get(data = data)

  # Create the `stub_df` table
  stub_df <-
    dplyr::tibble(
      rownum_i = seq_len(nrow(data_tbl)),
      group_id = rep(NA_character_, nrow(data_tbl)),
      rowname = rep(NA_character_, nrow(data_tbl)),
      row_id = rep(NA_character_, nrow(data_tbl)),
      group_label = rep(list(NULL), nrow(data_tbl)),
      indent = rep(NA_character_, nrow(data_tbl)),
      built = rep(NA_character_, nrow(data_tbl))
    )

  # Put the `rowname_cols`'s data into `stub_df`
  if (!is.null(rowname_col) && rowname_col %in% colnames(data_tbl)) {

    data <- dt_boxhead_set_stub(data = data, var = rowname_col)

    rownames <- data_tbl[[rowname_col]]

    # Place the `rowname` values into `stub_df$rowname`
    stub_df[["rowname"]] <- as.character(rownames)

    #
    # Develop unique ID values for the `row_id` values
    #

    row_id <- rep(NA_character_, length(rownames))

    for (i in seq_along(rownames)) {

      if (is.na(rownames[i])) {
        row_id[i] <- as.character(i)
      }

      if (!is.na(rownames[i])) {
        row_id[i] <- rownames[i]

        if (i > 1 && row_id[i] %in% row_id[1:(i - 1)]) {
          row_id[i] <- paste0(row_id[i], "__", i)
        }
      }
    }

    stub_df[["row_id"]] <- row_id
  }

  # If `data` is a `grouped_df` then create groups from the
  # group columns; note that this will overwrite any values
  # already in `stub_df$group_id`
  if (
    !is.null(groupname_col) &&
    length(groupname_col) > 0 &&
    all(groupname_col %in% colnames(data_tbl))
  ) {

    row_group_ids <-
      apply(
        data_tbl[, groupname_col],
        MARGIN = 1,
        FUN = paste,
        collapse = row_group.sep
      )

    # Place the `group_labels` values into `stub_df$group_id`
    stub_df[["group_id"]] <- row_group_ids
    stub_df[["group_label"]] <- as.list(row_group_ids)

    data <- dt_boxhead_set_row_group(data = data, vars = groupname_col)
  }

  # Stop if input `data` has no columns (after modifying `data` for groups)
  if (ncol(data_tbl) == 0) {
    cli::cli_abort(
      "The `data` must have at least one column that isn't a 'group' column."
    )
  }

  dt_stub_df_set(data = data, stub_df = stub_df)
}

dt_stub_df_exists <- function(data) {

  stub_df <- dt_stub_df_get(data = data)

  !all(is.na((stub_df)[["rowname"]]))
}

dt_stub_df_build <- function(data, context) {

  stub_df <- dt_stub_df_get(data = data)

  stub_df$built <-
    vapply(
      stub_df$group_label,
      FUN.VALUE = character(1),
      FUN = function(label) {
        if (!is.null(label)) {
          process_text(label, context)
        } else {
          ""
        }
      }
    )

  dt_stub_df_set(data = data, stub_df = stub_df)
}

# Function to obtain a reordered version of `stub_df`
reorder_stub_df <- function(data) {

  stub_df <- dt_stub_df_get(data = data)

  row_groups <- dt_row_groups_get(data = data)

  rows_df <-
    get_row_reorder_df(
      groups = row_groups,
      stub_df = stub_df
    )

  stub_df <- stub_df[rows_df$rownum_final, ]

  dt_stub_df_set(data = data, stub_df = stub_df)
}

dt_stub_groupname_has_na <- function(data) {

  stub_df <- dt_stub_df_get(data = data)

  any(is.na(stub_df$group_id))
}

dt_stub_components <- function(data) {

  stub_df <- dt_stub_df_get(data = data)

  stub_components <- c()

  if (any(!is.na(stub_df[["group_id"]]))) {
    stub_components <- c(stub_components, "group_id")
  }

  if (any(!is.na(stub_df[["rowname"]])) && !all(stub_df[["rowname"]] == "")) {
    stub_components <- c(stub_components, "rowname")
  }

  stub_components
}

# Function that checks `stub_components` and determines whether just the
# `rowname` part is available; TRUE indicates that we are working with a table
# with rownames
dt_stub_components_is_rowname <- function(stub_components) {
  identical(stub_components, "rowname")
}

# Function that checks `stub_components` and determines whether just the
# `group_id` part is available; TRUE indicates that we are working with a table
# with groups but it doesn't have rownames
dt_stub_components_is_groupname <- function(stub_components) {
  identical(stub_components, "group_id")
}

# Function that checks `stub_components` and determines whether the
# `rowname` and `group_id` parts are available; TRUE indicates that we are
# working with a table with rownames and groups
dt_stub_components_is_rowname_groupname <- function(stub_components) {
  identical(stub_components, c("group_id", "rowname"))
}

dt_stub_components_has_rowname <- function(stub_components) {
  isTRUE("rowname" %in% stub_components)
}

dt_stub_rowname_at_position <- function(data, i) {

  stub_components <- dt_stub_components(data = data)

  if (!(dt_stub_components_has_rowname(stub_components = stub_components))) {
    return(NULL)
  }

  dt_stub_df_get(data = data)$rowname[[i]]
}

dt_stub_indentation_at_position <- function(data, i) {

  indent_i <- dt_stub_df_get(data = data)$indent[[i]]

  if (is.na(indent_i)) {
    return(NULL)
  }

  as.integer(indent_i)
}
