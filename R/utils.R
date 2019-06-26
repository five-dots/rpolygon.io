
base_url <- "https://api.polygon.io/"

polygon_key <- function() {
  Sys.getenv("POLYGON_KEY")
}

has_key <- function() {
  !identical(polygon_key(), "")
}

merge_args <- function(args = NULL) {
  c(args, list(apiKey = polygon_key()))
}

set_http_version <- function() {
  ## HACK Force to use HTTP1.1 (2 means version 1.1),
  ## to avoid the following error.
  ## Error in curl::curl_fetch_memory(url, handle = handle) :
  ##   Error in the HTTP2 framing layer
  httr::set_config(httr::config(http_version = 2))
  invisible()
}

#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL
