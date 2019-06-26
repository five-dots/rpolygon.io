
## "splits" is not supported. Use v1/meta/symbols/{symbol}/splits insted.
valid_reference_types <- c("tickers", "markets", "locales", "types")

#' Retrieve reference data
#'
#' @param type Reference type
#' @param args Query arguments
#' @param ... Addtional arguments for httr::GET()
#'
#' @return list(status, results)
#' @export
polygon_reference <- function(type = "markets", args = NULL, ...) {
  stopifnot(has_key(),
            length(type) == 1,
            type %in% valid_reference_types)

  set_http_version()

  req_url <- glue::glue("{base_url}v2/reference/{type}")
  queries <- merge_args(args)
  response <- httr::GET(req_url, query = queries, ...)

  json <- httr::content(response, as = "text", encoding = "ISO-8859-1")
  ## TODO Check status
  jsonlite::fromJSON(json)
}
