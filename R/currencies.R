#' Get Valid Currencies
#' @family Cryptocurrencies
#' @return A character vector of valid currencies supported by coinmarketcap API
#' @examples
#' get_valid_currencies()
#' @export
get_valid_currencies <- function() {
    c("AUD", "BRL", "CAD", "CHF",
      "CLP", "CNY", "CZK", "DKK",
      "EUR", "GBP", "HKD", "HUF",
      "IDR", "ILS", "INR", "JPY",
      "KRW", "MXN", "MYR", "NOK",
      "NZD", "PHP", "PKR", "PLN",
      "RUB", "SEK", "SGD", "THB",
      "TRY", "TWD", "ZAR", "USD")
}

#' Get all active cryptocurrencies supported by the
#' platform including a unique id
#' @title Get active cryptocurrencies
#'
#' @param ... Further arguments passed to the request. Further information
#' can be found in the \href{https://coinmarketcap.com/api/documentation/v1/#operation}{API documentation}
#'
#' @references \href{https://coinmarketcap.com/api/documentation/v1/#operation/getV1CryptocurrencyMap}{API documentation}
#' @family Cryptocurrencies
#' @return A dataframe with all active cryptocurrencies supported by the
#' platform including a unique id for each cryptocurrency.
#' @examples \dontrun{
#' get_crypto_map()
#' get_crypto_map(symbol="BTC")
#' get_crypto_map(symbol=c("BTC","ETH"))
#' get_crypto_map(listing_status = "active", start = 1, limit = 10)
#' get_crypto_map(listing_status = "inactive", start = 1, limit = 10)
#' }
#' @export
get_crypto_map <- function(...) {
    ## Input Check ##########
    base_url <- .get_baseurl()

    ## Build Request (new API) ##########
    what <- "cryptocurrency/map"
    whatelse <- list(...)
    if (length(whatelse) > 0) {
        whatelse <- transform_args(whatelse)
        if (!is.null(whatelse)) {
            what <- paste0(what, "?", whatelse)
        }
    }
    apiurl <- sprintf("https://%s/v1/%s", base_url, what)

    ## Make Request ##########
    req <- make_request(apiurl)

    ## Check Response ##########
    check_response(req)

    ## Modify Result ##########
    modify_result(req$content, case = 3)
}

#' Get all static metdata available for one or more cryptocurrencies
#' @title Get static metdata
#'
#' @inheritParams get_exchange_meta
#' @param symbol One or more cryptocurrency symbols.
#' Example: c("BTC","ETH").
#'
#' @references \href{https://coinmarketcap.com/api/documentation/v1/#operation/getV1CryptocurrencyInfo}{API documentation}
#' @note At least one "id" or "slug" or "symbol" is required for this request.
#' @family Cryptocurrencies
#' @return A dataframe with metadata of Cryptocurrencies
#' @examples \dontrun{
#' get_crypto_meta()
#' get_crypto_meta(symbol = c("BTC","ETH"))
#' get_crypto_meta(id = c(1,2,3,4))
#' get_crypto_meta(slug = c("bitcoin", "ethereum"))
#' }
#' @export
get_crypto_meta <- function(symbol=NULL, id=NULL, slug=NULL) {
    ## Input Check ##########
    base_url <- .get_baseurl()

    ## Build Request (new API) ##########
    what <- paste0("cryptocurrency/info?")

    args <- c(is.null(symbol), is.null(id), is.null(slug))
    if (sum(args) == 3) {
        symbol <- "BTC"
    } else if (sum(args) != 2) {
        stop(cat(crayon::red(cli::symbol$cross,
                             "You must use either 'symbol', 'id' or 'slug'.\n")))
    }
    if (!is.null(symbol))
        what <- paste0(what, "symbol=", paste(symbol, collapse = ","))
    if (!is.null(id))
        what <- paste0(what, "id=", paste(id, collapse = ","))
    if (!is.null(slug))
        what <- paste0(what, "slug=", paste(slug, collapse = ","))

    apiurl <- sprintf("https://%s/v1/%s", base_url, what)

    ## Make Request ##########
    req <- make_request(apiurl)

    ## Check Response ##########
    check_response(req)

    ## Modify Result ##########
    modify_result(req$content, case = 4)
}

