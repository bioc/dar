# Generated by roxytest: do not edit by hand!

# File R/plot_methods.R: @tests

test_that("[unknown alias] @ L42", {
  data(test_rec)
  data(test_prep_rec)
  expect_error(corr_heatmap(test_rec))
  expect_s3_class(corr_heatmap(test_prep_rec), "plotly")
  expect_s3_class(
    corr_heatmap(test_prep_rec, steps = steps_ids(test_prep_rec, "da")[-1]), 
    "plotly"
  )
  expect_s3_class(corr_heatmap(test_prep_rec, type = "da"), "plotly")
})


test_that("[unknown alias] @ L152", {
  data(test_rec)
  data(test_prep_rec)
  expect_error(intersection_plt(test_rec))
  expect_s3_class(intersection_plt(test_prep_rec), "upset")
  expect_s3_class(
    intersection_plt(test_prep_rec, steps = steps_ids(test_prep_rec, "da")[-1]), 
    "upset"
  )
  expect_s3_class(intersection_plt(test_prep_rec, ordered_by = "degree"), "upset")
})


test_that("[unknown alias] @ L233", {
  data(test_rec)
  data(test_prep_rec)
  
  expect_error(exclusion_plt(test_rec))
  expect_s3_class(exclusion_plt(test_prep_rec), "ggplot")
  expect_s3_class(
    exclusion_plt(test_prep_rec, steps = steps_ids(test_prep_rec, "da")[-1]),
    "ggplot"
  )
})


test_that("[unknown alias] @ L373", {
  data(test_rec)
  data(test_prep_rec)
  taxa_ids <- c("Otu_96", "Otu_78", "Otu_88", "Otu_35", "Otu_94", "Otu_34")
  
  expect_error(abundance_plt(test_rec))
  expect_s3_class(suppressMessages(
    abundance_plt(test_prep_rec)), "ggplot"
  )
  expect_s4_class(suppressMessages(
    abundance_plt(test_prep_rec, type = "heatmap")), "HeatmapList"
  )
  expect_s3_class(suppressMessages(
    abundance_plt(test_prep_rec, taxa_ids = taxa_ids)), "ggplot"
  )
  expect_s3_class(suppressMessages(
    abundance_plt(test_prep_rec, top_n = 10)), "ggplot"
  )
  expect_s3_class(suppressMessages(
    abundance_plt(test_prep_rec, transform = "clr")), "ggplot"
  )
  expect_s4_class(
    abundance_plt(test_prep_rec, taxa_ids = taxa_ids, type = "heatmap"), 
    "HeatmapList"
  )
  expect_s3_class(suppressMessages(
    abundance_plt(test_prep_rec, transform = "scale", scale = 10)), "ggplot"
  )
})


test_that("[unknown alias] @ L680", {
  data(test_rec)
  data(test_prep_rec)
  
  expect_error(mutual_plt(test_rec))
  expect_s3_class(suppressMessages(mutual_plt(test_prep_rec)), "ggplot")
  expect_s3_class(suppressMessages(
    mutual_plt(test_prep_rec, count_cutoff = 2)), "ggplot"
  )
  expect_error(suppressMessages(mutual_plt(test_prep_rec, count_cutoff = 0)))
  expect_error(suppressMessages(mutual_plt(test_prep_rec, count_cutoff = 10)))
  expect_s3_class(suppressMessages(
    mutual_plt(test_prep_rec, comparisons = "hts_msm")), "ggplot"
  )
  expect_error(suppressMessages(
    mutual_plt(test_prep_rec, comparisons = "hts_sm"))
  )
  expect_s3_class(suppressMessages(
    mutual_plt(test_prep_rec, steps = steps_ids(test_prep_rec, "da")[-1])), 
    "ggplot"
  )
  expect_error(suppressMessages(mutual_plt(test_prep_rec, steps = "da")))
  expect_s3_class(suppressMessages(
    mutual_plt(test_prep_rec, top_n = 10)), "ggplot"
  )
  expect_error(suppressMessages(mutual_plt(test_prep_rec, top_n = 0)))
})

