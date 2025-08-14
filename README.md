<!-- badges: start -->
[![R-CMD-check](https://github.com/beerda/rmake/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/beerda/rmake/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/beerda/rmake/graph/badge.svg)](https://app.codecov.io/gh/beerda/rmake)
<!-- badges: end -->

rmake
=====

Makefile generator for R analytical projects


Installation
------------

To install *rmake*, simply issue the following command within your R session:

``` r
install.packages("rmake")
```

Alternatively, you can install the latest development version from GitHub using the *devtools* package:

``` r
install.packages("devtools")
library(devtools)
devtools::install_github("beerda/rmake")
```

Setup
-----

The package requires the ```R_HOME``` environment variable to be properly set.


Basic Usage
-----------

Suppose you have a file ```dataset.csv```. You want to pre-process it and store the results into ```dataset.rds```
within the ```preprocess.R``` R script.  After that, ```dataset.rds``` is then an input file for
```report.Rmd``` and ```details.Rmd```, which are R-Markdown scripts that generate ```report.pdf``` and
```details.pdf```. The whole project can be initialized with *rmake* as follows:

1. Let us assume that you have *rmake* package as well as the ```make``` tool properly installed.
2. Create a new directory (or an R studio project) and copy your ```dataset.csv``` into it.
3. Load *rmake* and create skeleton files for *rmake*:
   ``` r
   library(rmake)
   rmakeSkeleton('.')
   ```
   ```Makefile.R``` and ```Makefile``` will be created.
4. Create your file ```preprocess.R```, ```report.Rmd``` and ```details.Rmd```.
5. Edit ```Makefile.R``` as follows:
   ``` r
   library(rmake)
   job <- c('dataset.csv' %>>% rRule('preprocess.R') %>>% 'dataset.rds' %>>% markdownRule('report.Rmd') %>>% 'report.pdf',
            'dataset.rds' %>>% markdownRule('details.Rmd') %>>% 'details.pdf')
   )
   makefile(job, 'Makefile')
   ```
   This will create three build rules: processing of ```preprocess.R``` and execution of ```report.Rmd``` and ```details.Rmd```
   in order to generate resulting PDF files.
6. Run ```make``` or build your project in R Studio (Build/Build all). This will automatically re-generate ```Makefile```
   and execute ```preprocess.R``` and the generation of ```report.Rmd``` and ```details.Rmd``` accordingly to the changes
   made to source files.


