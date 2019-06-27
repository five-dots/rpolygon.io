
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

check_http_status <- function(res) {
  if (res$status_code < 400) return(invisible())

  msg <- parse(res)$message
  stop("HTTP failure: ", res$status_code, "\n", msg, call. = FALSE)
}

extract_error_str <- function(str) {
  stringr::str_match(str, "^\n\\s*(.*)\n\\s*$")[,2]
}

extract_error <- function(text) {
  html <- xml2::read_html(text)

  ## h1 class = "title" contains "Error".
  title <- rvest::html_nodes(html, "h1.title") %>%
    rvest::html_text() %>%
    extract_error_str()

  ## p class = "subtitle" contains error message.
  subtitle <- rvest::html_nodes(html, "p.subtitle") %>%
    rvest::html_text() %>%
    extract_error_str()

  list(title = title, subtitle = subtitle)
}

parse <- function(res) {
  text <- httr::content(res, as = "text", encoding = "ISO-8859-1")

  ## Invalid request returns a HTML error page, not JSON.
  if (!jsonlite::validate(text)) {
    msg <- extract_error(text)
    stop(msg$subtitle, "\n", call. = FALSE)
  }

  jsonlite::fromJSON(text, simplifyVector = TRUE)
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
