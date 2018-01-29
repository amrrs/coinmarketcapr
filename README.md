# coinmarketcapr

[![Build Status](https://travis-ci.org/amrrs/coinmarketcapr.svg?branch=master)](https://travis-ci.org/amrrs/coinmarketcapr) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/coinmarketcapr)](https://cran.r-project.org/package=coinmarketcapr) [![DOWNLOADSTOTAL](https://cranlogs.r-pkg.org/badges/grand-total/coinmarketcapr)](https://cranlogs.r-pkg.org/badges/grand-total/coinmarketcapr) [![codecov](https://codecov.io/gh/amrrs/coinmarketcapr/branch/master/graph/badge.svg)](https://codecov.io/gh/amrrs/coinmarketcapr) [![rOpenSci](https://badges.ropensci.org/172_status.svg)](https://github.com/ropensci/onboarding/issues/172)

Overview
--------
The goal of *coinmarketcapr* is to help R developers and Data Scientists to extract and monitor price and market cap of various Cryptocurrencies from 'CoinMarketCap' that lists many leading cryptocurrencies along with their price, 24h trade volume, market cap and much more in USD and other currencies. For more info, check [Coinmarketcap API](https://coinmarketcap.com/api/)

Installation
------------

The stable version of ```coinmarketcapr``` can be installed from CRAN:

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

`coinmarketcapr` depends on the following packages:

* jsonlite
* RCurl
* ggplot2

Hence, these packages will be automatically installed while installing `coinmarketcapr`.

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
### Example #1
**Extract Global Cryptocurreny Market cap:**
Code:
```r
library(coinmarketcapr)

#get the global market cap details and assign it to a dataframe
latest_marketcap <- get_global_marketcap('EUR')
latest_marketcap
```

Output:
```
> latest_marketcap
  total_market_cap_usd total_24h_volume_usd bitcoin_percentage_of_market_cap active_currencies
1         572176071090          22204830626                            33.44               897
  active_assets active_markets last_updated total_market_cap_eur total_24h_volume_eur
1           570           8235   1517252067          4.63216e+11          17976342525
```

Code of Conduct
---------------
Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

Contribution
---------------
Please feel free to report [issues](https://github.com/amrrs/coinmarketcapr/issues/new), comments, or feature requests.

Courtesy
---------------
[Coinmarketcap API](https://coinmarketcap.com/api/)
