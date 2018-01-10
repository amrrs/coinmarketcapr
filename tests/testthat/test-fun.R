library(coinmarketcapr)
context("get_global_marketcap Output DF Check")

test_that("The output dataframe Type is ",{

        expect_equal(class(get_global_marketcap('USD')),"data.frame")
        expect_equal(class(get_global_marketcap('EUR')),"data.frame")

})

context("get_marketcap_ticker_all Output DF Check")

test_that("The output dataframe Type is ",{

        expect_equal(class(get_marketcap_ticker_all('USD')),"data.frame")
        expect_equal(class(get_marketcap_ticker_all('EUR')),"data.frame")

})


context('plot_top_5_currencies Output ggplot Check')

test_that("The output ggplot Type is ",{

        expect_is(class(plot_top_5_currencies('USD')),"ggplot")
        expect_is(class(plot_top_5_currencies()),"ggplot")

})
