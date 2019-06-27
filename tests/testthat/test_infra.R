context("Test infra functions")

test_that("merge_args() returns correct data.", {

  ## Only apiKey
  test1 <- merge_args()
  expect_is(test1, "list")
  expect_is(test1$apiKey, "character")
  expect_named(test1, "apiKey")

  ## Add one argument
  test2 <- merge_args(list(hoge = 10))
  expect_is(test2, "list")
  expect_is(test2$apiKey, "character")
  expect_is(test2$hoge, "numeric")
  expect_named(test2, c("hoge", "apiKey"))
})

test_that("extract_error_str() returns correct data.", {
  text <- "\n    Error\n   "
  expect_equal(extract_error_str(text), "Error")
})
