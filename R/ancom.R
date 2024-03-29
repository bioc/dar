#' ANCOM analysis
#'
#' Determine taxa whose absolute abundances, per unit volume, of the ecosystem
#' (e.g., gut) are significantly different with changes in the covariate of
#' interest (e.g., group). The current version of ancombc2 function implements
#' Analysis of Compositions of Microbiomes with Bias Correction (ANCOM-BC2) in
#' cross-sectional and repeated measurements data. In addition to the two-group
#' comparison, ANCOM-BC2 also supports testing for continuous covariates and
#' multi-group comparisons, including the global test, pairwise directional
#' test, Dunnett's type of test, and trend test.
#'
#' @param rec A Recipe object. The step will be added to the sequence of
#'   operations for this Recipe.
#' @param fix_formula the character string expresses how the microbial absolute
#'   abundances for each taxon depend on the fixed effects in metadata. When
#'   specifying the fix_formula, make sure to include the group variable in the
#'   formula if it is not NULL.
#' @param rand_formula the character string expresses how the microbial absolute
#'   abundances for each taxon depend on the random effects in metadata.
#'   ANCOM-BC2 follows the lmerTest package in formulating the random effects.
#'   See ?lmerTest::lmer for more details. Default is NULL.
#' @param p_adj_method character. method to adjust p-values. Default is "holm".
#'   Options include "holm", "hochberg", "hommel", "bonferroni", "BH", "BY",
#'   "fdr", "none". See ?stats::p.adjust for more details.
#' @param prv_cut a numerical fraction between 0 and 1. Taxa with prevalences
#'   less than prv_cut will be excluded in the analysis. For instance, suppose
#'   there are 100 samples, if a taxon has nonzero counts presented in less than
#'   10 samples, it will not be further analyzed. Default is 0.10.
#' @param lib_cut a numerical threshold for filtering samples based on library
#'   sizes. Samples with library sizes less than lib_cut will be excluded in the
#'   analysis. Default is 0, i.e. do not discard any sample.
#' @param s0_perc a numerical fraction between 0 and 1. Inspired by Significance
#'   Analysis of Microarrays (SAM) methodology, a small positive constant is
#'   added to the denominator of ANCOM-BC2 test statistic corresponding to each
#'   taxon to avoid the significance due to extremely small standard errors,
#'   especially for rare taxa. This small positive constant is chosen as
#'   s0_perc-th percentile of standard error values for each fixed effect.
#'   Default is 0.05 (5th percentile).
#' @param group character. The name of the group variable in metadata. group
#'   should be discrete. Specifying group is required for detecting structural
#'   zeros and performing multi-group comparisons (global test, pairwise
#'   directional test, Dunnett's type of test, and trend test). Default is NULL.
#'   If the group of interest contains only two categories, leave it as NULL.
#' @param struc_zero logical. Whether to detect structural zeros based on group.
#'   Default is FALSE. See Details for a more comprehensive discussion on
#'   structural zeros.
#' @param neg_lb logical. Whether to classify a taxon as a structural zero using
#'   its asymptotic lower bound. Default is FALSE.
#' @param alpha numeric. Level of significance. Default is 0.05.
#' @param n_cl numeric. The number of nodes to be forked. For details, see
#'   ?parallel::makeCluster. Default is 1 (no parallel computing).
#' @param verbose logical. Whether to generate verbose output during the
#'   ANCOM-BC2 fitting process. Default is FALSE.
#' @param global logical. Whether to perform the global test. Default is FALSE.
#' @param pairwise logical. Whether to perform the pairwise directional test.
#'   Default is FALSE.
#' @param dunnet logical. Whether to perform the Dunnett's type of test. Default
#'   is FALSE.
#' @param trend logical. Whether to perform trend test. Default is FALSE.
#' @param rarefy Boolean indicating if OTU counts must be rarefyed. This
#'   rarefaction uses the standard R sample function to resample from the
#'   abundance values in the otu_table component of the first argument, physeq.
#'   Often one of the major goals of this procedure is to achieve parity in
#'   total number of counts between samples, as an alternative to other formal
#'   normalization procedures, which is why a single value for the sample.size
#'   is expected. If 'no_seed', rarefaction is performed without a set seed. 
#' @param id A character string that is unique to this step to identify it.
#'
#' @include recipe-class.R
#' @family Diff taxa steps
#' @aliases step_ancom
#' @return An object of class `Recipe`
#' @export
#' @autoglobal
#' @tests
#' data(metaHIV_phy)
#' 
#' test <-
#'  recipe(metaHIV_phy, "RiskGroup2", "Phylum") |>
#'  step_subset_taxa(tax_level = "Kingdom", taxa = c("Bacteria", "Archaea")) |>
#'  step_filter_by_prevalence() |> 
#'  step_ancom()
#'  
#' expect_s4_class(prep(test), "PrepRecipe") |> 
#'   expect_snapshot()
#' 
#' data(test_prep_rec)
#' expect_error(step_ancom(test_prep_rec, rarefy = TRUE))
#' @examples
#' data(metaHIV_phy)
#'
#' ## Init Recipe
#' rec <-
#'   recipe(metaHIV_phy, "RiskGroup2", "Phylum") |>
#'   step_subset_taxa(tax_level = "Kingdom", taxa = c("Bacteria", "Archaea")) |>
#'   step_filter_taxa(.f = "function(x) sum(x > 0) >= (0.4 * length(x))")
#'
#' rec
#'
#' ## Define step with default parameters and prep
#' rec <-
#'   step_ancom(rec) |>
#'   prep(parallel = FALSE)
#'
#' rec
#'
#' ## Wearing rarefaction only for this step
#' rec <-
#'   recipe(metaHIV_phy, "RiskGroup2", "Species") |>
#'   step_ancom(rarefy = TRUE)
#'
#' rec
methods::setGeneric(
  name = "step_ancom",
  def = function(rec,
                 fix_formula = get_var(rec)[[1]],
                 rand_formula = NULL,
                 p_adj_method = "holm",
                 prv_cut = 0.1,
                 lib_cut = 0,
                 s0_perc = 0.05,
                 group = NULL,
                 struc_zero = FALSE,
                 neg_lb = FALSE,
                 alpha = 0.05,
                 n_cl = 1,
                 verbose = FALSE,
                 global = FALSE,
                 pairwise = FALSE,
                 dunnet = FALSE,
                 trend = FALSE,
                 rarefy = FALSE, 
                 id = rand_id("ancom")) {
    standardGeneric("step_ancom")
  }
)

