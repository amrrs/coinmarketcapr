currencies_list <- c("AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "CZK", "DKK", 
  "EUR", "GBP", "HKD", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", 
  "MYR", "NOK", "NZD", "PHP", "PKR", "PLN", "RUB", "SEK", "SGD", "THB", 
  "TRY", "TWD", "ZAR", "USD")


#' To extract Global Market Cap of Cryptocurrency Market
#'
#' @param currency currency code - Default is 'USD'
#' @return A dataframe of to get global market cap of Cryptocurrencies Market
#' @examples
#' get_global_marketcap('AUD')
#' get_global_marketcap('EUR')
#' @importFrom jsonlite fromJSON
#' @importFrom RCurl getURL
#' @export
get_global_marketcap <- function(currency = 'USD') {

  stopifnot(currency %in% currencies_list)

  data.frame(fromJSON(getURL(
    paste0('https://api.coinmarketcap.com/v1/global/?convert=',currency))))
}


#' Extract Global Market Cap of Leading Cryptocurrencies
#'
#' @param currency currency code - Default is 'USD'
#' @return A dataframe of top Cryptocurrencies with id, name, symbol, rank, price_usd, price_btc, 24h_volume_usd, market_cap_usd, available_supply, total_supply, percent_change_1h, percent_change_24h, percent_change_7d, last_updated
#' @examples
#' get_marketcap_ticker_all('EUR')
#' get_marketcap_ticker_all('GBP')
#' @importFrom jsonlite fromJSON
#' @importFrom RCurl getURL
#' @export
get_marketcap_ticker_all <- function(currency = 'USD') {

  stopifnot(currency %in% currencies_list)

  data.frame(fromJSON(getURL(
    paste0('https://api.coinmarketcap.com/v1/ticker/?convert=', currency, 
           '&limit=0'))))
}

#' Plot The Price of the Largest Market Cap Cryptocurrencies 
#'
#' @param currency currency code - Default is 'USD'
#' @param k the number of top cryptocurrencies to plot (default is 5)
#' @return A ggplot of top Cryptocurrencies based on their rank
#' @examples
#' plot_top_currencies('EUR')
#' plot_top_currencies('GBP')
#' @importFrom jsonlite fromJSON
#' @importFrom RCurl getURL
#' @importFrom ggplot2 ggplot aes_string geom_bar
#' @export
plot_top_currencies <- function(currency = 'USD', k = 5) {

  stopifnot(currency %in% currencies_list)

  k <- as.integer(k)
  if (k < 1) {
    stop("Parameter k must be a integer value greater than zero.")
  } 

  temp <- data.frame(fromJSON(getURL(
    paste0('https://api.coinmarketcap.com/v1/ticker/?convert=',currency))))

  if (k > nrow(temp)) {
    warning(paste0("The argument provided to k is greater than the number ",
                   "of cryptocurrencies. Only ", nrow(temp), 
                   " will be plotted."))
  }

  temp <- temp[seq_len(min(k, nrow(temp))), ]

  ggplot(temp, aes_string('name','price_usd')) + geom_bar(stat = 'identity')
}


