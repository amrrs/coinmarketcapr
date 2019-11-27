#' Returns a paginated list of all cryptocurrency exchanges by CoinMarketCap ID.
#' We recommend using this convenience endpoint to lookup and utilize our unique
#' exchange id across all endpoints as typical exchange identifiers may change
#' over time. As a convenience you may pass a comma-separated list of exchanges
#' by slug to filter this list to only those you require.
#' @title Get all cryptocurrency exchanges
#' @references \href{https://coinmarketcap.com/api/documentation/v1/#operation/getV1ExchangeMap}{API documentation}
#' @inheritParams get_crypto_map
#' @family Exchanges
#' @return A dataframe with exchange values
#' @examples \dontrun{
#' get_exchange_map()
#' get_exchange_map(listing_status = "inactive",
#'                  slug = "binance", start = 5, limit = 100)
#' }
#' @export
get_exchange_map <- function(...) {
    ## Input Check ##########
    base_url <- .get_baseurl()

    ## Build Request (new API) ##########
    what <- "exchange/map"
    whatelse <- list(...)
    whatelse <- transform_args(whatelse)
    if (!is.null(whatelse)) {
        what <- paste0(what, "?", whatelse)
    }

    apiurl <- sprintf("https://%s/v1/%s", base_url, what)

    ## Make Request ##########
    req <- make_request(apiurl)

    ## Check Response ##########
    check_response(req)

    ## Modify Result ##########
    modify_result(req$content)
}

#' Returns all static metadata for one or more exchanges.
#' This information includes details like launch date, logo,
#' official website URL, social links, and market fee documentation URL.
#' @title Get all cryptocurrency exchanges metadata
#' @references \href{https://coinmarketcap.com/api/documentation/v1/#operation/getV1ExchangeInfo}{API documentation}
#' @param id Alternatively pass one or more CoinMarketCap cryptocurrency IDs.
#' Example: c(1,2)
#' @param slug Alternatively pass a vector of exchange slugs.
#' Example: c("binance","cryptsy")
#' @return A dataframe with exchange metadata values
#' @family Exchanges
#' @examples \dontrun{
#' get_exchange_meta(id = 5)
#' get_exchange_meta(slug = c("binance", "cryptsy"))
#' }
#' @export
get_exchange_meta <- function(id = NULL, slug = NULL) {
    ## Input Check ##########
    base_url <- .get_baseurl()

    ## Build Request (new API) ##########
    what <- "exchange/info"
    args <- c(is.null(id), is.null(slug))
    if (sum(args) != 1)
        stop(cat(crayon::red(cli::symbol$cross,
                             "You must use either 'id' or 'slug'.\n")))
    if (!is.null(id))
        what <- paste0(what, "?id=", paste(id, collapse = ","))
    if (!is.null(slug))
        what <- paste0(what, "?slug=", paste(slug, collapse = ","))


    apiurl <- sprintf("https://%s/v1/%s", base_url, what)

    ## Make Request ##########
    req <- make_request(apiurl)

    ## Check Response ##########
    check_response(req)

    ## Modify Result ##########
    modify_result(req$content, case = 4)
}