#' @rdname step_ancom
#' @export
#' @autoglobal
methods::setMethod(
  f = "step_ancom",
  signature = c(rec = "Recipe"),
  definition = function(rec,
                        fix_formula,
                        rand_formula,
                        p_adj_method,
                        prv_cut,
                        lib_cut,
                        s0_perc,
                        group,
                        struc_zero,
                        neg_lb,
                        alpha,
                        n_cl,
                        verbose,
                        global,
                        pairwise,
                        dunnet,
                        trend,
                        rarefy, 
                        id) {

    recipes_pkg_check(required_pkgs_ancom(), "step_ancom()")
    add_step(
      rec,
      step_ancom_new(
        fix_formula = fix_formula,
        rand_formula = rand_formula,
        p_adj_method = p_adj_method,
        prv_cut = prv_cut,
        lib_cut = lib_cut,
        s0_perc = s0_perc,
        group = group,
        struc_zero = struc_zero,
        neg_lb = neg_lb,
        alpha = alpha,
        n_cl = n_cl,
        verbose = verbose,
        global = global,
        pairwise = pairwise,
        dunnet = dunnet,
        trend = trend,
        rarefy = rarefy, 
        id = id
      )
    )
  }
)

#' @rdname step_ancom
#' @export
#' @autoglobal
methods::setMethod(
  f = "step_ancom",
  signature = c(rec = "PrepRecipe"),
  definition = function(rec,
                        fix_formula,
                        rand_formula,
                        p_adj_method,
                        prv_cut,
                        lib_cut,
                        s0_perc,
                        group,
                        struc_zero,
                        neg_lb,
                        alpha,
                        n_cl,
                        verbose,
                        global,
                        pairwise,
                        dunnet,
                        trend,
                        rarefy, 
                        id) {
    rlang::abort("This function needs a non-PrepRecipe!")
  }
)

