#' Extract Global Market Cap of Cryptocurrency Market
#'
#' @param currency currency code - Default is 'USD'
#' @param latest If `TRUE` (default), only the latest data is retrieved,
#' otherwise historical data is returned. (NOTE: Historic Data require higher API rights)
#' @param ... Further arguments can be passed to historical data. Further information
#' can be found in the \href{https://coinmarketcap.com/api/documentation/v1/#operation/getV1GlobalmetricsQuotesHistorical}{API documentation}
#' @return A dataframe with global market cap of Cryptocurrencies
#' @family Global Metrics
#' @examples \dontrun{
#' get_global_marketcap('AUD')
#' get_global_marketcap('EUR')
#' get_global_marketcap(latest = FALSE, count = 10, interval = "yearly",
#'                      time_start = Sys.Date()-180, time_end = Sys.Date())
#'
#' }
#' @export
get_global_marketcap <- function(currency = "USD", latest = TRUE, ...) {
    ## Check Inputs ##########
    stopifnot(currency %in% get_valid_currencies())

    ## Input Check ##########
    apikey <- .get_api_key()
    ## Using old API ? ############
    if (is.null(apikey)) {
        d <- curl_fetch_memory(
            paste0("https://api.coinmarketcap.com/v1/global/?convert=",
                   currency))
        check_response(d)
        d <- data.frame(fromJSON(rawToChar(d$content)))

        d$last_updated  <- as.POSIXct(as.numeric(d$last_updated),
                                      origin = as.Date("1970-01-01"))
        return(d)
    }

    base_url <- .get_baseurl()

    ## Build Request (new API) ##########
    if (latest) {
        what <- paste0("global-metrics/quotes/latest?convert=", currency)
    } else {
        what <- paste0("global-metrics/quotes/historical?convert=", currency)
        whatelse <- list(...)
        whatelse <- transform_args(whatelse)
        what <- paste0(what, "&", whatelse)
    }

    apiurl <- sprintf("https://%s/v1/%s", base_url, what)

    ## Make Request ##########
    req <- make_request(apiurl)

    ## Check Response ##########
    check_response(req)

    ## Modify Result ##########
    # browser()
    modify_result(req$content)
}
