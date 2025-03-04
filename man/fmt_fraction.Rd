% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format_data.R
\name{fmt_fraction}
\alias{fmt_fraction}
\title{Format values as a mixed fractions}
\usage{
fmt_fraction(
  data,
  columns,
  rows = everything(),
  accuracy = NULL,
  simplify = TRUE,
  layout = c("inline", "diagonal"),
  use_seps = TRUE,
  pattern = "{x}",
  sep_mark = ",",
  system = c("intl", "ind"),
  locale = NULL
)
}
\arguments{
\item{data}{A table object that is created using the \code{\link[=gt]{gt()}} function.}

\item{columns}{The columns to format. Can either be a series of column names
provided in \code{\link[=c]{c()}}, a vector of column indices, or a helper function
focused on selections. The select helper functions are: \code{\link[=starts_with]{starts_with()}},
\code{\link[=ends_with]{ends_with()}}, \code{\link[=contains]{contains()}}, \code{\link[=matches]{matches()}}, \code{\link[=one_of]{one_of()}}, \code{\link[=num_range]{num_range()}}, and
\code{\link[=everything]{everything()}}.}

\item{rows}{Optional rows to format. Providing \code{\link[=everything]{everything()}} (the
default) results in all rows in \code{columns} being formatted. Alternatively,
we can supply a vector of row captions within \code{\link[=c]{c()}}, a vector of row
indices, or a helper function focused on selections. The select helper
functions are: \code{\link[=starts_with]{starts_with()}}, \code{\link[=ends_with]{ends_with()}}, \code{\link[=contains]{contains()}}, \code{\link[=matches]{matches()}},
\code{\link[=one_of]{one_of()}}, \code{\link[=num_range]{num_range()}}, and \code{\link[=everything]{everything()}}. We can also use expressions
to filter down to the rows we need (e.g.,
\verb{[colname_1] > 100 & [colname_2] < 50}).}

\item{accuracy}{The type of fractions to generate. This can either be one of
the keywords \code{"low"}, \code{"med"}, or \code{"high"} (to generate fractions with
denominators of up to 1, 2, or 3 digits, respectively) or an integer value
greater than zero to obtain fractions with a fixed denominator (\code{2} yields
halves, \code{3} is for thirds, \code{4} is quarters, etc.). For the latter option,
using \code{simplify = TRUE} will simplify fractions where possible (e.g., \code{2/4}
will be simplified as \code{1/2}). By default, the \code{"low"} option is used.}

\item{simplify}{If choosing to provide a numeric value for \code{accuracy}, the
option to simplify the fraction (where possible) can be taken with \code{TRUE}
(the default). With \code{FALSE}, denominators in fractions will be fixed to the
value provided in \code{accuracy}.}

\item{layout}{For HTML output, the \code{"inline"} layout is the default. This
layout places the numerals of the fraction on the baseline and uses a
standard slash character. The \code{"diagonal"} layout will generate fractions
that are typeset with raised/lowered numerals and a virgule.}

\item{use_seps}{An option to use digit group separators. The type of digit
group separator is set by \code{sep_mark} and overridden if a locale ID is
provided to \code{locale}. This setting is \code{TRUE} by default.}

\item{pattern}{A formatting pattern that allows for decoration of the
formatted value. The value itself is represented by \code{{x}} and all other
characters are taken to be string literals.}

\item{sep_mark}{The mark to use as a separator between groups of digits
(e.g., using \code{sep_mark = ","} with \code{1000} would result in a formatted value
of \verb{1,000}).}

\item{system}{The numbering system to use. By default, this is the
international numbering system (\code{"intl"}) whereby grouping separators
(i.e., \code{sep_mark}) are separated by three digits. The alternative system,
the Indian numbering system (\code{"ind"}) uses grouping separators that
correspond to thousand, lakh, crore, and higher quantities.}

\item{locale}{An optional locale ID that can be used for formatting the value
according the locale's rules. Examples include \code{"en"} for English (United
States) and \code{"fr"} for French (France). The use of a valid locale ID will
override any values provided in \code{sep_mark} and \code{dec_mark}. We can use the
\code{\link[=info_locales]{info_locales()}} function as a useful reference for all of the locales that
are supported. Any \code{locale} value provided here will override any global
locale setting performed in \code{\link[=gt]{gt()}}'s own \code{locale} argument.}
}
\value{
An object of class \code{gt_tbl}.
}
\description{
With numeric values in a \strong{gt} table, we can perform mixed-fraction-based
formatting. There are several options for setting the accuracy of the
fractions. Furthermore, there is an option for choosing a layout (i.e.,
typesetting style) for the mixed-fraction output.

The following options are available for controlling this type of formatting:
\itemize{
\item accuracy: how to express the fractional part of the mixed fractions; there
are three keyword options for this and an allowance for arbitrary denominator
settings
\item simplification: an option to simplify fractions whenever possible
\item layout: We can choose to output values with diagonal or inline fractions
\item digit grouping separators: options to enable/disable digit separators
and provide a choice of separator symbol for the whole number portion
\item pattern: option to use a text pattern for decoration of the formatted
mixed fractions
\item locale-based formatting: providing a locale ID will result in number
formatting specific to the chosen locale
}
}
\section{Targeting the values to be formatted}{


Targeting of values is done through \code{columns} and additionally by \code{rows} (if
nothing is provided for \code{rows} then entire columns are selected). Conditional
formatting is possible by providing a conditional expression to the \code{rows}
argument. See the \emph{Arguments} section for more information on this.
}

