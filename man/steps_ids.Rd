% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/misc.R
\name{steps_ids}
\alias{steps_ids}
\title{Get step_ids from recipe}
\usage{
steps_ids(rec, type = "all")
}
\arguments{
\item{rec}{A Recipe object.}

\item{type}{character vector indicating the type class. Options \code{c("all", "da", "prepro")}.}
}
\value{
character vector
}
\description{
Get step_ids from recipe
}
\examples{
data(test_rec)

## We can extract the step identifiers from a Recipe with `step_ids`
ids <- steps_ids(test_rec)
ids

## With the `type` parameter, extract the prepro and da steps separately.
da_ids <- steps_ids(test_rec, type = "da")
da_ids

prepro_ids <- steps_ids(test_rec, type = "prepro")
prepro_ids
}
