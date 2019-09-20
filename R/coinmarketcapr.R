#' coinmarketcapr: Cryptocurrency Market Cap Prices from CoinMarketCap
#'
#' @description
#' Extract and monitor price and market cap of 'Cryptocurrencies'
#' from 'CoinMarketCap' <https://coinmarketcap.com/api/> that lists many leading
#' cryptocurrencies along with their price, 24h trade volume, market cap and
#' much more in USD and other currencies.
#'
#' @section See Also:
#' Useful links:
#' * [https://coinmarketcap.com/api/](https://coinmarketcap.com/api/)
#' * [https://github.com/amrrs/coinmarketcapr](https://github.com/amrrs/coinmarketcapr)
#' * Report bugs at [https://github.com/amrrs/coinmarketcapr/issues](https://github.com/amrrs/coinmarketcapr/issues)
#'
#' @importFrom jsonlite fromJSON prettify
#' @importFrom curl curl_fetch_memory new_handle handle_setheaders
#' @importFrom ggplot2 ggplot aes_string geom_bar xlab ylab ggtitle coord_flip
#' @importFrom crayon green
#' @importFrom cli symbol
#' @importFrom data.table rbindlist setDT
#'
#' @docType package
#' @name coinmarketcapr
#' @md
NULL
