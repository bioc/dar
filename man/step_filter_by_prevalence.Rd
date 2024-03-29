% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filter_by_prevalence.R
\name{step_filter_by_prevalence}
\alias{step_filter_by_prevalence}
\alias{step_filter_by_prevalence,Recipe-method}
\alias{step_filter_by_prevalence,PrepRecipe-method}
\title{Filter taxa by prevalence}
\usage{
step_filter_by_prevalence(
  rec,
  threshold = 0.01,
  id = rand_id("filter_by_prevalence")
)

\S4method{step_filter_by_prevalence}{Recipe}(
  rec,
  threshold = 0.01,
  id = rand_id("filter_by_prevalence")
)

\S4method{step_filter_by_prevalence}{PrepRecipe}(
  rec,
  threshold = 0.01,
  id = rand_id("filter_by_prevalence")
)
}
\arguments{
\item{rec}{A Recipe object. The step will be added to the sequence of
operations for this Recipe.}

\item{threshold}{The prevalence threshold for filtering taxa, expressed as a
proportion of the total number of samples. For example, a threshold of 0.01
means that a taxon must be present in at least 1\% of the samples to be
retained. The default value is 0.01.}

\item{id}{A character string that is unique to this step to identify it.}
}
\value{
A Recipe object that has been filtered based on prevalence.
}
\description{
This is a convenience function around the filter_taxa function. It is
designed to speed up filtering complex experimental objects with one function
call. In the case of run_filter_by_prevalence, the filtering will be based on
the prevalence of each taxon. The taxa retained in the dataset are those
where the prevalence is greater than the provided threshold.
}
\details{
The function calculates the prevalence of all taxa in the phyloseq
object as the proportion of samples in which they are present. It then
compares this prevalence to the threshold. If a taxon's prevalence is less
than the threshold, that taxon is removed from the phyloseq object.
}
\note{
This function modifies \code{rec} in place, you might want to make a copy of
\code{rec} before modifying it if you need to preserve the original object.
}
\examples{
data(metaHIV_phy)

## Init Recipe
rec <- recipe(metaHIV_phy, "RiskGroup2", "Phylum")
rec

## Define step_filter_by_prevalence step with default parameters
rec <- step_filter_by_prevalence(rec, threshold = 0.01)
rec
}
\seealso{
\code{\link[phyloseq]{filter_taxa}}

Other filter phy steps: 
\code{\link{step_filter_by_abundance}()},
\code{\link{step_filter_by_rarity}()},
\code{\link{step_filter_by_variance}()},
\code{\link{step_filter_taxa}()}
}
\concept{filter phy steps}
