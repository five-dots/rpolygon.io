get_key <- function() {
  Sys.getenv("POLYGON_KEY")
}

has_key <- function() {
  !identical(get_key(), "")
}

merge_args <- function(args = NULL) {
  c(args, list(apiKey = get_key()))
}

check_http_status <- function(res) {
  if (res$status_code < 400) return(invisible())

  msg <- parse(res)$message
  stop("HTTP failure: ", res$status_code, "\n", msg, call. = FALSE)
}

extract_error_str <- function(str) {
  stringr::str_match(str, "^\n\\s*(.*)\n\\s*$")[, 2]
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

parse_dt_from_msec <- function(msec, tz = "America/New_York") {
  stopifnot(is.numeric(msec), length(msec) > 0,
            is.character(tz), length(tz) == 1)
  as.POSIXct(msec/1000, origin = "1970-01-01", tz = tz) + 0.0005
}

#' Pipe operator
#' @name %>%
#' @importFrom magrittr %>%
NULL

#' dplyr pronoun
#' @name .data
#' @importFrom rlang .data
NULL
