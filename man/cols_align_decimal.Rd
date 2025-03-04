% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/modify_columns.R
\name{cols_align_decimal}
\alias{cols_align_decimal}
\title{Align all numeric values in a column along the decimal mark}
\usage{
cols_align_decimal(data, columns = everything(), dec_mark = ".", locale = NULL)
}
\arguments{
\item{data}{A table object that is created using the \code{\link[=gt]{gt()}} function.}

\item{columns}{The columns for which the alignment should be applied. By
default this is set to \code{everything()} which means that the chosen alignment
affects all columns.}

\item{dec_mark}{The character used as a decimal mark in the numeric values to
be aligned. If a locale value was used when formatting the numeric values
then \code{locale} is better to use and it will override any value here in
\code{dec_mark}.}

\item{locale}{An optional locale ID that can be used to obtain the type of
decimal mark used in the numeric values to be aligned. Examples include
\code{"en"} for English (United States) and \code{"fr"} for French (France). The use
of a valid locale ID will override any value provided in \code{dec_mark}. We can
use the \code{\link[=info_locales]{info_locales()}} function as a useful reference for all of the
locales that are supported. Any \code{locale} value provided here will override
any global locale setting performed in \code{\link[=gt]{gt()}}'s own \code{locale} argument.}
}
\value{
An object of class \code{gt_tbl}.
}
\description{
For numeric columns that contain values with decimal portions, it is
sometimes useful to have them lined up along the decimal mark for easier
readability. We can do this with \code{cols_align_decimal()} and provide any
number of columns (the function will skip over columns that don't require
this type of alignment).
}
\section{Examples}{


Let's put together a two-column table to create a \strong{gt} table. The first
column \code{char} just contains letters whereas the second column, \code{num}, has a
collection of numbers and \code{NA} values. We could format the numbers with
\code{\link[=fmt_number]{fmt_number()}} and elect to drop the trailing zeros past the decimal mark
with \code{drop_trailing_zeros = TRUE}. This can leave formatted numbers that are
hard to scan through because the decimal mark isn't fixed horizontally. We
could remedy this and align the numbers by the decimal mark with
\code{cols_align_decimal()}.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{dplyr::tibble(
  char = LETTERS[1:9],
  num = c(1.2, -33.52, 9023.2, -283.527, NA, 0.401, -123.1, NA, 41)
) \%>\%
  gt() \%>\%
  fmt_number(
    columns = num,
    decimals = 3,
    drop_trailing_zeros = TRUE
  ) \%>\%
  cols_align_decimal()
}\if{html}{\out{</div>}}

\if{html}{\out{
<img src="https://raw.githubusercontent.com/rstudio/gt/master/images/man_cols_align_decimal_1.png" alt="This image of a table was generated from the first code example in the `cols_align_decimal()` help file." style="width:100\%;">
}}
}

\section{Function ID}{

4-2
}

\seealso{
Other column modification functions: 
\code{\link{cols_align}()},
\code{\link{cols_hide}()},
\code{\link{cols_label}()},
\code{\link{cols_merge_n_pct}()},
\code{\link{cols_merge_range}()},
\code{\link{cols_merge_uncert}()},
\code{\link{cols_merge}()},
\code{\link{cols_move_to_end}()},
\code{\link{cols_move_to_start}()},
\code{\link{cols_move}()},
\code{\link{cols_unhide}()},
\code{\link{cols_width}()}
}
\concept{column modification functions}
