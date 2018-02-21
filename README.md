[![Travis Build Status](https://travis-ci.org/beerda/rmake.svg?branch=master)](https://travis-ci.org/beerda/rmake) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/beerda/rmake?branch=master&svg=true)](https://ci.appveyor.com/project/beerda/rmake) [![codecov](https://codecov.io/gh/beerda/rmake/branch/master/graph/badge.svg)](https://codecov.io/gh/beerda/rmake) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/rmake)](https://cran.r-project.org/package=rmake)


rmake
=====

Makefile generator for R analytical projects


Installation
------------

To install *rmake*, simply issue the following command within your R session:

``` r
install.packages("devtools")
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

1. Let us assume that you have *rmake* installed.
2. Create a new directory (or an R studio project) and copy your ```dataset.csv``` into it.
3. Load *rmake* and create skeleton files for *rmake*:
   ``` r
   library(rmake)
   rmakeSkeleton()
   ```
   ```Makefile.R``` and ```Makefile``` will be created.
4. Create your file ```preprocess.R```, ```report.Rmd``` and ```details.Rmd```.
4. Edit ```Makefile.R``` as follows:
   ``` r
   library(rmake)
   job <- list(
       rRule('dataset.rds', 'preprocess.R', 'dataset.csv'),
       markdownRule('report.pdf', 'report.Rmd', 'dataset.rds'),
       markdownRule('details.pdf', 'details.Rmd', 'dataset.rds')
   )
   ```
   This will create three build rules: processing of ```preprocess.R``` and execution of ```report.Rmd``` and ```details.Rmd```
   in order to generate resulting PDF files.
5. Run ```make``` or build your project in R Studio (Build/Build all). This will automatically re-generate ```Makefile```
   and execute ```preprocess.R``` and the generation of ```report.Rmd``` and ```details.Rmd``` accordingly to the changes
   made to source files.
6. Enjoy.



Advanced Usage
--------------

Coming soon.
