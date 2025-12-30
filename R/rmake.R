#' Makefile generator for R analytical projects
#'
#' \pkg{rmake} creates and maintains a build process for complex analytic tasks in R.
#' The package allows easy generation of a Makefile for the (GNU) 'make' tool, which drives the build process
#' by executing build commands (in parallel) to update results according to given dependencies
#' on changed data or updated source files.
#'
#' Note: The package requires the `R_HOME` environment variable to be properly set.
#'
#' @section Basic Usage:
#' Suppose you have a file `dataset.csv`. You want to pre-process it and store the results in
#' `dataset.rds` using the `preprocess.R` R script. After that, `dataset.rds` is then
#' an input file for `report.Rmd` and `details.Rmd`, which are R-Markdown scripts that generate
#' `report.pdf` and `details.pdf`. The whole project can be initialized with \pkg{rmake} as follows:
#'
#' \enumerate{
#'   \item Let us assume that you have the \pkg{rmake} package as well as the `make` tool properly installed.
#'   \item Create a new directory (or an R studio project) and copy your `dataset.csv` into it.
#'   \item Load the \pkg{rmake} package and create skeleton files for it: \cr
#'     `library(rmake)` \cr
#'     `rmakeSkeleton('.')` \cr\cr
#'     `Makefile.R` and `Makefile` will be created in the current directory (`'.'`).
#'   \item Create your files `preprocess.R`, `report.Rmd`, and `details.Rmd`.
#'   \item Edit `Makefile.R` as follows: \cr
#'     `library(rmake)` \cr
#'     `job <- list(` \cr
#'     `    rRule('dataset.rds', 'preprocess.R', 'dataset.csv'),` \cr
#'     `    markdownRule('report.pdf', 'report.Rmd', 'dataset.rds'),` \cr
#'     `    markdownRule('details.pdf', 'details.Rmd', 'dataset.rds')` \cr
#'     `)` \cr
#'     `makefile(job, "Makefile")`\cr\cr
#'     This will create three build rules: one for processing `preprocess.R` and two for executing `report.Rmd`
#'     and `details.Rmd` to generate the resulting PDF files.
#'   \item Run `make` or build your project in R Studio (Build/Build all).
#'     This will automatically re-generate the `Makefile` and execute `preprocess.R` and the generation
#'     of `report.Rmd` and `details.Rmd` according to the changes made to the source files.
#' }
#' @keywords internal
"_PACKAGE"