\section{Examples}{


Use \code{\link{pizzaplace}} to create a \strong{gt} table. Format the \code{f_sold} and
\code{f_income} columns to display fractions.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{pizzaplace \%>\%
  dplyr::group_by(type, size) \%>\%
  dplyr::summarize(
    sold = dplyr::n(),
    income = sum(price),
    .groups = "drop_last"
  ) \%>\%
  dplyr::group_by(type) \%>\%
  dplyr::mutate(
    f_sold = sold / sum(sold),
    f_income = income / sum(income),
  ) \%>\%
  dplyr::arrange(type, dplyr::desc(income)) \%>\%
  gt(rowname_col = "size") \%>\%
  tab_header(
    title = "Pizzas Sold in 2015",
    subtitle = "Fraction of Sell Count and Revenue by Size per Type"
  ) \%>\%
  fmt_integer(columns = sold) \%>\%
  fmt_currency(columns = income) \%>\%
  fmt_fraction(
    columns = starts_with("f_"),
    accuracy = 10,
    simplify = FALSE,
    layout = "diagonal"
  ) \%>\%
  sub_missing(missing_text = "") \%>\%
  tab_spanner(
    label = "Sold",
    columns = contains("sold")
  ) \%>\%
  tab_spanner(
    label = "Revenue",
    columns = contains("income")
  ) \%>\%
  text_transform(
    locations = cells_body(),
    fn = function(x) \{
      dplyr::case_when(
        x == 0 ~ "<em>nil</em>",
        x != 0 ~ x
      )
    \}
  ) \%>\%
  cols_label(
    sold = "Amount",
    income = "Amount",
    f_sold = md("_f_"),
    f_income = md("_f_")
  ) \%>\%
  cols_align(align = "center", columns = starts_with("f")) \%>\%
  tab_options(
    table.width = px(400),
    row_group.as_column = TRUE
  )
}\if{html}{\out{</div>}}

\if{html}{\out{
<img src="https://raw.githubusercontent.com/rstudio/gt/master/images/man_fmt_fraction_1.png" alt="This image of a table was generated from the first code example in the `fmt_fraction()` help file." style="width:100\%;">
}}
}

\section{Function ID}{

3-7
}

\seealso{
Other data formatting functions: 
\code{\link{data_color}()},
\code{\link{fmt_bytes}()},
\code{\link{fmt_currency}()},
\code{\link{fmt_datetime}()},
\code{\link{fmt_date}()},
\code{\link{fmt_duration}()},
\code{\link{fmt_engineering}()},
\code{\link{fmt_integer}()},
\code{\link{fmt_markdown}()},
\code{\link{fmt_number}()},
\code{\link{fmt_partsper}()},
\code{\link{fmt_passthrough}()},
\code{\link{fmt_percent}()},
\code{\link{fmt_roman}()},
\code{\link{fmt_scientific}()},
\code{\link{fmt_time}()},
\code{\link{fmt}()},
\code{\link{sub_large_vals}()},
\code{\link{sub_missing}()},
\code{\link{sub_small_vals}()},
\code{\link{sub_zero}()},
\code{\link{text_transform}()}
}
\concept{data formatting functions}
