#' GET data from Polygon.io API
#'
#' @param endpoint API endpoint by a character scalar
#' @param args Query arguments by named list or named vector
#' @param ... Addtional arguments for httr::GET()
#'
#' @return API response parsed by jsonlite::fromJSON()
#' @export
rpolygon <- function(endpoint, args = NULL, ...) {
  if (!has_key()) stop("POLYGON_KEY not found", call. = FALSE)
  stopifnot(length(endpoint) == 1, is.character(endpoint))

  base_url <- "https://api.polygon.io"
  url <- paste0(base_url, endpoint)
  res <- httr::GET(url,
                   query = merge_args(args),
                   httr::accept_json(),
                   ## HACK
                   ## Force to use HTTP1.1 (2 means version 1.1),
                   ## to avoid the following error.
                   ##   Error in the HTTP2 framing layer
                   ## httr::config(http_version = 2),
                   ...)

  ## TODO replace with stop_for_status()
  check_http_status(res)
  parse(res)
}
