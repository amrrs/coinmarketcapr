library(coinmarketcapr)
context("get_global_marketcap Output DF Check")

test_that("The output dataframe Type is ",{

        expect_equal(class(get_global_marketcap('USD')),"data.frame")
        expect_equal(class(get_global_marketcap('EUR')),"data.frame")

})
