#' GET daily trades/quote
#'
#' @param symbol Symbol
#' @param date Date
#' @param type trades or quotes
#'
#' @return data.frame
#' @export
rpolygon_historic <- function(symbol, date, type = "trades") {
  stopifnot(is.character(symbol), length(symbol) == 1,
           (lubridate::is.Date(date) | is.character(date)),
            type %in% c("trades", "quotes"),
            length(date) == 1)

  max_size <- 50000
  args <- list(limit = max_size, offset = NULL)
  ticks <- list()

  ## Loop while returned ticks is NULL
  repeat {
    path <- paste("/v1/historic", type, symbol, date, sep = "/")
    res <- rpolygon(path, args)
    if (is.null(res$ticks)) break

    ticks <- append(ticks, list(res$ticks))

    if (nrow(res$ticks) < max_size) break

    args$offset <- utils::tail(res$ticks$t, 1)
  }

  if (length(ticks) == 0) return(NULL)

  df <- dplyr::bind_rows(ticks) %>%
    dplyr::mutate(date_time = parse_dt_from_msec(.data$t))

  switch(type,
         "trades" = parse_trades(df),
         "quotes" = parse_quotes(df))
}

parse_trades <- function(df) {
  df %>%
    dplyr::mutate(conditions = stringr::str_c(.data$c1,
                                              .data$c2,
                                              .data$c3,
                                              .data$c4,
                                              sep = "|")) %>%
    dplyr::rename(price = .data$p,
                  size = .data$s,
                  exchange = .data$e) %>%
    dplyr::select(.data$date_time,
                  .data$price,
                  .data$size,
                  .data$exchange,
                  .data$conditions)
}

parse_quotes <- function(df) {
  df %>%
    dplyr::rename(condition = .data$c,
                  bid_exchange = .data$bE,
                  ask_exchange = .data$aE,
                  bid_price = .data$bP,
                  bid_size = .data$bS,
                  ask_price = .data$aP,
                  ask_size = .data$aS) %>%
    dplyr::select(.data$date_time,
                  .data$bid_exchange,
                  .data$bid_size,
                  .data$bid_price,
                  .data$ask_price,
                  .data$ask_size,
                  .data$ask_exchange,
                  .data$condition)
}
