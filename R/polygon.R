#' GET data from Polygon.io API
#'
#' @param path API path by a character scalar
#' @param args Query arguments by named list or named vector
#' @param ... Addtional arguments for httr::GET()
#'
#' @return API response parsed by jsonlite::fromJSON()
#' @export
polygon <- function(path, args = NULL, ...) {
  if (!has_key()) stop("POLYGON_KEY not found", call. = FALSE)
  stopifnot(length(path) == 1, is.character(path))

  url <- paste0(base_url, path)
  res <- httr::GET(url,
                   query = merge_args(args),
                   httr::accept_json(),
                   ## HACK Force to use HTTP1.1 (2 means version 1.1),
                   ## to avoid the following error.
                   ## Error in curl::curl_fetch_memory(url, handle = handle) :
                   ##   Error in the HTTP2 framing layer
                   httr::config(http_version = 2),
                   ...)

  check_http_status(res)
  parse(res)
}