#' Get a paginated list of all active cryptocurrencies with latest market data.
#' The default "market_cap" sort returns cryptocurrency in order of CoinMarketCap's
#' market cap rank (as outlined in our methodology) but you may configure this call
#' to order by another market ranking field.
#' Use the "convert" option to return market values in multiple fiat and
#' cryptocurrency conversions in the same call.
#' @title Get latest/historical market data
#' @references \href{https://coinmarketcap.com/api/documentation/v1/#operation/getV1CryptocurrencyListingsLatest}{API documentation}
#'
#' @inheritParams get_global_marketcap
#'
#' @family Cryptocurrencies
#' @return A dataframe of top Cryptocurrencies with current or historic market data
#' @examples \dontrun{
#' get_crypto_listings('EUR')
#' get_crypto_listings('GBP')
#' get_crypto_listings('GBP', latest=F, start=1,
#'                     date=Sys.Date()-20, limit=10, sort="price", sort_dir="asc")
#' }
#' @export
get_crypto_listings <- function(currency = "USD", latest = TRUE, ...) {
    ## Input Check ##########
    stopifnot(currency %in% get_valid_currencies())

    apikey <- .get_api_key()
    ## Using old API
    if (is.null(apikey)) {
        d <- curl_fetch_memory(
          paste0("https://api.coinmarketcap.com/v1/ticker/?convert=",
                 currency, "&limit=0"))
        check_response(d)
        d <- data.frame(fromJSON(rawToChar(d$content)))

        d[, 4:15] <- apply(d[, 4:15], 2, function(x)
            as.numeric(as.character(x)))
        d$last_updated  <- as.POSIXct(d$last_updated,
                                      origin = as.Date("1970-01-01"))
        return(d)
    }

    base_url <- .get_baseurl()

    # for extra parameters like limit ########

    whatelse <- list(...)

    ## Build Request (new API) ##########
    if (latest) {
        what <- paste0("cryptocurrency/listings/latest?convert=", currency)
    } else {
        what <- paste0("cryptocurrency/listings/historical?convert=", currency)

        if (!"date" %in% names(whatelse)) {
            stop(cat(crayon::red(cli::symbol$cross,
                                 "A 'date' argument is needed for historical data.\n")))
        }

    }

    # respecting extra paramaters ########

    whatelse <- transform_args(whatelse)
    if (!is.null(whatelse))
      what <- paste0(what, "&", whatelse)

    apiurl <- sprintf("https://%s/v1/%s", base_url, what)

    ## Make Request ##########
    req <- make_request(apiurl)

    ## Check Response ##########
    check_response(req)

    ## Modify Result ##########
    modify_result(req$content, case = 3)
}

#' Deprecated use \code{\link[coinmarketcapr]{get_crypto_listings}} instead.
#' @description get_marketcap_ticker_all is replaced by \code{\link[coinmarketcapr]{get_crypto_listings}} to
#' support the new API and more functionality.
#'
#' @param currency currency code - Default is 'USD'
#'
#' @return A dataframe of top Cryptocurrencies with id, name, symbol, rank, price_usd, price_btc, 24h_volume_usd, market_cap_usd, available_supply, total_supply, percent_change_1h, percent_change_24h, percent_change_7d, last_updated
#' @family Cryptocurrencies
#' @keywords internal
#'
#' @examples \dontrun{
#' get_marketcap_ticker_all('EUR')
#' get_marketcap_ticker_all('GBP')
#' }
#' @export
get_marketcap_ticker_all <- function(currency = 'USD') {
  .Deprecated(
    new = "get_crypto_listings",
    msg = "`get_marketcap_ticker_all` will be replaced by `get_crypto_listings` to support the new API specifications."
  )
  get_crypto_listings(currency)
}

