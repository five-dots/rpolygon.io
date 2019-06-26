context("Test reference functions")

test_that("polygon_referece() returns correct data.", {

  ## Prepare test data
  types <- c("tickers", "markets", "locales", "types")
  test_data <- purrr::map(types, polygon_reference)

  ## args <- list(sort = "ticker", type = "cs", market = "stocks", locale = "us",
  ##              ## search = "A",
  ##              perpage = 500, page = 1, active = "true")
  ## a <- polygon_reference("tickers", args, httr::verbose())
  ## a$tickers
  ## write.csv(a$tickers, "hoge.csv", row.names = FALSE)

  ## Run tests for all formats
  purrr::walk(test_data, ~{
    expect_is(.x, "list")
  })

  ## Error check
  expect_error(polygon_reference("splits"))
})
