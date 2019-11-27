library(coinmarketcapr)
library(ggplot2)

sleeptime = 10

## No-API #####################
context("No API")
test_that("No API",{
    reset_setup()
    expect_error(get_exchange_map())
    expect_error(get_exchange_meta(id = 1))
    expect_error(get_crypto_map())
    expect_error(get_crypto_meta())
    expect_error(get_crypto_quotes())
    expect_error(get_crypto_marketpairs("EUR"))
    expect_error(get_crypto_ohlcv("EUR"))

    expect_error(make_request())

    ## get_crypto_listings ##################
    res <- expect_warning(get_crypto_listings())
    expect_is(res, "data.frame")

    ## get_global_marketcap ##################
    res <- expect_warning(get_global_marketcap('AUD'))
    expect_is(res, "data.frame")
})

## Utils #####################
context("Utils")
test_that("Utils",{
    reset_setup()
    setup("someinvalidkey")
    res <- get_setup()
    expect_is(res, "list")
    expect_true(length(res) == 2)
})

## Free-API #####################
context("Global-Metrics")
test_that("Global-Metrics - Free API",{
    setup('71618174-fd24-4c8f-8c94-83bc3e1cd68e')

    ## get_global_marketcap ##################
    res <- get_global_marketcap("EUR")
    expect_is(res, "data.frame")
    expect_false(anyNA(res))
    expect_true(nrow(res) == 1)

    Sys.sleep(sleeptime)
    res <- get_global_marketcap(latest = T, time_start = Sys.Date() - 180,
                                time_end = Sys.Date(), count = 10,
                                interval = "yearly")
    expect_is(res, "data.frame")
    expect_false(anyNA(res))
    expect_true(nrow(res) == 1)
})

context("Cryptocurrencies - Free API")
test_that("Cryptocurrencies - Free API",{
    coinmarketcapr::setup('71618174-fd24-4c8f-8c94-83bc3e1cd68e')

    ## get_crypto_map ####################
    res <- get_crypto_map()
    expect_is(res, "data.frame")
    expect_true(nrow(res) > 1)
    Sys.sleep(sleeptime)

    res <- get_crypto_map(symbol = "BTC")
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 1)
    Sys.sleep(sleeptime)

    res <- get_crypto_map(symbol = c("BTC", "ETH"))
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 2)
    Sys.sleep(sleeptime)

    res <- get_crypto_map(listing_status = "active", start = 1, limit = 10)
    expect_is(res, "data.frame")
    expect_true(all(res$is_active == 1))
    expect_true(nrow(res) == 10)
    Sys.sleep(sleeptime)

    res <- get_crypto_map(listing_status = "inactive", start = 1, limit = 10)
    expect_is(res, "data.frame")
    expect_true(all(res$is_active == 0))
    expect_true(nrow(res) == 10)
    Sys.sleep(sleeptime)


    ## get_crypto_meta ####################
    res <- get_crypto_meta()
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 1)
    Sys.sleep(sleeptime)

    res <- get_crypto_meta(symbol = c("BTC", "ETH"))
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 2)
    Sys.sleep(sleeptime)

    res <- get_crypto_meta(id = c(1, 2, 3, 4))
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 4)
    Sys.sleep(sleeptime)

    res <- get_crypto_meta(slug = c("bitcoin", "ethereum"))
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 2)
    Sys.sleep(sleeptime)

    expect_error(get_crypto_meta(slug = "bitcoin", id = 4))


    ## get_crypto_listings ####################
    res <- get_crypto_listings("GBP")
    expect_is(res, "data.frame")
    expect_true(nrow(res) > 1)
    Sys.sleep(sleeptime)

    res <- get_crypto_listings("GBP", latest = T, start = 1)
    expect_is(res, "data.frame")
    expect_true(nrow(res) > 1)
    Sys.sleep(sleeptime)

    ## get_crypto_quotes ####################
    res <- get_crypto_quotes()
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 1)
    Sys.sleep(sleeptime)

    res <- get_crypto_quotes(symbol = "ETH")
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 1)
    expect_true(res$symbol == "ETH")
    Sys.sleep(sleeptime)

    res <- get_crypto_quotes(symbol = c("ETH", "BTC"))
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 2)
    expect_true(all(res$symbol %in% c("ETH", "BTC")))
    Sys.sleep(sleeptime)

    res <- get_crypto_quotes(slug = c("litecoin", "dogecoin"))
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 2)
    expect_true(all(res$slug %in% c("litecoin", "dogecoin")))
    Sys.sleep(sleeptime)

    res <- get_crypto_quotes("USD", id = c(3, 4))
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 2)
    Sys.sleep(sleeptime)

    res <- get_crypto_quotes("EUR", id = c(3, 4))
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 2)
    Sys.sleep(sleeptime)

    expect_error(get_crypto_quotes("EUR", id = c(3, 4),
                                   slug = c("litecoin", "dogecoin")))
    expect_error(get_crypto_quotes("EUR", id = c(3, 4),
                                   symbol = "BTC"))
    expect_error(get_crypto_quotes("EUR", id = c(3, 4),
                                   symbol = "BTC", latest = FALSE))

})