#' @noRd
#' @keywords internal
#' @autoglobal
step_ancom_new <-
  function(fix_formula,
           rand_formula,
           p_adj_method,
           prv_cut,
           lib_cut,
           s0_perc,
           group,
           struc_zero,
           neg_lb,
           alpha,
           n_cl,
           verbose,
           global,
           pairwise,
           dunnet,
           trend,
           rarefy, 
           id) {
    step(
      subclass = "ancom",
      fix_formula = fix_formula,
      rand_formula = rand_formula,
      p_adj_method = p_adj_method,
      prv_cut = prv_cut,
      lib_cut = lib_cut,
      s0_perc = s0_perc,
      group = group,
      struc_zero = struc_zero,
      neg_lb = neg_lb,
      alpha = alpha,
      n_cl = n_cl,
      verbose = verbose,
      global = global,
      pairwise = pairwise,
      dunnet = dunnet,
      trend = trend,
      rarefy = rarefy, 
      id = id
    )
  }

#' @noRd
#' @keywords internal
#' @autoglobal
required_pkgs_ancom <- function(x, ...) { c("bioc::ANCOMBC") }

#' @noRd
#' @keywords internal
#' @autoglobal
run_ancom <- function(rec,
                      fix_formula,
                      rand_formula,
                      p_adj_method,
                      prv_cut,
                      lib_cut,
                      s0_perc,
                      group,
                      struc_zero,
                      neg_lb,
                      alpha,
                      n_cl,
                      verbose,
                      global,
                      pairwise,
                      dunnet,
                      trend,
                      rarefy, 
                      id) {
  
  vars <- get_var(rec)[[1]]
  tax_level <- get_tax(rec)[[1]]
  phy <- 
    get_phy(rec) %>% 
    use_rarefy(rarefy)
  
  phy <- phyloseq::tax_glom(phy, taxrank = tax_level, NArm = FALSE)
  vars %>%
    purrr::set_names() %>%
    purrr::map(function(var) {
      get_comparisons(var, phy, as_list = TRUE, n_cut = 1) %>%
        purrr::map_dfr(function(comparison) {
          vct_comp <- glue::glue("c('{comparison[1]}', '{comparison[2]}')")
          s_phy <-
            glue::glue(
              "phyloseq::subset_samples(phy, {var} %in% {vct_comp})"
            ) %>%
            parse(text = .) %>%
            eval()
          
          ## Remove OTUs with zero variance
          to_remove <- rm_zero_variance(s_phy, vars)
          
          s_phy <- 
            rownames(phyloseq::otu_table(s_phy)) %>% 
            .[!. %in% to_remove] %>% 
            phyloseq::prune_taxa(s_phy)
          
          res <- ANCOMBC::ancombc2(
            data = s_phy, 
            tax_level = tax_level,
            fix_formula = fix_formula,
            rand_formula = rand_formula,
            p_adj_method = p_adj_method,
            prv_cut = prv_cut,
            lib_cut = lib_cut,
            s0_perc = s0_perc,
            group = group,
            struc_zero = struc_zero,
            neg_lb = neg_lb,
            alpha = alpha,
            n_cl = n_cl,
            verbose = verbose,
            global = global,
            pairwise = pairwise,
            dunnet = dunnet,
            trend = trend
          )
        
          ancom_stats_tbl(res$res, var, rec, comparison)
        })
    }) 
}

#' @noRd
#' @keywords internal
#' @autoglobal
ancom_stats_tbl <- function(ancom_res, var, rec, comparison) {
  ancom_res %>%
    dplyr::select(taxa = taxon, dplyr::contains(!!var)) %>%
    dplyr::right_join(tax_table(rec), ., by = "taxa") %>%
    stats::setNames(
      stringr::str_remove_all(names(.), stringr::str_c("_", var, ".*"))
    ) %>%
    dplyr::mutate(
      comparison = stringr::str_c(comparison, collapse = "_"),
      var = var,
      effect = lfc,
      signif = diff
    )
}

#' @noRd
#' @keywords internal
#' @autoglobal
rm_zero_variance <- function(phy, vars) {
  phyloseq::sample_data(phy) %>%
    tibble::as_tibble(rownames = "sample_id") %>%
    dplyr::group_split(!!dplyr::sym(vars)) %>% 
    purrr::map_dfr(~ { 
      .x %>% 
        dplyr::pull(sample_id) %>% 
        phyloseq::prune_samples(phy) %>% 
        phyloseq::filter_taxa(function(x) var(x) > 0) %>% 
        tibble::as_tibble(rownames = "otu_id")
    }) %>% 
    dplyr::filter(value == FALSE) %>% 
    dplyr::pull(otu_id) 
}
