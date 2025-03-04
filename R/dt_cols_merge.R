.dt_col_merge_key <- "_col_merge"

dt_col_merge_get <- function(data) {
  dt__get(data, .dt_col_merge_key)
}

dt_col_merge_set <- function(data, col_merge) {
  dt__set(data, .dt_col_merge_key, col_merge)
}

dt_col_merge_init <- function(data) {
  dt_col_merge_set(data = data, col_merge = list())
}

dt_col_merge_add <- function(data, col_merge) {
  added <- append(dt_col_merge_get(data = data), list(col_merge))
  dt_col_merge_set(data = data, col_merge = added)
}

dt_col_merge_entry <- function(vars, type, pattern = NULL, ...) {

  if (!(type %in% c("merge", "merge_range", "merge_uncert", "merge_n_pct"))) {
    cli::cli_abort("Invalid `type` provided.")
  }

  list(
    vars = vars,
    type = type,
    pattern = pattern,
    ...
  )
}
