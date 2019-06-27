#' Get Valid Currencies
#' @return A character vector of valid currencies supported by coinmarketcap API
#' @examples
#' get_valid_currencies()
#' @export
get_valid_currencies <- function(){

        currencies_list <- c("AUD", "BRL", "CAD", "CHF",
                             "CLP", "CNY", "CZK", "DKK",
                             "EUR", "GBP", "HKD", "HUF",
                             "IDR", "ILS", "INR", "JPY",
                             "KRW", "MXN", "MYR", "NOK",
                              "NZD", "PHP", "PKR", "PLN",
                              "RUB", "SEK", "SGD", "THB",
                             "TRY", "TWD", "ZAR", "USD")

        return(currencies_list)
}

#' Extract Global Market Cap of Cryptocurrency Market
#'
#' @param currency currency code - Default is 'USD'
#' @return A dataframe of to get global market cap of Cryptocurrencies Market
#' @examples
#' get_global_marketcap('AUD')
#' get_global_marketcap('EUR')
#' @importFrom jsonlite fromJSON
#' @importFrom curl curl_fetch_memory
#' @export
get_global_marketcap <- function(currency = 'USD') {

  stopifnot(currency %in% get_valid_currencies())

  d <- data.frame(fromJSON(rawToChar(curl_fetch_memory(
    paste0('https://api.coinmarketcap.com/v1/global/?convert=',currency))$content)))

  d$last_updated  <- as.POSIXct(as.numeric(d$last_updated), origin = as.Date("1970-01-01"))
  d
}


#' Extract Global Market Cap of Leading Cryptocurrencies
#'
#' @param currency currency code - Default is 'USD'
#' @return A dataframe of top Cryptocurrencies with id, name, symbol, rank, price_usd, price_btc, 24h_volume_usd, market_cap_usd, available_supply, total_supply, percent_change_1h, percent_change_24h, percent_change_7d, last_updated
#' @examples
#' get_marketcap_ticker_all('EUR')
#' get_marketcap_ticker_all('GBP')
#' @importFrom jsonlite fromJSON
#' @importFrom curl curl_fetch_memory
#' @export
get_marketcap_ticker_all <- function(currency = 'USD') {

  stopifnot(currency %in% get_valid_currencies())

  d <- data.frame(fromJSON(rawToChar(curl_fetch_memory(
    paste0('https://api.coinmarketcap.com/v1/ticker/?convert=', currency,
           '&limit=0'))$content)))

  d[,4:15] <- apply(d[,4:15], 2, function(x) as.numeric(as.character(x)))
  d$last_updated  <- as.POSIXct(d$last_updated, origin = as.Date("1970-01-01"))
  d
}

#' Plot The Price of the Largest Market Cap Cryptocurrencies
#'
#' @param currency currency code (default is 'USD')
#' @param k the number of top cryptocurrencies to plot (default is 5)
#' @param bar_color a valid color name or hexadecimal color code (default is 'grey')
#' @return A ggplot of top Cryptocurrencies based on their rank (Market Cap)
#' @examples
#' plot_top_currencies('EUR')
#' plot_top_currencies('GBP')
#' @importFrom jsonlite fromJSON
#' @importFrom curl curl_fetch_memory
#' @importFrom ggplot2 ggplot aes_string geom_bar xlab ylab ggtitle coord_flip
#' @export
plot_top_currencies <- function(currency = 'USD', k = 5, bar_color = 'grey') {

  stopifnot(currency %in% get_valid_currencies())

  k <- as.integer(k)
  if (k < 1) {
    stop("Parameter k must be a integer value greater than zero.")
  }

  temp <- data.frame(fromJSON(rawToChar(curl_fetch_memory(
    paste0('https://api.coinmarketcap.com/v1/ticker/?convert=',currency))$content)))

  if (k > nrow(temp)) {
    warning(paste0("The argument provided to k is greater than the number ",
                   "of cryptocurrencies. Only ", nrow(temp),
                   " will be plotted."))
  }

  temp <- temp[seq_len(min(k, nrow(temp))), ]

  temp[,tolower(paste0('price_',currency))] <- round(as.numeric(temp[,tolower(paste0('price_',currency))]),2)
  ggplot(temp, aes_string('name',tolower(paste0('price_',currency)))) +
          geom_bar(stat = 'identity', fill = bar_color) +
          ylab(paste0('Price in ',currency)) +
          xlab('Cryptocurrencies') +
          ggtitle(paste0('Top ',k,' Cryptocurrencies with Largest Marketcaps')) +
          coord_flip()
}