context('Plots')
test_that("Plots ",{
    expect_true(is.ggplot(plot_top_currencies('USD')))
    Sys.sleep(sleeptime)

    expect_true(is.ggplot(plot_top_currencies()))
    Sys.sleep(sleeptime)

    expect_error(plot_top_currencies(k = 0))
    Sys.sleep(sleeptime)

    expect_warning(plot_top_currencies(k = 10000))
    Sys.sleep(sleeptime)
})


## Pro-API #####################
context("Cryptocurrencies - Pro API")
test_that("Cryptocurrencies - Pro API (Sandbox)",{
    coinmarketcapr::setup('5ca3ffee-dbb9-4dff-8f09-e1a9128dfa26', sandbox = TRUE)

    ## get_global_marketcap ####################
    res <- get_global_marketcap("EUR", latest = FALSE, count = 10)
    expect_is(res, "data.frame")
    expect_false(anyNA(res))
    Sys.sleep(sleeptime)

    expect_error(get_global_marketcap("EUR", latest = FALSE,
                         count = 10, interval = "yearly"))
    Sys.sleep(sleeptime)

    ## get_crypto_listings ####################
    date <- Sys.Date()-35
    res <- get_crypto_listings("GBP", latest = F, start = 1,
                               date = date, limit = 10,
                               sort = "price", sort_dir = "asc")
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 10)
    Sys.sleep(sleeptime)

    date <- format(Sys.Date()-35, "%Y-%m-%dT%H:%M:%S.000Z")
    res <- get_crypto_listings("GBP", latest = F, start = 1,
                        date = date, limit = 10,
                        sort = "price", sort_dir = "asc")
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 10)
    Sys.sleep(sleeptime)

    expect_error(get_crypto_listings("GBP", latest = F, start = 1,
                                     limit = 10, sort = "price"))

    ## get_crypto_marketpairs ####################
    res <- get_crypto_marketpairs("EUR")
    expect_is(res, "data.frame")
    expect_true(nrow(res) > 1)
    Sys.sleep(sleeptime)

    res <- get_crypto_marketpairs('EUR', slug = 'bitcoin')
    expect_is(res, "data.frame")
    expect_true(nrow(res) > 1)
    Sys.sleep(sleeptime)

    res <- get_crypto_marketpairs("EUR", id = 1)
    expect_is(res, "data.frame")
    expect_true(nrow(res) > 1)
    Sys.sleep(sleeptime)

    res <- get_crypto_marketpairs("EUR", symbol = "LTC")
    expect_is(res, "data.frame")
    expect_true(nrow(res) > 1)
    Sys.sleep(sleeptime)

    res <- get_crypto_marketpairs("EUR", symbol = "ETH", start = 10, limit = 20)
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 20)
    Sys.sleep(sleeptime)

    expect_error(get_crypto_marketpairs("EUR", symbol = "LTC", id = 5))

    ## get_crypto_ohlcv ####################
    res <- get_crypto_ohlcv(latest = T)
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 1)
    Sys.sleep(sleeptime)

    res <- get_crypto_ohlcv(latest = T, symbol = "BTC")
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 1)
    expect_true(res$symbol == "BTC")
    Sys.sleep(sleeptime)

    res <- get_crypto_ohlcv(latest = T, id = 1)
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 1)
    Sys.sleep(sleeptime)

    date <- format(Sys.Date()-35, "%Y-%m-%dT%H:%M:%S.000Z")
    res <- get_crypto_ohlcv(latest = F, id = 1, time_start = date)
    expect_is(res, "data.frame")
    expect_true(nrow(res) > 1)
    Sys.sleep(sleeptime)

    date <- format(Sys.Date()-35, "%Y-%m-%dT%H:%M:%S.000Z")
    res <- get_crypto_ohlcv(latest = F, symbol = "BTC", time_start = date)
    expect_is(res, "data.frame")
    expect_true(nrow(res) > 1)
    Sys.sleep(sleeptime)

    date <- format(Sys.Date()-35, "%Y-%m-%dT%H:%M:%S.000Z")
    dateend <- format(Sys.Date()-30, "%Y-%m-%dT%H:%M:%S.000Z")
    res <- get_crypto_ohlcv(latest = F, symbol = "BTC",
                     time_start = date, time_end = dateend,
                     time_period = "hourly", interval = "hourly",
                     currency = "EUR")
    expect_is(res, "data.frame")
    expect_true(nrow(res) > 1)
    Sys.sleep(sleeptime)

    expect_error(get_crypto_ohlcv(symbol = "BTC", id = 5))

    ## get_crypto_quotes ####################
    res <- get_crypto_quotes("EUR", latest = FALSE)
    expect_is(res, "data.frame")
    Sys.sleep(sleeptime)

    res <- get_crypto_quotes("EUR", id = 3:5, latest = FALSE)
    expect_is(res, "data.frame")
    Sys.sleep(sleeptime)

    res <- get_crypto_quotes("EUR", symbol = c("BTC","LTC"), latest = FALSE)
    expect_is(res, "data.frame")
    Sys.sleep(sleeptime)

    res <- get_crypto_quotes("EUR", symbol = c("BTC","LTC"), latest = FALSE,
                             count=10, interval = "45m")
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 10)
    Sys.sleep(sleeptime)
})

