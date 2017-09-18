currencies_list <- c("AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PKR", "PLN", "RUB", "SEK", "SGD", "THB", "TRY", "TWD", "ZAR", "USD")


#' To extract Global Market Cap of Leading Cryptocurrencies
#'
#' @param currency currency code - Default is 'USD'
#' @return A dataframe of Cryptocurrencies with Currency prices, Market Cap, Rank and more paramaters
#' @examples
#' get_global_marketcap('AUD')
#' get_global_marketcap('EUR')


get_global_marketcap <- function(currency = 'USD') {

        stopifnot(currency %in% currencies_list)

        jsonlite::fromJSON(RCurl::getURL(paste0('https://api.coinmarketcap.com/v1/global/?convert=',currency)))

}


#' To extract Global Market Cap of Leading Cryptocurrencies
#'
#' @param currency currency code - Default is 'USD'
#' @return A dataframe of top Cryptocurrencies with Currency prices, Market Cap, Rank and more paramaters
#' @examples
#' get_marketcap_ticker_all('EUR')
#' get_marketcap_ticker_all('GBP')


get_marketcap_ticker_all <- function(currency = 'USD') {

        stopifnot(currency %in% currencies_list)

        jsonlite::fromJSON(RCurl::getURL(paste0('https://api.coinmarketcap.com/v1/ticker/?convert=',currency)))

}

#' To plot Top 5 Cryptocurrencies
#'
#' @param currency currency code - Default is 'USD'
#' @return A plot of top Cryptocurrencies based on their rank
#' @examples
#' plot_top_5_currencies('EUR')
#' plot_top_5_currencies('GBP')



plot_top_5_currencies <- function(currency = 'USD') {

        stopifnot(currency %in% currencies_list)

        temp <- jsonlite::fromJSON(RCurl::getURL(paste0('https://api.coinmarketcap.com/v1/ticker/?convert=',currency)))

        temp <- head(temp,5)

        barplot(as.numeric(temp$price_usd),names.arg = temp$name)

        temp$price_usd <- as.numeric(temp$price_usd)

        ggplot2::ggplot(temp, aes(name,price_usd))+ggplot2::geom_bar( stat = 'identity')

}

