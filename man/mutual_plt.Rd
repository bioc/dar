% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_methods.R
\name{mutual_plt}
\alias{mutual_plt}
\alias{mutual_plt,Recipe-method}
\alias{mutual_plt,PrepRecipe-method}
\title{Mutual finding plot}
\usage{
mutual_plt(
  rec,
  count_cutoff = NULL,
  comparisons = NULL,
  steps = steps_ids(rec, type = "da"),
  top_n = 20
)

\S4method{mutual_plt}{Recipe}(
  rec,
  count_cutoff = NULL,
  comparisons = NULL,
  steps = steps_ids(rec, type = "da"),
  top_n = 20
)

\S4method{mutual_plt}{PrepRecipe}(
  rec,
  count_cutoff = NULL,
  comparisons = NULL,
  steps = steps_ids(rec, type = "da"),
  top_n = 20
)
}
\arguments{
\item{rec}{A Recipe or Recipe step.}

\item{count_cutoff}{Indicates the minimum number of methods in which an OTU
must be present (Default: NULL). If count_cutoff is NULL count_cutoff is
equal to \code{length(steps_ids(rec, "da")) * 2 / 3}.}

\item{comparisons}{By default, this function plots all comparisons. However,
if the user indicates the comparison or comparisons of interest, only the
selected ones will be plotted.}

\item{steps}{Character vector with step_ids to take in account. Default all
"da" methods.}

\item{top_n}{Maximum number of taxa to represent. Default: 20.}
}
\value{
ggplot2
}
\description{
Plots number of differentially abundant features mutually found by defined
number of methods, colored by the differential abundance direction and
separated by comparison.
}
\examples{
data(test_prep_rec)

## Running the function returns a tile plot,
mutual_plt(test_prep_rec)

## The count_cutoff indicates the minimum number of methods in which an OTU
## must be present. By default the value is equal to
## length(steps_ids(rec, "da")) * 2 / 3 but it is customizable.
mutual_plt(
  test_prep_rec, 
  count_cutoff = length(steps_ids(test_prep_rec, "da"))
)

## A single comparisons can be plotted through the comparison parameter.
mutual_plt(test_prep_rec, comparisons = c("hts_msm"))

## If you want to exclude a method for the plot, you can remove it with the
## step parameter. In the following example we eliminate from the graph the
## results of maaslin.
mutual_plt(test_prep_rec, steps = steps_ids(test_prep_rec, "da")[-1])

## mutual_plt function needs a PrepRecipe. If you pass a a non-PrepRecipe
## the output is an error.
data(test_rec)
err <- testthat::expect_error(mutual_plt(test_rec))
err
}
