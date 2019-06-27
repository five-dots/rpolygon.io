context("Test polygon functions")

test_that("polygon() returns correct data.", {

  ## Prepare test data
  ## paths <- c("v2/reference/tickers",
  ##            "v2/reference/markets",
  ##            "v2/reference/locales",
  ##            "v2/reference/types")

  ## test_data <- purrr::map(paths, polygon)

  ## args <- list(sort = "ticker", type = "cs", market = "stocks", locale = "us",
  ##              ## search = "A",
  ##              perpage = 500, page = 1, active = "true")
  ## tickers <- polygon_reference("v2/reference/tickers", args, httr::verbose())

  ## Run tests for all formats
  ## purrr::walk(test_data, ~{
  ##   expect_is(.x, "list")
  ## })

  ## Error check
  ## expect_error(polygon_reference("splits"))
})
