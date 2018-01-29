# coinmarketcapr

[![Build Status](https://travis-ci.org/amrrs/coinmarketcapr.svg?branch=master)](https://travis-ci.org/amrrs/coinmarketcapr) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/coinmarketcapr)](https://cran.r-project.org/package=coinmarketcapr) [![DOWNLOADSTOTAL](https://cranlogs.r-pkg.org/badges/grand-total/coinmarketcapr)](https://cranlogs.r-pkg.org/badges/grand-total/coinmarketcapr) [![codecov](https://codecov.io/gh/amrrs/coinmarketcapr/branch/master/graph/badge.svg)](https://codecov.io/gh/amrrs/coinmarketcapr) [![rOpenSci](https://badges.ropensci.org/172_status.svg)](https://github.com/ropensci/onboarding/issues/172)



Overview
--------
The goal of *coinmarketcapr* is To get Cryptocurrencies Market Cap Prices from Coin Market Cap

Installation
------------

```coinmarketcapr``` can be directly installed from CRAN:

```r
install.packages("coinmarketcapr")
```

And the development version can be installed from Github:

``` r
# install.packages("devtools")
devtools::install_github("amrrs/coinmarketcapr")
```

Dependency Packages
------------

* jsonlite
* RCurl
* ggplot2

Getting started
---------------

``` r
library(coinmarketcapr)
latest_marketcap <- get_global_marketcap('EUR')
```

```coinmarketcapr``` can be loaded just like any other R-package with ```library(coinmarketcapr)```.

**Note:** If you're trying this behind a Firewall, you might get:
```Error in open.connection(con, "rb") : Timeout was reached```
To resolve this error, Please refer this link: [Configuring R to Use an HTTP or HTTPS Proxy](https://support.rstudio.com/hc/en-us/articles/200488488-Configuring-R-to-Use-an-HTTP-or-HTTPS-Proxy)

Examples
---------------
### Code 
```r
library(coinmarketcapr)

#get the global market cap details and assign it to a dataframe
latest_marketcap <- get_global_marketcap('EUR')
```

Courtesy
---------------
[Coinmarketcap API](https://coinmarketcap.com/api/)
