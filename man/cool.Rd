% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/recipe-class.R
\name{cool}
\alias{cool}
\alias{cool,Recipe-method}
\alias{cool,PrepRecipe-method}
\title{Extract results from defined bake}
\usage{
cool(rec, bake = 1)

\S4method{cool}{Recipe}(rec, bake = 1)

\S4method{cool}{PrepRecipe}(rec, bake = 1)
}
\arguments{
\item{rec}{A \code{Recipe} object.}

\item{bake}{Name or index of the bake to extract.}
}
\value{
tbl_df
}
\description{
Extract results from defined bake
}
\examples{
data(test_prep_rec)

## First we need to add bakes (extraction strategies) to the PrepRecipe.
rec <- bake(test_prep_rec)

## Finally we can extract the results with the cool method
cool(rec)

## By default cool extracts the results of the first bake. If we have more
## bakes we can extract the one that you want with the bake parameter.
rec <- bake(rec, count_cutoff = 1)
cool(rec, 2)

## bake and cool methods needs a prep-Recipe. If you pass a non-PrepRecipe
## the output is an error.
data(test_rec)
err <- testthat::expect_error(cool(test_rec))
err
}
