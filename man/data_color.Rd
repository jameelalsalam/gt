% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_color.R
\name{data_color}
\alias{data_color}
\title{Set data cell colors using a palette or a color function}
\usage{
data_color(
  data,
  columns,
  colors,
  alpha = NULL,
  apply_to = c("fill", "text"),
  autocolor_text = TRUE,
  contrast_algo = c("apca", "wcag")
)
}
\arguments{
\item{data}{A table object that is created using the \code{\link[=gt]{gt()}} function.}

\item{columns}{The columns wherein changes to cell data colors should occur.}

\item{colors}{Either a color mapping function from the \strong{scales} package or
a vector of colors to use for each distinct value or level in each of the
provided \code{columns}. The color mapping functions are:
\code{\link[scales:col_numeric]{scales::col_quantile()}}, \code{\link[scales:col_numeric]{scales::col_bin()}}, \code{\link[scales:col_numeric]{scales::col_numeric()}}, and
\code{\link[scales:col_numeric]{scales::col_factor()}}. If providing a vector of colors as a palette, each
color value provided must either be a color name (in the set of colors
provided by \code{\link[grDevices:colors]{grDevices::colors()}}) or a hexadecimal string in the form of
"#RRGGBB" or "#RRGGBBAA".}

\item{alpha}{An optional, fixed alpha transparency value that will be applied
to all of the \code{colors} provided (regardless of whether a color palette was
directly supplied or generated through a color mapping function).}

\item{apply_to}{Which style element should the colors be applied to? Options
include the cell background (the default, given as \code{"fill"}) or the cell
text (\code{"text"}).}

\item{autocolor_text}{An option to let \strong{gt} modify the coloring of text
within cells undergoing background coloring. This will result in better
text-to-background color contrast. By default, this is set to \code{TRUE}.}

\item{contrast_algo}{The color contrast algorithm to use when
\code{autocolor_text = TRUE}. By default this is \code{"apca"} (Accessible Perceptual
Contrast Algorithm) and the alternative to this is \code{"wcag"} (Web Content
Accessibility Guidelines).}
}
\value{
An object of class \code{gt_tbl}.
}
\description{
It's possible to add color to data cells according to their values. The
\code{data_color()} function colors all rows of any \code{columns} supplied. There are
two ways to define how cells are colored: (1) through the use of a supplied
color palette, and (2) through use of a color mapping function available from
the \strong{scales} package. The first method colorizes cell data according to
whether values are character or numeric. The second method provides more
control over how cells are colored since we provide an explicit color
function and thus other requirements such as bin counts, cut points, or a
numeric domain. Finally, we can choose whether to apply the cell-specific
colors to either the cell background or the cell text.
}
\details{
The \verb{col_*()} color mapping functions from the scales package can be used in
the \code{colors} argument. These functions map data values (\code{numeric} or
\code{factor}/\code{character}) to colors according to the provided palette.

\itemize{
\item \code{\link[scales:col_numeric]{scales::col_numeric()}}: provides a simple linear mapping from
continuous numeric data to an interpolated palette.
\item \code{\link[scales:col_numeric]{scales::col_bin()}}: provides a mapping of continuous numeric data to
value-based bins. This internally uses the \code{\link[base:cut]{base::cut()}} function.
\item \code{\link[scales:col_numeric]{scales::col_quantile()}}: provides a mapping of continuous
numeric data to quantiles. This internally uses the
\code{\link[stats:quantile]{stats::quantile()}} function.
\item \code{\link[scales:col_numeric]{scales::col_factor()}}: provides a mapping of factors to colors. If the
palette is discrete and has a different number of colors than the number of
factors, interpolation is used.
}

By default, \strong{gt} will choose the ideal text color (for maximal contrast)
when colorizing the background of data cells. This option can be disabled by
setting \code{autocolor_text} to \code{FALSE}.

Choosing the right color palette can often be difficult because it's both
hard to discover suitable palettes and then obtain the vector of colors. To
make this process easier we can elect to use the \strong{paletteer} package,
which makes a wide range of palettes from various R packages readily
available. The \code{\link[=info_paletteer]{info_paletteer()}} information table allows us to easily
inspect all of the discrete color palettes available in \strong{paletteer}. We
only then need to specify the \code{package} and \code{palette} when calling the
\code{\link[paletteer:paletteer_d]{paletteer::paletteer_d()}} function, and, we get the palette as a vector of
hexadecimal colors.
}
\section{Examples}{


Use \code{\link{countrypops}} to create a \strong{gt} table. Apply a color scale to the
\code{population} column with \code{scales::col_numeric}, four supplied colors, and a
domain.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{countrypops \%>\%
  dplyr::filter(country_name == "Mongolia") \%>\%
  dplyr::select(-contains("code")) \%>\%
  tail(10) \%>\%
  gt() \%>\%
  data_color(
    columns = population,
    colors = scales::col_numeric(
      palette = c("red", "orange", "green", "blue"),
      domain = c(0.2E7, 0.4E7)
    )
  )
}\if{html}{\out{</div>}}

\if{html}{\out{
<img src="https://raw.githubusercontent.com/rstudio/gt/master/images/man_data_color_1.png" alt="This image of a table was generated from the first code example in the `data_color()` help file." style="width:100\%;">
}}

Use \code{\link{pizzaplace}} to create a \strong{gt} table. Apply colors from the
\code{"ggsci::red_material"} palette (it's in the \strong{ggsci} R package but more
easily gotten from the \strong{paletteer} package, info at \code{\link[=info_paletteer]{info_paletteer()}}) to
to \code{sold} and \code{income} columns. Setting the \code{domain} of
\code{scales::col_numeric()} to \code{NULL} will use the bounds of the available data
as the domain.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{pizzaplace \%>\%
  dplyr::filter(type \%in\% c("chicken", "supreme")) \%>\%
  dplyr::group_by(type, size) \%>\%
  dplyr::summarize(
    sold = dplyr::n(),
    income = sum(price),
    .groups = "drop"
  ) \%>\%
  gt(
    rowname_col = "size",
    groupname_col = "type"
  ) \%>\%
  data_color(
    columns = c(sold, income),
    colors = scales::col_numeric(
      palette = paletteer::paletteer_d(
        palette = "ggsci::red_material"
      ) \%>\%
        as.character(),
      domain = NULL
    )
  )
}\if{html}{\out{</div>}}

\if{html}{\out{
<img src="https://raw.githubusercontent.com/rstudio/gt/master/images/man_data_color_2.png" alt="This image of a table was generated from the second code example in the `data_color()` help file." style="width:100\%;">
}}
}

\section{Function ID}{

3-22
}

\seealso{
Other data formatting functions: 
\code{\link{fmt_bytes}()},
\code{\link{fmt_currency}()},
\code{\link{fmt_datetime}()},
\code{\link{fmt_date}()},
\code{\link{fmt_duration}()},
\code{\link{fmt_engineering}()},
\code{\link{fmt_fraction}()},
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