#' Get the latest/historical market quotes for 1 or more cryptocurrencies
#' @title Get market quotes
#'
#' @inheritParams get_crypto_meta
#' @param currency currency code - Default is 'USD'
#' @param latest If `TRUE` (default), only the latest data is retrieved,
#' otherwise historical data is returned. (NOTE: Historic Data require higher API rights)
#' @param ... Further arguments can be passed to historical data. Further information
#' can be found in the \href{https://coinmarketcap.com/api/documentation/v1/#operation/getV1CryptocurrencyQuotesLatest}{API documentation}
#'
#' @references \href{https://coinmarketcap.com/api/documentation/v1/#operation/getV1CryptocurrencyQuotesLatest}{API documentation}
#' @note At least one "id" or "slug" or "symbol" is required for this request.
#' @return A dataframe with the latest market quote for 1 or more cryptocurrencies
#' @family Cryptocurrencies
#' @examples \dontrun{
#' get_crypto_quotes()
#' get_crypto_quotes(symbol="ETH")
#' get_crypto_quotes(symbol=c("ETH","BTC"))
#' get_crypto_quotes(slug=c("litecoin","dogecoin"))
#' get_crypto_quotes("EUR", id=c(3,4))
#' get_crypto_quotes(latest = FALSE, symbol = c("BTC","ETH"),
#'                   time_start = Sys.Date()-180, time_end=Sys.Date(), count = 10,
#'                   interval = "30m")
#' }
#' @export
get_crypto_quotes <- function(currency = "USD",
                              symbol = NULL, slug = NULL, id = NULL,
                              latest = TRUE,
                              ...) {
    ## Input Check ##########
    stopifnot(currency %in% get_valid_currencies())

    base_url <- .get_baseurl()

    ## Build Request (new API) ##########
    if (latest) {
        what <- paste0("cryptocurrency/quotes/latest?convert=", currency)
        args <- c(is.null(symbol), is.null(id), is.null(slug))
        if (sum(args) == 3) {
            symbol <- "BTC"
        } else if (sum(args) != 2) {
            stop(cat(crayon::red(cli::symbol$cross,
                                 "You must use either 'symbol', 'id' or 'slug'.\n")))
        }
        if (!is.null(symbol))
            what <- paste0(what, "&symbol=", paste(symbol, collapse = ","))
        if (!is.null(id))
            what <- paste0(what, "&id=", paste(id, collapse = ","))
        if (!is.null(slug))
            what <- paste0(what, "&slug=", paste(slug, collapse = ","))
    } else {
        what <- paste0("cryptocurrency/quotes/historical?convert=", currency)
        args <- c(is.null(symbol), is.null(id))
        if (sum(args) == 2) {
            symbol <- "BTC"
        } else if (sum(args) != 1) {
            stop(cat(crayon::red(cli::symbol$cross,
                                 "You must use either 'symbol' or 'id'.\n")))
        }
        if (!is.null(symbol))
            what <- paste0(what, "&symbol=", paste(symbol, collapse = ","))
        if (!is.null(id))
            what <- paste0(what, "&id=", paste(id, collapse = ","))

        whatelse <- list(...)
        whatelse <- transform_args(whatelse)
        if (!is.null(whatelse)) {
            what <- paste0(what, "&", whatelse)
        }
    }

    apiurl <- sprintf("https://%s/v1/%s", base_url, what)

    ## Make Request ##########
    req <- make_request(apiurl)

    ## Check Response ##########
    check_response(req)

    ## Modify Result ##########
    if (latest) {
      modify_result(req$content, case = 4)
    }
    else {
      modify_result(req$content, case = 1)
    }
}

#' Get a list of all active market pairs that CoinMarketCap tracks for a
#' given cryptocurrency or fiat currency
#' @title List all active market pairs
#' @references \href{https://coinmarketcap.com/api/documentation/v1/#operation/getV1CryptocurrencyMarketpairsLatest}{API documentation}
#' @inheritParams get_crypto_meta
#' @param currency currency code - Default is 'USD'
#' @param start Optionally offset the start (1-based index) of the paginated
#' list of items to return. - Default is 1
#' @param limit Optionally specify the number of results to return.
#' Use this parameter and the "start" parameter to determine your own
#' pagination size.
#' @note A single cryptocurrency "id", "slug", or "symbol" is required.
#' @family Cryptocurrencies
#' @return A dataframe with all active market pairs
#' @examples \dontrun{
#' get_crypto_marketpairs("EUR")
#' get_crypto_marketpairs("EUR", slug = "bitcoin")
#' get_crypto_marketpairs("EUR", symbol = "LTC")
#' get_crypto_marketpairs("EUR", symbol = "BTC", start = 10, limit = 20)
#' }
#' @export
get_crypto_marketpairs <- function(currency = "USD",
                                   symbol=NULL, id=NULL, slug=NULL,
                                   start=NULL, limit=NULL) {
    ## Input Check ##########
    stopifnot(currency %in% get_valid_currencies())

    base_url <- .get_baseurl()

    ## Build Request (new API) ##########
    what <- paste0("cryptocurrency/market-pairs/latest?convert=", currency)
    args <- c(is.null(symbol), is.null(id), is.null(slug))
    if (sum(args) == 3) {
        symbol <- "BTC"
    } else if (sum(args) != 2) {
            stop(cat(crayon::red(cli::symbol$cross,
                                 "You must use either 'symbol', 'id' or 'slug'.\n")))
    }
    if (!is.null(symbol))
        what <- paste0(what, "&symbol=", paste(symbol, collapse = ","))
    if (!is.null(id))
        what <- paste0(what, "&id=", paste(id, collapse = ","))
    if (!is.null(slug))
        what <- paste0(what, "&slug=", paste(slug, collapse = ","))
    if (!is.null(start))
        what <- paste0(what, "&start=", start)
    if (!is.null(limit))
        what <- paste0(what, "&limit=", limit)

    apiurl <- sprintf("https://%s/v1/%s", base_url, what)

    ## Make Request ##########
    req <- make_request(apiurl)

    ## Check Response ##########
    check_response(req)

    ## Modify Result ##########
    modify_result(req$content)
}

