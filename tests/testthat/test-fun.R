library(coinmarketcapr)
library(ggplot2)

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


context('plot_top_currencies Output ggplot Check')

test_that("The output ggplot Type is ",{
  expect_true(is.ggplot(plot_top_currencies('USD')))
  expect_true(is.ggplot(plot_top_currencies()))


  expect_error(plot_top_currencies(k = 0))
  expect_warning(plot_top_currencies(k = 10000))

})
