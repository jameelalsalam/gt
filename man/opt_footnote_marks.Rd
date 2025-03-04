% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/opts.R
\name{opt_footnote_marks}
\alias{opt_footnote_marks}
\title{Option to modify the set of footnote marks}
\usage{
opt_footnote_marks(data, marks)
}
\arguments{
\item{data}{A table object that is created using the \code{\link[=gt]{gt()}} function.}

\item{marks}{Either a character vector of length greater than 1 (that will
represent the series of marks) or a single keyword that represents a preset
sequence of marks. The valid keywords are: \code{"numbers"} (for numeric marks),
\code{"letters"} and \code{"LETTERS"} (for lowercase and uppercase alphabetic marks),
\code{"standard"} (for a traditional set of four symbol marks), and \code{"extended"}
(which adds two more symbols to the standard set).}
}
\value{
An object of class \code{gt_tbl}.
}
\description{
Alter the footnote marks for any footnotes that may be present in the table.
Either a vector of marks can be provided (including Unicode characters), or,
a specific keyword could be used to signify a preset sequence. This function
serves as a shortcut for using \code{tab_options(footnotes.marks = {marks})}
}
\details{
We can supply a vector of that will represent the series of marks.
The series of footnote marks is recycled when its usage goes beyond the
length of the set. At each cycle, the marks are simply doubled, tripled, and
so on (e.g., \code{*} -> \verb{**} -> \verb{***}). The option exists for providing keywords
for certain types of footnote marks. The keywords are:
\itemize{
\item \code{"numbers"}: numeric marks, they begin from 1 and these marks are not
subject to recycling behavior
\item \code{"letters"}: miniscule alphabetic marks, internally uses the \code{letters}
vector which contains 26 lowercase letters of the Roman alphabet
\item \code{"LETTERS"}: majuscule alphabetic marks, using the \code{LETTERS} vector
which has 26 uppercase letters of the Roman alphabet
\item \code{"standard"}: symbolic marks, four symbols in total
\item \code{"extended"}: symbolic marks, extends the standard set by adding two
more symbols, making six
}
}
\section{Examples}{


Use \code{\link{sza}} to create a \strong{gt} table, adding three footnotes. Call
\code{opt_footnote_marks()} to specify which footnote marks to use.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{sza \%>\%
  dplyr::filter(latitude == 30) \%>\%
  dplyr::group_by(tst) \%>\%
  dplyr::summarize(
    SZA.Max = if (
      all(is.na(sza))) \{
      NA
    \} else \{
      max(sza, na.rm = TRUE)
    \},
    SZA.Min = if (
      all(is.na(sza))) \{
      NA
    \} else \{
      min(sza, na.rm = TRUE)
    \},
    .groups = "drop"
  ) \%>\%
  gt(rowname_col = "tst") \%>\%
  tab_spanner_delim(delim = ".") \%>\%
  sub_missing(
    columns = everything(),
    missing_text = "90+"
  ) \%>\%
  tab_stubhead(label = "TST") \%>\%
  tab_footnote(
    footnote = "True solar time.",
    locations = cells_stubhead()
  ) \%>\%
  tab_footnote(
    footnote = "Solar zenith angle.",
    locations = cells_column_spanners(
      spanners = "spanner-SZA.Max"
    )
  ) \%>\%
  tab_footnote(
    footnote = "The Lowest SZA.",
    locations = cells_stub(rows = "1200")
  ) \%>\%
  opt_footnote_marks(marks = "standard")
}\if{html}{\out{</div>}}

\if{html}{\out{
<img src="https://raw.githubusercontent.com/rstudio/gt/master/images/man_opt_footnote_marks_1.png" alt="This image of a table was generated from the first code example in the `opt_footnote_marks()` help file." style="width:100\%;">
}}
}

\section{Function ID}{

9-1
}

\seealso{
Other table option functions: 
\code{\link{opt_align_table_header}()},
\code{\link{opt_all_caps}()},
\code{\link{opt_css}()},
\code{\link{opt_horizontal_padding}()},
\code{\link{opt_row_striping}()},
\code{\link{opt_stylize}()},
\code{\link{opt_table_font}()},
\code{\link{opt_table_lines}()},
\code{\link{opt_table_outline}()},
\code{\link{opt_vertical_padding}()}
}
\concept{table option functions}