#' Return the latest/historical OHLCV (Open, High, Low, Close, Volume) market values for
#' one or more cryptocurrencies for the current UTC day. Since the current UTC
#' day is still active these values are updated frequently. You can find the
#' final calculated OHLCV values for the last completed UTC day along with
#' all historic days using /cryptocurrency/ohlcv/historical.
#' @title List latest/historical OHLCV values
#' @references \href{https://coinmarketcap.com/api/documentation/v1/#operation/getV1CryptocurrencyOhlcvLatest}{API documentation}
#' @inheritParams get_crypto_map
#' @param latest If `TRUE` (default), only the latest data is retrieved,
#' otherwise historical data is returned.
#' @param currency currency code - Default is 'USD'
#' @param symbol One or more cryptocurrency symbols.
#' Example: c("BTC","ETH").
#' @param id Alternatively pass one or more CoinMarketCap cryptocurrency IDs.
#' Example: c(1,2)
#' @note One of "id" or "symbol" is required for this request.
#' @family Cryptocurrencies
#' @return A dataframe with OHLCV values
#' @examples \dontrun{
#' get_crypto_ohlcv("EUR")
#' get_crypto_ohlcv("EUR", latest = F)
#' get_crypto_ohlcv("EUR", latest = F, time_period = "hourly",
#'                  time_start=Sys.Date()-180, count=5, interval="monthly")
#' }
#' @export
get_crypto_ohlcv <- function(currency = "USD", latest = TRUE,
                             symbol=NULL, id=NULL, ...) {
    ## Input Check ##########
    stopifnot(currency %in% get_valid_currencies())

    base_url <- .get_baseurl()

    ## Build Request (new API) ##########
    args <- c(is.null(symbol), is.null(id))
    if (sum(args) == 2) {
        symbol <- "BTC"
    } else if (sum(args) != 1) {
        stop(cat(crayon::red(cli::symbol$cross,
                             "You must use either 'symbol' or 'id'.\n")))
    }
    if (latest) {
        what <- paste0("cryptocurrency/ohlcv/latest?convert=", currency)
        if (!is.null(symbol))
            what <- paste0(what, "&symbol=", paste(symbol, collapse = ","))
        if (!is.null(id))
            what <- paste0(what, "&id=", paste(id, collapse = ","))
    } else {
        what <- paste0("cryptocurrency/ohlcv/historical?convert=", currency)
        if (!is.null(symbol))
            what <- paste0(what, "&symbol=", paste(symbol, collapse = ","))
        if (!is.null(id))
            what <- paste0(what, "&id=", paste(id, collapse = ","))
        whatelse <- list(...)
        whatelse <- transform_args(whatelse)
        if (!is.null(whatelse)) {
            what <- paste0(what, "&", whatelse)
        }
    }

    apiurl <- sprintf("https://%s/v1/%s", base_url, what)

    ## Make Request ##########
    req <- make_request(apiurl)

    ## Check Response ##########
    check_response(req)

    ## Modify Result ##########
    if (latest) {
        modify_result(req$content, case = 4)
    } else {
        modify_result(req$content)
    }
}
