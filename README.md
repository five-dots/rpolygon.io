R Polygon.io Package
===

This is a simple wrapper package to interact with [Polygon.io](https://polygon.io/)'s RESTful API. This package is now in Beta stage.

# Installation

Use devtools to install this package, as it's not on CRAN.

    install.packages("devtools")
    devtools::install_github("five-dots/rpolygon.io")

# Usage

First, a correct API key should be set as "POLYGON_KEY" in the environment variable. To confirm the key in your environment, run the following command.

```r
Sys.getenv("POLYGON_KEY")
```

Then, you can use `polygon()` function by passing an API path as the first argument.

```r
library(rpolygon.io)
last_aapl <- polygon("/v1/last/stocks/AAPL")
```

Query arguments can be passed by named list or vector.

```r
prev_aapl <- polygon("/v2/aggs/ticker/AAPL/prev", args = list(unadjusted = "true"))
```

You can also add addtional arguments for `httr::GET()`.

```r
prev_aapl <- polygon("/v2/aggs/ticker/AAPL/prev", args = list(unadjusted = "true"), httr::verbose())
```

# Resources

- [Polygon.io API Reference](https://polygon.io/docs/#!/Meta-Data/get_v1_meta_symbols_symbol)

