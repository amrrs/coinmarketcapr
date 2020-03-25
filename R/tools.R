#' Convert an amount of one cryptocurrency or fiat currency into one or more different currencies
#' utilizing the latest market rate for each currency. You may optionally pass a historical
#' timestamp as time to convert values based on historical rates (as your API plan supports).
#' @title Price Conversion
#' @references \href{https://coinmarketcap.com/api/documentation/v1/#tag/tools}{API documentation}
#' @param amount An amount of currency to convert. Example: 10.43
#' @param id The CoinMarketCap currency ID of the base cryptocurrency or fiat to convert from.
#' If \code{id} and \code{symbol} are both missing or NULL, `BTC` is set as default symbol.
#' @param symbol Alternatively the currency symbol of the base cryptocurrency or fiat to convert from.
#' One \code{id} or \code{symbol} is required.
#' @param time Optional timestamp to reference historical pricing during conversion.
#' If not passed, the current time will be used. If passed, we'll reference the closest historic
#' values available for this conversion.
#' @param convert Pass up to 120 comma-separated fiat or cryptocurrency symbols to convert
#' the source amount to. Default is `USD`.
#' @param convert_id Optionally calculate market quotes by CoinMarketCap ID instead of symbol.
#' This option is identical to convert outside of ID format. Ex: convert_id=1,2781 would
#' replace convert=BTC,USD in your query. This parameter cannot be used when convert is used.
#' @family Tools
#' @details Cache / Update frequency:Every 60 seconds for the lastest cryptocurrency and fiat currency rates.
#' Plan credit use: 1 call credit per call and 1 call credit per convert option beyond the first.
#' CMC equivalent pages: Our cryptocurrency conversion page at \href{https://coinmarketcap.com/converter/}{converter}.
#' @return A dataframe with price conversion information
#' @examples \dontrun{
#' get_price_conversion(1)
#' get_price_conversion(amount = 1, symbol = "BTC", convert = c("EUR","LTC","USD"))
#' get_price_conversion(amount = 1, id=1, time = Sys.Date()-100)
#' }
#' @export
get_price_conversion <- function(amount=NULL, id, symbol, time, convert, convert_id) {

        ## Check Inputs ##########
        if (is.null(amount)) {
                stop(cat(crayon::red(cli::symbol$cross,
                                     "You must define an amount.\n")))
        }
        if (!is.numeric(amount)) {
                stop(cat(crayon::red(cli::symbol$cross,
                                     "The amount must be numeric.\n")))
        }
        if (missing(symbol)) symbol <- NULL
        if (missing(id)) id <- NULL
        if (missing(time)) time <- NULL
        if (missing(convert)) convert <- NULL
        if (missing(convert_id)) convert_id <- NULL

        base_url <- .get_baseurl()

        ## Build Request (new API) ##########
        what <- paste0("tools/price-conversion")
        apiurl <- sprintf("https://%s/v1/%s?amount=%s", base_url, what, amount)

        args <- c(is.null(symbol), is.null(id))
        if (sum(args) == 2) {
                symbol <- "BTC"
        } else if (sum(args) != 1) {
                stop(cat(crayon::red(cli::symbol$cross,
                                     "You must use either 'symbol' or 'id'.\n")))
        }
        args <- c(is.null(convert), is.null(convert_id))
        if (sum(args) == 2) {
                convert <- "USD"
        } else if (sum(args) != 1) {
                stop(cat(crayon::red(cli::symbol$cross,
                                     "You must use either 'convert' or 'convert_id'.\n")))
        }

        if (!is.null(symbol))
                apiurl <- paste0(apiurl, "&symbol=", paste(symbol, collapse = ","))
        if (!is.null(id))
                apiurl <- paste0(apiurl, "&id=", paste(id, collapse = ","))
        if (!is.null(time))
                apiurl <- paste0(apiurl, "&time=", time)
        if (!is.null(convert))
                apiurl <- paste0(apiurl, "&convert=", paste0(convert, collapse=","))
        if (!is.null(convert_id))
                apiurl <- paste0(apiurl, "&convert_id=", paste0(convert_id, collapse=","))


        ## Make Request ##########
        req <- make_request(apiurl)

        ## Check Response ##########
        check_response(req)

        ## Modify Result ##########
        modify_result(req$content)
}
