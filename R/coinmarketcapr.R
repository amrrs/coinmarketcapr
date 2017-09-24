#'@import ggplot2
#'@import RCurl
#'@import jsonlite

currencies_list <- c("AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PKR", "PLN", "RUB", "SEK", "SGD", "THB", "TRY", "TWD", "ZAR", "USD")


#' To extract Global Market Cap of Cryptocurrency Market
#'
#' @param currency currency code - Default is 'USD'
#' @return A dataframe of to get global market cap of Cryptocurrencies Market
#' @examples
#' get_global_marketcap('AUD')
#' get_global_marketcap('EUR')
#' @export

get_global_marketcap <- function(currency = 'USD') {

        stopifnot(currency %in% currencies_list)

        data.frame(jsonlite::fromJSON(RCurl::getURL(paste0('https://api.coinmarketcap.com/v1/global/?convert=',currency))))

}


#' To extract Global Market Cap of Leading Cryptocurrencies
#'
#' @param currency currency code - Default is 'USD'
#' @return A dataframe of top Cryptocurrencies with id, name, symbol, rank, price_usd, price_btc, 24h_volume_usd, market_cap_usd, available_supply, total_supply, percent_change_1h, percent_change_24h, percent_change_7d, last_updated
#' @examples
#' get_marketcap_ticker_all('EUR')
#' get_marketcap_ticker_all('GBP')
#' @export

get_marketcap_ticker_all <- function(currency = 'USD') {

        stopifnot(currency %in% currencies_list)

        data.frame(jsonlite::fromJSON(RCurl::getURL(paste0('https://api.coinmarketcap.com/v1/ticker/?convert=',currency))))

}

#' To plot Top 5 Cryptocurrencies
#'
#' @param currency currency code - Default is 'USD'
#' @return A ggplot of top Cryptocurrencies based on their rank
#' @examples
#' plot_top_5_currencies('EUR')
#' plot_top_5_currencies('GBP')
#' @export


plot_top_5_currencies <- function(currency = 'USD') {

        stopifnot(currency %in% currencies_list)

        temp <- data.frame(jsonlite::fromJSON(RCurl::getURL(paste0('https://api.coinmarketcap.com/v1/ticker/?convert=',currency))))

        temp <- temp[1:5,]

        #temp$price_usd <- as.numeric(temp$price_usd)

        ggplot2::ggplot(temp, ggplot2::aes_string('name','price_usd'))+ggplot2::geom_bar(stat = 'identity')

}


