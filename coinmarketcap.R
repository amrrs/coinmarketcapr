# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

currencies_list <- c("AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PKR", "PLN", "RUB", "SEK", "SGD", "THB", "TRY", "TWD", "ZAR")

get_global_marketcap <- function(currency = 'USD') {

  stopifnot(currency %in% currencies_list)

  jsonlite::fromJSON(RCurl::getURL(paste0('https://api.coinmarketcap.com/v1/global/?convert=',currency)))

}

get_marketcap_ticker_all <- function(currency = 'USD') {

  stopifnot(currency %in% currencies_list)

  jsonlite::fromJSON(RCurl::getURL(paste0('https://api.coinmarketcap.com/v1/ticker/?convert=',currency)))

}

plot_top_5_currencies <- function(currency = 'USD') {

  stopifnot(currency %in% currencies_list)

  temp <- jsonlite::fromJSON(RCurl::getURL(paste0('https://api.coinmarketcap.com/v1/ticker/?convert=',currency)))

  temp <- head(temp,5)

  barplot(as.numeric(temp$price_usd),names.arg = temp$name)

  temp$price_usd <- as.numeric(temp$price_usd)

  ggplot2::ggplot(temp, aes(name,price_usd))+ggplot2::geom_bar( stat = 'identity')

}

#plot_top_5_currencies()



