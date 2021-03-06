context("listLearners")

test_that("listLearners", {
  x1 = listLearners(create = FALSE, warn.missing.packages = FALSE)
  expect_data_frame(x1, min.rows = 1L, min.cols = 10)
  expect_set_equal(x1$type, c("classif", "regr", "cluster", "surv", "multilabel"))
  expect_subset(listLearnerProperties(), names(x1))

  x1a = listLearners("classif", create = FALSE, properties = c("missings"), warn.missing.packages = FALSE)
  expect_data_frame(x1a, min.rows = 10)
  expect_true(nrow(x1a) < nrow(x1))
  expect_character(x1a$note, any.missing = FALSE)

  x = listLearners(multiclass.task, create = FALSE, warn.missing.packages = FALSE)
  expect_data_frame(x, min.rows = 20, min.cols = 3)
  expect_true(all(x$type == "classif"))

  x = listLearners("surv", properties = c("factors", "missings", "weights"), create = TRUE,
    warn.missing.packages = FALSE)
  expect_list(x, "Learner", min.len = 1L)

  # test that listLearners works without a type and just requested properties, we had a bug here
  x = listLearners(properties = "factors", create = FALSE)
  expect_data_frame(x, min.rows = 20, min.cols = 3)
  expect_true(length(unique(x$type)) > 3L)
})

test_that("listLearners printer (#1336)", {
  x1 = listLearners(create = FALSE, warn.missing.packages = FALSE)
  options(width = 1000)
  out = capture.output(print(x1), file = NULL)
  expect_equal(length(stri_match_all(out, regex = '\n')), 9)
  out = capture.output(print(x1, n = 10), file = NULL)
  expect_equal(length(stri_match_all(out, regex = '\n')), 13)
  options(width = 80)
})
