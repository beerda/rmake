#' Makefile generator for R analytical projects
#'
#' \pkg{rmake} creates and maintains a build process for complex analytic tasks in R.
#' Package allows to easily generate Makefile for the (GNU) 'make' tool, which drives the build process
#' by (paralelly) executing build commands in order to update results accordingly to given dependencies
#' on changed data or updated source files.
#'
#' Note: The package requires the `R_HOME` environment variable to be properly set.
#'
#' @section Basic Usage:
#' Suppose you have a file `dataset.csv`. You want to pre-process it and store the results into
#' `dataset.rds` within the `preprocess.R` R script.  After that, `dataset.rds` is then
#' an input file for `report.Rmd` and `details.Rmd`, which are R-Markdown scripts that generate
#' `report.pdf` and `details.pdf`. The whole project can be initialized with \pkg{rmake} as follows:
#'
#' \enumerate{
#'   \item Let us assume that you have \pkg{rmake} package as well as the `make` tool properly installed.
#'   \item Create a new directory (or an R studio project) and copy your `dataset.csv` into it.
#'   \item Load \pkg{rmake} package and create skeleton files for it: \cr
#'     `library(rmake)` \cr
#'     `rmakeSkeleton('.')` \cr\cr
#'     `Makefile.R` and `Makefile` will be created in current directory (`'.'`).
#'   \item Create your file `preprocess.R`, `report.Rmd` and `details.Rmd`.
#'   \item Edit `Makefile.R` as follows: \cr
#'     `library(rmake)` \cr
#'     `job <- list(` \cr
#'     `    rRule('dataset.rds', 'preprocess.R', 'dataset.csv'),` \cr
#'     `    markdownRule('report.pdf', 'report.Rmd', 'dataset.rds'),` \cr
#'     `    markdownRule('details.pdf', 'details.Rmd', 'dataset.rds')` \cr
#'     `)` \cr
#'     `makefile(job, "Makefile")`\cr\cr
#'     This will create three build rules: processing of `preprocess.R` and execution of `report.Rmd`
#'     and `details.Rmd` in order to generate resulting PDF files.
#'   \item Run `make` or build your project in R Studio (Build/Build all).
#'     This will automatically re-generate `Makefile` and execute `preprocess.R` and the generation
#'     of `report.Rmd` and `details.Rmd` accordingly to the changes made to source files.
#' }
"_PACKAGE"
