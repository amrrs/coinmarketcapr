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

Dependencies
------------

`coinmarketcapr` depends on the following packages:

* jsonlite
* curl
* ggplot2

Hence, these packages will be automatically installed while installing `coinmarketcapr`.

Also note that, `coinmarketcapr` connects with Coinmarketcap API, hence it requires active internet connection for that. 


What's happening
----------------

Inside this `coinmarketcapr` package, The function that you call from `coinmarketcapr` connects with the Coinmarketcap API using `curl` (via Internet) and retreives the required data in the form a `json` file which is then parsed with `jsonlite` and then flattened/converted to a dataframe and stored in your R Environment in the given variable name. 

Getting started
---------------

``` r
library(coinmarketcapr)
latest_marketcap <- get_global_marketcap('EUR')
```

```coinmarketcapr``` can be loaded just like any other R-package with ```library(coinmarketcapr)```.

**Note:** `coinmarketcapr` package requires internet connection to function. If you're trying this behind a Firewall, you might get:
```Error in open.connection(con, "rb") : Timeout was reached```
To resolve this error, Please refer this link: [Configuring R to Use an HTTP or HTTPS Proxy](https://support.rstudio.com/hc/en-us/articles/200488488-Configuring-R-to-Use-an-HTTP-or-HTTPS-Proxy)

Examples
---------------

### Example #1

**Extract Global Cryptocurreny Market cap in Euro Currency:**

Code:

```r
library(coinmarketcapr)

#get the global market cap details and assign it to a dataframe
latest_marketcap <- get_global_marketcap('EUR')
```

Output:
```
> latest_marketcap
  total_market_cap_usd total_24h_volume_usd bitcoin_percentage_of_market_cap active_currencies
1         572176071090          22204830626                            33.44               897
  active_assets active_markets last_updated total_market_cap_eur total_24h_volume_eur
1           570           8235   1517252067          4.63216e+11          17976342525
```

### Example #2

**Extract Details of all the cryptocurrenices offered by Coinmarketcap**

Code:
```r
library(coinmarketcapr)

#get the global market cap details and assign it to a dataframe
all_coins <- get_marketcap_ticker_all()
```

Output:
```
> head(all_coins)
            id         name symbol rank price_usd  price_btc X24h_volume_usd market_cap_usd
1      bitcoin      Bitcoin    BTC    1   11364.2        1.0    7204860000.0   191300965330
2     ethereum     Ethereum    ETH    2   1188.77   0.105643    3967330000.0   115651691385
3       ripple       Ripple    XRP    3   1.34538 0.00011956    1454990000.0  52118867955.0
4 bitcoin-cash Bitcoin Cash    BCH    4   1673.99   0.148764     387728000.0  28354942390.0
5      cardano      Cardano    ADA    5  0.625696 0.00005560     242653000.0  16222464327.0
6      stellar      Stellar    XLM    6  0.588256 0.00005228     126236000.0  10511024430.0
  available_supply  total_supply    max_supply percent_change_1h percent_change_24h percent_change_7d
1       16833650.0    16833650.0    21000000.0             -0.11              -3.12              6.18
2       97286852.0    97286852.0          <NA>             -0.48              -3.53             21.04
3    38739142811.0 99993093880.0  100000000000              0.14               2.23              8.58
4       16938538.0    16938538.0    21000000.0             -0.18              -2.95              4.84
5    25927070538.0 31112483745.0 45000000000.0              0.06              -5.27             13.03
6    17868112573.0  103629819514          <NA>             -0.36              -6.79             27.08
  last_updated
1   1517252366
2   1517252352
3   1517252341
4   1517252357
5   1517252360
6   1517252345
```

Code of Conduct
---------------
Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

Contribution
---------------
Please feel free to report [issues](https://github.com/amrrs/coinmarketcapr/issues/new), comments, or feature requests. Please check out our [Contributing guidelines](CONTRIBUTING.md) before raising an issue or Pull Request. 

Courtesy
---------------
[Coinmarketcap API](https://coinmarketcap.com/api/)
