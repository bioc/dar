
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dar

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/MicrobialGenomics-IrsicaixaOrg/dar/workflows/R-CMD-check/badge.svg)](https://github.com/MicrobialGenomics-IrsicaixaOrg/dar/actions)
<!-- badges: end -->

The goal of dar is to …

## Installation

You can install the development version of dar from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("MicrobialGenomics-IrsicaixaOrg/dar")
```

## Example

``` r
## Recipe preparation with preporcessing and DA steps. 
rec <- 
  recipe(metaHIV_phy, "RiskGroup2", "Species") %>% 
  step_subset_taxa(expr = 'Kingdom %in% c("Bacteria", "Archaea")') %>% 
  step_filter_taxa(.f = "function(x) sum(x > 0) >= (0.02 * length(x))") %>% 
  step_ancom() %>%
  step_aldex() %>%
  step_deseq() %>%
  step_corncob() %>%
  step_metagenomeseq() %>%
  step_maaslin() %>%
  step_lefse()

## Run steps in parallel (if you have problem run in serie)
da_results <- prep(rec, parallel = TRUE)

## Exploration
intersection_plt(da_results, steps = steps_ids(da_results, "da")[], ordered_by = "degree")
find_intersections(da_results)

## Extract results
bake(da_results, overlap = 0.9, exclude = NULL)

## Export steps
export_steps(rec, "test.json")

## Import steps
rec <- 
  recipe(metaHIV_phy, "RiskGroup2", "Species") %>% 
  import_steps("test.json")
```

## Code of Conduct

Please note that the dar project is released with a [Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
