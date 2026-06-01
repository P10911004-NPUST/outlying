# **outlying**

<!-- badges: start -->
[![Repo_Status_Badge](https://img.shields.io/badge/Status-Active-brightgreen.svg)]()
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/outlying?color=brightgreen)](https://cran.r-project.org/package=outlying)
[![R-CMD-check](https://github.com/P10911004-NPUST/outlying/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/P10911004-NPUST/outlying/actions/workflows/R-CMD-check.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-maroon.svg)](https://opensource.org/licenses/MIT)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/outlying)](https://cranlogs.r-pkg.org/badges/outlying)
[![Downloads](https://cranlogs.r-pkg.org/badges/outlying?color=blue)](https://cranlogs.r-pkg.org/badges/outlying)
<!-- badges: end -->

An R package which provides functions for detecting outliers in datasets using statistical methods. 
It supports identification of anomalous observations in numerical data and is intended for use in data cleaning, 
exploratory data analysis, and preprocessing workflows.

# Installation

You can install the package from [CRAN](https://cran.r-project.org/web/packages/outlying/index.html) with:

``` r
install.packages("outlying")
```

or the development version from [GitHub](https://github.com/P10911004-NPUST/outlying) with:

``` r
if (!require(devtools)) install.packages("devtools")
devtools::install_github("P10911004-NPUST/outlying")
```

# Quick start

```r
x <- round(c(rnorm(10, 0, 1), 5))
Grubbs_test(x)
```

<br>

# TODO
- [] Implement generalized extreme studentized deviate test (GEN-ESD)  
  - [Rosner (1983)](https://www.jstor.org/stable/1268549?seq=4)
- [] Implement ROUT method  
  - [Motulsky and Brown (2006)](https://link.springer.com/article/10.1186/1471-2105-7-123)
