test_that("Computing mininum precision", {
  expect_gt(machine_precision(), 0)
  expect_equal(1 - machine_precision(), 1)
})