context("Exchanges - Pro API")
test_that("Exchanges - Pro API (Sandbox)",{
    setup('5ca3ffee-dbb9-4dff-8f09-e1a9128dfa26', sandbox = TRUE)

    ## get_exchange_map ####################
    res <- get_exchange_map()
    expect_is(res, "data.frame")
    expect_true(nrow(res) > 1)
    Sys.sleep(sleeptime)

    res <- get_exchange_map(slug = "binance")
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 1)
    Sys.sleep(sleeptime)

    res <- get_exchange_map(listing_status = "inactive", slug = "binance",
                            start = 5, limit = 100)
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 1)
    Sys.sleep(sleeptime)


    ## get_exchange_meta ####################
    res <- get_exchange_meta(id = 5)
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 1)
    Sys.sleep(sleeptime)

    res <- get_exchange_meta(slug = "binance")
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 1)
    Sys.sleep(sleeptime)

    expect_error(get_exchange_meta(id = 5, slug = "binance"))
    Sys.sleep(sleeptime)

    res <- get_exchange_meta(slug = c("binance", "cryptsy"))
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 2)
    Sys.sleep(sleeptime)

    res <- get_exchange_meta(id = 4:6)
    expect_is(res, "data.frame")
    expect_true(nrow(res) == 3)
})


