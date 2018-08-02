#' Prepare existing project for building with *rmake*.
#'
#' This function creates a `Makefile.R` with an empty *rmake* project
#' and generates a basic `Makefile` from it.
#'
#' @param path Path to the target directory where to create files. Use "." for the current directory.
#' @seealso [makefile()], [rule()]
#' @author Michal Burda
#' @examples
#' # creates/overrides Makefile.R and Makefile in a temporary directory
#' rmakeSkeleton(path=tempdir())
#' @export
rmakeSkeleton <- function(path) {
  assert_that(is.character(path) && is.scalar(path))
  olddir <- setwd(path)
  cat('library(rmake)\n\njob <- list()\n\nmakefile(job, "Makefile")\n', file='Makefile.R')
  makefile(list(), 'Makefile')
  setwd(olddir)
}
